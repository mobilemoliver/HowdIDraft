//
//  YahooCommunicationController.m
//  HowdIDraft
//
//  Created by Mike Oliver on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "YahooCommunicationController.h"

#import "ThirdPartyKeys.h"
#import "YOSSocial.h"
#import "CoreDataManager.h"

#define CALLBACK_URL @"http://www.notarealurl.com/"

#define YQL_GAME_IDS @"'57', '58', '49', '62', '79', '78', '101', '102', '124', '125', '153', '154', '175', '176', '199', '200', '222', '223', '242', '257'"
#define YQL_GAMES [NSString stringWithFormat: @"select league_key, league_id, name from fantasysports.leagues where use_login=1 and game_key IN (%@)", YQL_GAME_IDS]
#define YQL_DRAFT @"select league_id, draft_results from fantasysports.draftresults where league_key IN (%@)"
#define YQL_TEAMS @"select league_id, standings.teams.team.team_key, standings.teams.team.team_id, standings.teams.team.name, standings.teams.team.team_points, standings.teams.team.team_standings, standings.teams.team.managers from fantasysports.leagues.standings where league_key IN (%@)"
#define YQL_PLAYERS @"select player_key, player_id, editorial_team_full_name, name.first, name.last, eligible_positions.position, player_stats.coverage_type, player_stats.season, player_stats.stats from fantasysports.players.stats where league_key='%@' and player_key IN (%@)"
#define YQL_LEAGUE_SETTINGS @"select league_key, league_id, name, draft_status, is_finished, settings.roster_positions, settings.stat_categories, settings.stat_modifiers from fantasysports.leagues.settings where league_key IN (%@)"

#define MAX_LEAGUES_PER_TEAM_REQUEST 4
#define MAX_LEAGUES_PER_DRAFT_REQUEST 999
#define MAX_PLAYERS_PER_REQUEST 25
#define MAX_LEAGUES_PER_SETTINGS_REQUEST 999

@implementation YahooCommunicationController

@synthesize delegate;
@synthesize pendingRequestBucket;
@synthesize requestingLeagueKey;

- (UIWebView *) authenticate
{
    // create a session by passing our   
    // consumer key, consumer secret and application id.  
    yahooSession = [[YOSSession sessionWithConsumerKey:YAHOO_CONSUMER_KEY
                                     andConsumerSecret:YAHOO_CONSUMER_SECRET
                                      andApplicationId:YAHOO_APP_ID] retain];      
    
    NSURL *authURL = [yahooSession sendUserToAuthorizationWithCallbackUrl:CALLBACK_URL];  
    webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    webView.delegate = self;
    [webView loadRequest: [NSURLRequest requestWithURL:authURL]];
    
    return webView;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *urlString = [[request URL] absoluteString];
    if ([urlString hasPrefix:CALLBACK_URL])
    {
        // parse the URL for the token
        NSString *oauthToken = [[self getParameter: @"oauth_token" forRequest: request] retain];
        NSString *oauthVerifier = [[self getParameter: @"oauth_verifier" forRequest: request] retain];
        NSLog(@"Token: %@, Verifier: %@", oauthToken, oauthVerifier);
        
        YOSAuthRequest *authRequest = [[YOSAuthRequest requestWithSession:yahooSession] retain];
        YOSAccessToken *accessToken = [[authRequest fetchAccessToken: yahooSession.requestToken withVerifier: oauthVerifier] retain];
        [yahooSession setAccessToken:accessToken];
        
        // dismiss the web view   
        [self.delegate authenticationFinished];
        
        return NO;
    }
    else
        return YES;
}

- (NSString *) getParameter: (NSString *) parameter forRequest: (NSURLRequest *) request
{
    NSString *query = [[request URL] query];
    NSArray *params = [query componentsSeparatedByString:@"&"];
    
    NSArray *nameValue = nil;
    for (NSString *param in params) 
    {
        nameValue = [param componentsSeparatedByString:@"="];
        if ([nameValue count] != 2)
            continue;
        
        if ([parameter isEqual: [nameValue objectAtIndex:0]])
            return [[nameValue objectAtIndex:1] autorelease];
    }
    
    return nil;
}

