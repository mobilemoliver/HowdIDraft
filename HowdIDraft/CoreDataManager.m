//
//  CoreDataManager.m
//  HowdIDraft
//
//  Created by Mike Oliver on 11/21/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CoreDataManager.h"
#import "League.h"
#import "Team.h"
#import "Manager.h"
#import "YahooUser.h"
#import "DraftEntry.h"
#import "MGOPlayer.h"
#import "MGOPlayerStat.h"
#import "MGOPlayerPosition.h"
#import "MGORosterPosition.h"

#define PERSISTENT_STORE_FILE_NAME @"datastore.sqlite"

@implementation CoreDataManager

NSString * const MyFirstConstant = @"FirstConstant";
NSString * const leagueIDKey = @"league_id";
NSString * const standingsKey = @"standings";
NSString * const teamsKey = @"teams";
NSString * const teamKey = @"team";
NSString * const nameKey = @"name";
NSString * const teamIDKey = @"team_id";
NSString * const teamKeyKey = @"team_key";
NSString * const teamPointsKey = @"team_points";
NSString * const seasonKey = @"season";
NSString * const managersKey = @"managers";
NSString * const managerKey = @"manager";
NSString * const nicknameKey = @"nickname";
NSString * const managerIDKey = @"manager_id";
NSString * const guidKey = @"guid";
NSString * const isCurrentLogin = @"is_current_login";
NSString * const draftResultsKey = @"draft_results";
NSString * const draftResultKey = @"draft_result";
NSString * const costKey = @"cost";
NSString * const pickKey = @"pick";
NSString * const playerKeyKey = @"player_key";
NSString * const roundKey = @"round";
NSString * const nilString = @"<null>";
NSString * const playerTeamKey = @"editorial_team_full_name";
NSString * const eligiblePositionsKey = @"eligible_positions";
NSString * const positionKey = @"position";
NSString * const firstKey = @"first";
NSString * const lastKey = @"last";
NSString * const playerIDKey = @"player_id";
NSString * const playerStatsKey = @"player_stats";
NSString * const statsKey = @"stats";
NSString * const statKey = @"stat";
NSString * const statIDKey = @"stat_id";
NSString * const valueKey = @"value";
NSString * const draftStatusKey = @"draft_status";
NSString * const isFinishedKey = @"is_finished";
NSString * const settingsKey = @"settings";
NSString * const rosterPositionsKey = @"roster_positions";
NSString * const rosterPositionKey = @"roster_position";
NSString * const positionTypeKey = @"position_type";
NSString * const countKey = @"count";


static CoreDataManager *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (CoreDataManager *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
    }
    
    return sharedInstance;
}

#pragma mark FFL specific stuff

- (NSNumber *) getNumberFromDict: (NSDictionary *)dict withKey: (NSString *)key
{
    NSString *valueInDict = [dict objectForKey:key];
    
    if (!valueInDict)
        return nil;
    
    // This seems to be the common one.  Rather than have nothing in the dict or empty string or something else,
    // the object is simply NSNull.
    if ([valueInDict isKindOfClass:[NSNull class]])
        return nil;
    
    if ([valueInDict isEqualToString:nilString])
        return nil;
    
    return [NSNumber numberWithDouble:[valueInDict doubleValue]];
}

- (void) addSettingsDataForLeagues: (NSArray *) leagues
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    League *leagueObject;
    MGORosterPosition *rosterPosition;
    
    for (NSDictionary *leagueDict in leagues)
    {
        NSString *leagueID = [leagueDict objectForKey: leagueIDKey];
        leagueObject = [[self getLeagueForID:leagueID] retain];
        
        leagueObject.draft_status = [leagueDict objectForKey:draftStatusKey];
        leagueObject.is_finished = [leagueDict objectForKey:isFinishedKey];
        
        NSDictionary *settingsDict = [leagueDict objectForKey:settingsKey];
        
        for (NSDictionary *rosterDict in [[settingsDict objectForKey: rosterPositionsKey] objectForKey: rosterPositionKey])
        {
            rosterPosition = [NSEntityDescription insertNewObjectForEntityForName:@"MGORosterPosition" inManagedObjectContext:context];
            rosterPosition.league = leagueObject;
            rosterPosition.league_id = leagueID;
            rosterPosition.position = [rosterDict objectForKey:positionKey];
            rosterPosition.position_type = [rosterDict objectForKey:positionTypeKey];
            rosterPosition.count = [NSNumber numberWithInt:[[rosterDict objectForKey:countKey] intValue]];
        }
        
        
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving league settings: %@", [error localizedDescription]);
    }
}

