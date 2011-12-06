//
//  RootViewController.m
//  HowdIDraft
//
//  Created by Mike Oliver on 10/22/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "RootViewController.h"
#import "TeamInfoTableViewController.h"
#import "CoreDataManager.h"
#import "League.h"

@implementation RootViewController

@dynamic leagueIDs;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    yahooController = [[YahooCommunicationController alloc] init];
    yahooController.delegate = self;
    authenticationWebView = [[yahooController authenticate] retain];
    authenticationWebView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    [self.view addSubview:authenticationWebView];
}

- (void) authenticationFinished
{
    [authenticationWebView removeFromSuperview];
    [authenticationWebView release];
    
    [[CoreDataManager sharedInstance] clearPersistentStore];
    
    [yahooController requestLeagueInfo];
}

- (void) leagueInfoLoaded
{
    [yahooController requestTeamsForLeagues:[self leagueIDs]];    
}

- (NSArray *) leagueIDs
{
    if (!leagueIDs)
    {
        NSArray *leagueDataSource = [[[CoreDataManager sharedInstance] getLeagues] retain];
        leagueIDs = [[NSMutableArray alloc] initWithCapacity:[leagueDataSource count]];
        
        for (League *league in leagueDataSource)
            [leagueIDs addObject: league.league_key];
        
    }
    
    return leagueIDs;
}

- (void) teamInfoLoaded
{
    [yahooController requestDraftInfoForLeagues:[self leagueIDs]]; 
    
    [self showTeams];
}

- (void) draftInfoLoaded
{
    
}

- (void) showTeams
{
    TeamInfoTableViewController *teamController = [[TeamInfoTableViewController alloc] initWithNibName:@"TeamInfoTableViewController" bundle:nil];
    teamController.tableView.frame = self.view.frame;
    [self.view addSubview:teamController.tableView];    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
    [super viewDidUnload];

    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}

- (void)dealloc
{
    [super dealloc];
    
    [authenticationWebView release];
    [yahooController release];
}

@end