- (void)requestLeagueInfo 
{ 
    [self requestYahooDataWithYQL:YQL_GAMES andRequestType:YahooFantasyRequestTypeLeagues];
}  

- (void)requestDraftInfoForLeagues: (NSArray *) leagueIDs
{
    // Make a copy of the passed in leagueIDs so we don't remove from someone else's bucket
    NSMutableArray *leagueBucket = [NSMutableArray arrayWithArray:leagueIDs];
    NSMutableArray *currentRequestBucket = [NSMutableArray arrayWithCapacity:MAX_LEAGUES_PER_DRAFT_REQUEST];
    
    for (int i = 0; i < MAX_LEAGUES_PER_DRAFT_REQUEST; i++)
    {
        if ([leagueBucket count] > 0)
        {
            [currentRequestBucket addObject:[leagueBucket objectAtIndex:0]];
            [leagueBucket removeObjectAtIndex:0];
        }
    }
    
    if ([leagueBucket count] > 0)
        self.pendingRequestBucket = leagueBucket;
    else
        self.pendingRequestBucket = nil;
    
    NSString *formattedLeagueIDs = [[self quotesAndCommas:currentRequestBucket] retain];
    NSString *yql = [NSString stringWithFormat:YQL_DRAFT, formattedLeagueIDs];
    
    [self requestYahooDataWithYQL:yql andRequestType:YahooFantasyRequestTypeDraftInfo];
}

- (void) requestSettingsForLeagues: (NSMutableArray *) leagueIDs
{
    // Make a copy of the passed in leagueIDs so we don't remove from someone else's bucket
    NSMutableArray *leagueBucket = [NSMutableArray arrayWithArray:leagueIDs];
    NSMutableArray *currentRequestBucket = [NSMutableArray arrayWithCapacity:MAX_LEAGUES_PER_SETTINGS_REQUEST];
    
    for (int i = 0; i < MAX_LEAGUES_PER_SETTINGS_REQUEST; i++)
    {
        if ([leagueBucket count] > 0)
        {
            [currentRequestBucket addObject:[leagueBucket objectAtIndex:0]];
            [leagueBucket removeObjectAtIndex:0];
        }
    }
    
    if ([leagueBucket count] > 0)
        self.pendingRequestBucket = leagueBucket;
    else
        self.pendingRequestBucket = nil;
    
    NSString *formattedLeagueIDs = [[self quotesAndCommas:currentRequestBucket] retain];
    NSString *yql = [NSString stringWithFormat:YQL_LEAGUE_SETTINGS, formattedLeagueIDs];
    
    [self requestYahooDataWithYQL:yql andRequestType:YahooFantasyRequestTypeSettings];
    
}

- (void) requestTeamsForLeagues: (NSMutableArray *) leagueIDs
{
    // Make a copy of the passed in leagueIDs so we don't remove from someone else's bucket
    NSMutableArray *leagueBucket = [NSMutableArray arrayWithArray:leagueIDs];
    NSMutableArray *currentRequestBucket = [NSMutableArray arrayWithCapacity:MAX_LEAGUES_PER_TEAM_REQUEST];
    
    for (int i = 0; i < MAX_LEAGUES_PER_TEAM_REQUEST; i++)
    {
        if ([leagueBucket count] > 0)
        {
            [currentRequestBucket addObject:[leagueBucket objectAtIndex:0]];
            [leagueBucket removeObjectAtIndex:0];
        }
    }
    
    if ([leagueBucket count] > 0)
        self.pendingRequestBucket = leagueBucket;
    else
        self.pendingRequestBucket = nil;
    
    NSString *formattedLeagueIDs = [[self quotesAndCommas:currentRequestBucket] retain];
    NSString *yql = [NSString stringWithFormat:YQL_TEAMS, formattedLeagueIDs];
    
    [self requestYahooDataWithYQL:yql andRequestType:YahooFantasyRequestTypeTeams];
    
}