- (void) addDraftData: (NSArray *) leagues
{
    NSManagedObjectContext *context = [self managedObjectContext];

    Team *teamObject;
    League *leagueObject;
    DraftEntry *draftEntry;
    
    NSMutableDictionary *teamsDict = [[NSMutableDictionary alloc] init];
    
    for (NSDictionary *leagueDict in leagues)
    {
        NSString *leagueID = [leagueDict objectForKey: leagueIDKey];
        leagueObject = [[self getLeagueForID:leagueID] retain];
        
        for (NSDictionary *draftResultDict in [[leagueDict objectForKey: draftResultsKey] objectForKey: draftResultKey])
        {
            draftEntry = [NSEntityDescription insertNewObjectForEntityForName: @"DraftEntry" inManagedObjectContext: context];
            draftEntry.cost = [self getNumberFromDict:draftResultDict withKey:costKey];
            draftEntry.pick = [self getNumberFromDict:draftResultDict withKey:pickKey];
            draftEntry.round = [self getNumberFromDict:draftResultDict withKey:roundKey];
            draftEntry.player_key = [draftResultDict objectForKey:playerKeyKey];
            draftEntry.team_key = [draftResultDict objectForKey:teamKeyKey];
            draftEntry.league_key = leagueObject.league_key;
            draftEntry.league = leagueObject;
            
            // We're going to be retrieving a LOT of teams with these draft entries.  Rather than hitting
            // core data and the database constantly, we'll hold on to the teams here as we need them.  
            teamObject = [teamsDict objectForKey:draftEntry.team_key];
            if (!teamObject)
            {
                teamObject = [self getTeamForKey:draftEntry.team_key];
                [teamsDict setValue:teamObject forKey:teamObject.team_key];
            }
                
            draftEntry.team = teamObject;
        }
        
        [leagueObject release]; leagueObject = nil;
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving draft info: %@", [error localizedDescription]);
    }
    
    [teamsDict release]; teamsDict = nil;
}

- (void) addTeamDataForLeagues: (NSArray *) leagues
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    Team *newTeamObject;
    League *teamLeague;
    
    for (NSDictionary *leagueDict in leagues)
    {
        NSString *leagueID = [leagueDict objectForKey: leagueIDKey];
        teamLeague = [[self getLeagueForID:leagueID] retain];
        
        // For some reason teams isn't an array; it's a dictionary.  Ok, whatever.
        NSDictionary *standings = [leagueDict objectForKey: standingsKey];
        NSDictionary *teams = [standings objectForKey: teamsKey];        
        NSDictionary *team = [teams objectForKey:teamKey];
        
        newTeamObject = [NSEntityDescription insertNewObjectForEntityForName: @"Team" inManagedObjectContext: context];
        newTeamObject.league_id = leagueID;
        newTeamObject.name = [team objectForKey:nameKey];
        newTeamObject.team_id = [team objectForKey:teamIDKey];
        newTeamObject.team_key = [team objectForKey:teamKeyKey];
        newTeamObject.league = teamLeague;
        
        // The season is actually buried within team_points for some reason
        NSDictionary *teamPointsDict = [team objectForKey:teamPointsKey];
        newTeamObject.season = [NSNumber numberWithInt:[[teamPointsDict objectForKey: seasonKey] intValue]];
        
        // Process managers.  Most likely, there's only going to be one manager.
        NSDictionary *managers = [team objectForKey:managersKey];
        id manager = [managers objectForKey:managerKey];
        if ([manager isKindOfClass:[NSDictionary class]])
            [self processManager: manager team: newTeamObject inContext: context];
        else 
        {
            for (NSDictionary *managerDict in manager)
                [self processManager: managerDict team: newTeamObject inContext: context];
        }
        
        [teamLeague release]; teamLeague = nil;
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving league info: %@", [error localizedDescription]);
    }

}

