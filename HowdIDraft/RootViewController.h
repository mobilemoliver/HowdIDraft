//
//  RootViewController.h
//  HowdIDraft
//
//  Created by Mike Oliver on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YahooCommunicationController.h"
#import "League.h"

@interface RootViewController : UIViewController <YahooCommDelegate> {
    YahooCommunicationController *yahooController;
    UIWebView *authenticationWebView;
    NSMutableArray *leagueIDs;
}

@property (nonatomic, readonly) NSMutableArray *leagueIDs;

- (void) showTeams;
- (void) requestPlayerInfoForLeague: (League *) league;
- (void) beginRequestingPlayerInfo;


@end
