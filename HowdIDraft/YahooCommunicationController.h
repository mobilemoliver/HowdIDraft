//
//  YahooCommunicationController.h
//  HowdIDraft
//
//  Created by Mike Oliver on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YOSSocial.h"
#import "NSString+SBJSON.h"

typedef enum {
    YahooFantasyRequestTypeLeagues,
    YahooFantasyRequestTypeDraftInfo,
    YahooFantasyRequestTypeTeams,
    YahooFantasyRequestTypePlayers,
    YahooFantasyRequestTypeSettings
    
} YahooFantasyRequestType;

@protocol YahooCommDelegate <NSObject>

- (void) authenticationFinished;
- (void) leagueInfoLoaded;
- (void) teamInfoLoaded;
- (void) draftInfoLoaded;
- (void) settingsLoaded;
- (void) playerInfoLoadedForLeagueKey: (NSString *) leagueKey;

@end

@interface YahooCommunicationController : NSObject <UIWebViewDelegate, YOSRequestDelegate>{
    UIWebView *webView;
    YOSSession *yahooSession;
    YahooFantasyRequestType requestType;
    id<YahooCommDelegate> delegate;
    NSMutableArray *pendingRequestBucket;
    NSString *requestingLeagueKey;
}

@property (nonatomic, assign) id<YahooCommDelegate> delegate;

/* The Yahoo API can only handle so much data returned at once.  Therefore, we throttle most of the incoming
 requests and only rquest so many things at once.  This array keeps track of any remaining things that need 
 to be requested. */
@property (nonatomic, retain) NSMutableArray *pendingRequestBucket;

/* In the case that we are using the pendingRequestBucket, this is the league to be used for the requests.  */
@property (nonatomic, retain) NSString *requestingLeagueKey;

// Outwardly used methods
- (void)requestLeagueInfo;
- (void)requestDraftInfoForLeagues: (NSArray *) leagueIDs;
- (void) requestTeamsForLeagues: (NSMutableArray *) leagueIDs;
- (void) requestPlayerInfoForLeague: (NSString *) league_key andPlayerKeys: (NSMutableArray *) player_keys;
- (void) requestSettingsForLeagues: (NSMutableArray *) leagueIDs;
- (UIWebView *) authenticate;

// Utility methods
- (NSString *) getParameter: (NSString *) parameter forRequest: (NSURLRequest *) request;
- (NSString *) quotesAndCommas: (NSArray *) stringArray;
- (void) requestYahooDataWithYQL: (NSString *) yql andRequestType: (YahooFantasyRequestType) yahooRequestType;

@end