- (void) processManager: (NSDictionary *) manager team: (Team *) newTeamObject inContext: (NSManagedObjectContext *) context
{
    Manager *newManagerObject;
    newManagerObject = [NSEntityDescription insertNewObjectForEntityForName: @"Manager" inManagedObjectContext: context];
    newManagerObject.manager_id = [manager objectForKey:managerIDKey];
    newManagerObject.nickname = [manager objectForKey:nicknameKey];
    newManagerObject.guid = [manager objectForKey:guidKey];
    newManagerObject.is_current_login = [manager objectForKey:isCurrentLogin];
    newManagerObject.team_id = newTeamObject.team_id;   
    
    [newTeamObject addManagersObject: newManagerObject];

}

- (void) addPlayerData: (NSArray *) players forLeagueKey: (NSString *) leagueKey
{
    NSAssert(leagueKey, @"Attempting to add player data for nil leagueKey");
    
    NSManagedObjectContext *context = [self managedObjectContext];

    MGOPlayer *player = nil;
    MGOPlayerStat *stat = nil;  
    MGOPlayerPosition *position = nil;
    for (NSDictionary *playerDict in players)
    {
        // First, get basic player information
        player = [NSEntityDescription insertNewObjectForEntityForName: @"MGOPlayer" inManagedObjectContext: context];
        player.editorial_team_full_name = [playerDict objectForKey: playerTeamKey];
        player.first_name = [[playerDict objectForKey:nameKey] objectForKey:firstKey];
        player.league_key = leagueKey;
        
        // If last name is null, IE for a Defense, exception gets thrown.  It's ok to leave last name null, but
        // you can't set it to an object of type NSNull.
        NSString *lastName = [[playerDict objectForKey:nameKey] objectForKey:lastKey];
        if ([lastName isKindOfClass:[NSString class]])
            player.last_name = lastName;
        
        player.player_id = [playerDict objectForKey:playerIDKey];
        player.player_key = [playerDict objectForKey:playerKeyKey];
        
        // Second, work with eligible positions
        NSDictionary *eligiblePositions = [playerDict objectForKey:eligiblePositionsKey];
        NSArray *positions = [eligiblePositions objectForKey:positionKey];
        NSDictionary *playerStatsDict = [playerDict objectForKey:playerStatsKey];
        NSNumber *season = [NSNumber numberWithInt: [[playerStatsDict objectForKey:seasonKey] intValue]];
        if ([positions isKindOfClass: [NSArray class]])
        {
            for (NSString *positionName in positions)
            {
                position = [NSEntityDescription insertNewObjectForEntityForName: @"MGOPlayerPosition" inManagedObjectContext: context];
                position.player_key = player.player_key;
                position.player = player;
                position.position = positionName;
                position.league_key = leagueKey;
                position.season = season;
            }
        }
        else if ([positions isKindOfClass: [NSString class]])
        {
            position = [NSEntityDescription insertNewObjectForEntityForName: @"MGOPlayerPosition" inManagedObjectContext: context];
            position.player_key = player.player_key;
            position.player = player;
            position.position = (NSString *) positions;
            position.league_key = leagueKey;
            position.season = season;            
        }
        
        // Third, get player stats
        NSDictionary *statsDict = [playerStatsDict objectForKey:statsKey];
        NSArray *stats = [statsDict objectForKey:statKey];
        for (NSDictionary *statDict in stats)
        {
            stat = [NSEntityDescription insertNewObjectForEntityForName: @"MGOPlayerStat" inManagedObjectContext: context];
            stat.season = season;
            stat.player = player;
            stat.player_key = player.player_key;
            stat.stat_id = [statDict objectForKey:statIDKey];
            stat.value = [NSNumber numberWithDouble: [[statDict objectForKey:valueKey] doubleValue]];
            stat.league_key = leagueKey;
        }
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving league info: %@", [error localizedDescription]);
    }
}

- (void) addLeagueData: (NSArray *) leagues
{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSInteger i = 0;
    for (NSDictionary *leagueDict in leagues)
    {
        League *leagueObject = [NSEntityDescription insertNewObjectForEntityForName: @"League" inManagedObjectContext: context];
        
        // I'd love to have a property on the league object for the year or season the league was in effect.  
        // Unfortunately, Yahoo doesn't provide that.  So to ensure that I can order things chronologically, 
        // I will maintain the order leagues are returned in.  Yahoo does at least return the leagues in order
        leagueObject.order = [NSNumber numberWithInt:i];
        for (NSString *key in [leagueDict allKeys])
        {
            // Add to the object model only if the object model understands the attribute.  
            if ([[[leagueObject entity] attributesByName] objectForKey: key])
                [leagueObject setValue: [leagueDict objectForKey: key] forKey: key];
        }
        
        i++;
    }
    
    NSError *error;
    if (![context save:&error]) {
        NSLog(@"Error saving league info: %@", [error localizedDescription]);
    }
}

