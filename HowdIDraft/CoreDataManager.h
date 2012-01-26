//
//  CoreDataManager.h
//  HowdIDraft
//
//  Created by Mike Oliver on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <Foundation/Foundation.h>
#import "Team.h"

@interface CoreDataManager : NSObject {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
    
}

@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (NSString *)applicationDocumentsDirectory;

// Methods for adding data
- (void) addLeagueData: (NSArray *) leagues;
- (void) addDraftData: (NSArray *) leagues;
- (void) addSettingsDataForLeagues: (NSArray *) leagues;
- (void) addTeamDataForLeagues: (NSArray *) leagues;
- (void) processManager: (NSDictionary *) manager team: (Team *) newTeamObject inContext: (NSManagedObjectContext *) context;
- (void) addPlayerData: (NSArray *) players forLeagueKey: (NSString *) leagueKey;

// Methods for retrieving data
- (NSMutableArray *) getLeagues;
- (NSArray *) getTeams;
- (League *) getLeagueForID: (NSString *) league_ID;
- (Team *) getTeamForKey: (NSString *) team_key;

// Utility methods
- (void) clearPersistentStore;
- (NSNumber *) getNumberFromDict: (NSDictionary *)dict withKey: (NSString *)key;
- (id) getEntity: (NSString *) entityName withKeyName: (NSString *) keyName andValue: (NSString *) keyValue;

+ (CoreDataManager *)sharedInstance;

@end
