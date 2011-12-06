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
    YahooFantasyRequestTypeTeams
    
} YahooFantasyRequestType;

@protocol YahooCommDelegate <NSObject>

- (void) authenticationFinished;
- (void) leagueInfoLoaded;
- (void) teamInfoLoaded;
- (void) draftInfoLoaded;

@end

@interface YahooCommunicationController : NSObject <UIWebViewDelegate, YOSRequestDelegate>{
    UIWebView *webView;
    YOSSession *yahooSession;
    YahooFantasyRequestType requestType;
    id<YahooCommDelegate> delegate;
}

@property (nonatomic, assign) id<YahooCommDelegate> delegate;

// Outwardly used methods
- (void)requestLeagueInfo;
- (void)requestDraftInfoForLeagues: (NSArray *) leagueIDs;
- (void) requestTeamsForLeagues: (NSArray *) leagueIDs;
- (UIWebView *) authenticate;

// Utility methods
- (NSString *) getParameter: (NSString *) parameter forRequest: (NSURLRequest *) request;
- (NSString *) quotesAndCommas: (NSArray *) stringArray;
- (void) requestYahooDataWithYQL: (NSString *) yql andRequestType: (YahooFantasyRequestType) yahooRequestType;

@end