- (void) clearPersistentStore
{
    NSPersistentStore *store = [[[self persistentStoreCoordinator] persistentStores] objectAtIndex:0];
    NSError *error;
    NSURL *storeURL = store.URL;
    NSPersistentStoreCoordinator *storeCoordinator = [self persistentStoreCoordinator];
    [storeCoordinator removePersistentStore:store error:&error];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
    
    [persistentStoreCoordinator release];
    persistentStoreCoordinator = nil;
}

- (NSArray *) getTeams
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Team" inManagedObjectContext:managedObjectContext];   
    NSFetchRequest *request = [[NSFetchRequest alloc] init];   
    [request setEntity:entity];      
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"season" ascending:NO];       
    NSMutableArray *sortDescriptors = [NSMutableArray arrayWithObject:sortDescriptor];   
    [sortDescriptor release];  

    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"league" ascending:YES]; 
    [sortDescriptors addObject:sortDescriptor];
    
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [sortDescriptors addObject:sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];  
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(ANY managers.is_current_login IN %@)", [NSArray arrayWithObject:@"1"]];
    [request setPredicate:predicate];
        
    NSArray *returnArray = [managedObjectContext executeFetchRequest:request error:nil];
    return returnArray;
    
}

- (NSMutableArray *) getLeagues
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"League" inManagedObjectContext:managedObjectContext];   
    NSFetchRequest *request = [[NSFetchRequest alloc] init];   
    [request setEntity:entity];      
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"order" ascending:NO];       
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];   
    [request setSortDescriptors:sortDescriptors];   
    [sortDescriptor release];  
    
    NSArray *returnArray = [managedObjectContext executeFetchRequest:request error:nil];
    return [NSMutableArray arrayWithArray: returnArray];
}

- (Team *) getTeamForKey: (NSString *) team_key
{
    Team *returnValue = (Team *)[self getEntity:@"Team" withKeyName:@"team_key" andValue:team_key];
    return returnValue;        
}

- (League *) getLeagueForID: (NSString *) league_ID
{
    League *returnValue = (League *)[self getEntity:@"League" withKeyName:@"league_id" andValue:league_ID];
    return returnValue;      
}

- (id) getEntity: (NSString *) entityName withKeyName: (NSString *) keyName andValue: (NSString *) keyValue
{
    NSEntityDescription *entity = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];   
    NSFetchRequest *request = [[NSFetchRequest alloc] init];   
    [request setEntity:entity];      
    
    NSString *predicateString = [NSString stringWithFormat:@"(%@ == %@)", keyName, @"%@"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:predicateString, keyValue];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *returnArray = [managedObjectContext executeFetchRequest:request error:&error];
    
    if (!returnArray)
    {
        NSLog(@"Error getting %@ with %@ %@: %@", entityName, keyName, keyValue, [error localizedDescription]);
        return nil;
    }
    
    if ([returnArray count] != 1)
    {
        NSLog(@"Expecting to get exactly one %@ back with %@ %@; got back %i", entityName, keyName, keyValue, [returnArray count]);
        return nil;
    }
    
    return [returnArray objectAtIndex:0];
    
}
    
#pragma mark -
    
- (NSManagedObjectContext *) managedObjectContext {
    if (managedObjectContext != nil) {
        return managedObjectContext;
    }
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        managedObjectContext = [[NSManagedObjectContext alloc] init];
        [managedObjectContext setPersistentStoreCoordinator: coordinator];
    }
    
    return managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil) {
        return managedObjectModel;
    }
    managedObjectModel = [[NSManagedObjectModel mergedModelFromBundles:nil] retain];
    
    return managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator;
    }
    NSURL *storeUrl = [NSURL fileURLWithPath: [[self applicationDocumentsDirectory]
                                               stringByAppendingPathComponent: PERSISTENT_STORE_FILE_NAME]];
    NSError *error = nil;
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
                                  initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
                                                 configuration:nil URL:storeUrl options:options error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    
    return persistentStoreCoordinator;
}

- (NSString *)applicationDocumentsDirectory {
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (void)dealloc
{
    [super dealloc];
    [managedObjectContext release];
    [managedObjectModel release];
    [persistentStoreCoordinator release];
}

@end
