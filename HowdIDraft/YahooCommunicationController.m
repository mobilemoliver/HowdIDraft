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


@implementation YahooCommunicationController

@synthesize delegate;

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
    NSString *formattedLeagueIDs = [[self quotesAndCommas:leagueIDs] retain];
    NSString *yql = [NSString stringWithFormat:YQL_DRAFT, formattedLeagueIDs];
    
    [self requestYahooDataWithYQL:yql andRequestType:YahooFantasyRequestTypeDraftInfo];
}

- (void) requestTeamsForLeagues: (NSArray *) leagueIDs
{
    NSString *formattedLeagueIDs = [[self quotesAndCommas:leagueIDs] retain];
    NSString *yql = [NSString stringWithFormat:YQL_TEAMS, formattedLeagueIDs];
    
    [self requestYahooDataWithYQL:yql andRequestType:YahooFantasyRequestTypeTeams];
    
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
        case YahooFantasyRequestTypeDraftInfo:
        {
            NSArray *leagues = [results objectForKey:@"league"];
            [[CoreDataManager sharedInstance] addDraftData: leagues];
            [self.delegate draftInfoLoaded];
            break;
        }
        case YahooFantasyRequestTypeTeams:
        {
            NSArray *leagues = [results objectForKey: @"league"];
            [[CoreDataManager sharedInstance] addTeamDataForLeagues: leagues];
            [self.delegate teamInfoLoaded];
            break;
        }
    }
}  

@end