- (void) requestPlayerInfoForLeague: (NSString *) league_key andPlayerKeys: (NSMutableArray *) player_keys
{
    NSAssert(league_key, @"Attempting to retrieve players for nil league_key");
    
    self.requestingLeagueKey = league_key;
    
    NSMutableArray *playerBucket = [NSMutableArray arrayWithArray:player_keys];
    NSMutableArray *currentRequestBucket = [NSMutableArray arrayWithCapacity:MAX_PLAYERS_PER_REQUEST];
    
    for (int i = 0; i < MAX_PLAYERS_PER_REQUEST; i++)
    {
        if ([playerBucket count] > 0)
        {
            [currentRequestBucket addObject:[playerBucket objectAtIndex:0]];
            [playerBucket removeObjectAtIndex:0];
        }
    }
    
    if ([playerBucket count] > 0)
        self.pendingRequestBucket = playerBucket;
    else
        self.pendingRequestBucket = nil;
    
    NSString *formattedPlayerIDs = [[self quotesAndCommas:currentRequestBucket] retain];
    NSString *yql = [NSString stringWithFormat:YQL_PLAYERS, league_key, formattedPlayerIDs];
    
    [self requestYahooDataWithYQL:yql andRequestType:YahooFantasyRequestTypePlayers];
    
    [formattedPlayerIDs release];
}

- (NSString *) quotesAndCommas: (NSArray *) stringArray
{
    NSString *returnString = [NSString string];
    if ([stringArray count] <= 0)
        return returnString;
    
    returnString = [NSString stringWithFormat:@"'%@'", [stringArray objectAtIndex: 0]];
    for (int i = 1; i < [stringArray count]; i++)
        returnString = [NSString stringWithFormat:@"%@, '%@'", returnString, [stringArray objectAtIndex:i]];
    
    return returnString;
}

- (void) requestYahooDataWithYQL: (NSString *) yql andRequestType: (YahooFantasyRequestType) yahooRequestType
{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    YQLQueryRequest *request = [YQLQueryRequest   
                                requestWithSession:yahooSession];  
    NSString *structuredProfileLocationQuery = yql;  
    NSLog(@"Running YQL: %@", yql);
    requestType = yahooRequestType;
    
    [request query:structuredProfileLocationQuery  
      withDelegate:self];  
    
}

- (void)requestDidFinishLoading:(YOSResponseData *)data {  
    
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    
    NSDictionary *rspData = [data.responseText JSONValue];  
    NSDictionary *queryData = [rspData objectForKey:@"query"];  
    NSDictionary *results = [queryData objectForKey:@"results"];  
    //NSLog([results description]);
    
    switch (requestType) {
        case YahooFantasyRequestTypeLeagues:
        {
            NSArray *leagues = [results objectForKey: @"league"];            
            [[CoreDataManager sharedInstance] addLeagueData: leagues];
            [self.delegate leagueInfoLoaded];
            
            break;
        }
        case YahooFantasyRequestTypeTeams:
        {
            NSArray *leagues = [results objectForKey: @"league"];
            [[CoreDataManager sharedInstance] addTeamDataForLeagues: leagues];
            
            if (self.pendingRequestBucket)
                [self requestTeamsForLeagues:self.pendingRequestBucket];
            else
                [self.delegate teamInfoLoaded];
            break;
        }
        case YahooFantasyRequestTypeSettings:
        {
            NSArray *leagues = [results objectForKey:@"league"];
            [[CoreDataManager sharedInstance] addSettingsDataForLeagues: leagues];

            if (self.pendingRequestBucket)
                [self requestTeamsForLeagues:self.pendingRequestBucket];
            else
                [self.delegate settingsLoaded];
            break;
        }
        case YahooFantasyRequestTypeDraftInfo:
        {
            NSArray *leagues = [results objectForKey:@"league"];
            [[CoreDataManager sharedInstance] addDraftData: leagues];
            if (self.pendingRequestBucket)
                [self requestDraftInfoForLeagues:pendingRequestBucket];
            else
                [self.delegate draftInfoLoaded];
            break;
        }
        case YahooFantasyRequestTypePlayers:
        {
            //NSLog([results description]);
            NSArray *players = [results objectForKey: @"player"];
            [[CoreDataManager sharedInstance] addPlayerData:players forLeagueKey:self.requestingLeagueKey];

            if (self.pendingRequestBucket)
                [self requestPlayerInfoForLeague:self.requestingLeagueKey andPlayerKeys:self.pendingRequestBucket];
            else
            {
                [self.delegate playerInfoLoadedForLeagueKey:self.requestingLeagueKey];
            }
            break;
        }
    }
}  

@end
