//
//  League.m
//  HowdIDraft
//
//  Created by Mike Oliver on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "League.h"
#import "DraftEntry.h"
#import "MGOLeagueStat.h"
#import "MGOPlayer.h"
#import "MGORosterPosition.h"
#import "Team.h"


@implementation League
@dynamic league_key;
@dynamic order;
@dynamic league_id;
@dynamic name;
@dynamic is_finished;
@dynamic draft_status;
@dynamic draftResults;
@dynamic teams;
@dynamic players;
@dynamic rosterPositions;
@dynamic leagueStats;

- (void)addDraftResultsObject:(DraftEntry *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"draftResults"] addObject:value];
    [self didChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeDraftResultsObject:(DraftEntry *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"draftResults"] removeObject:value];
    [self didChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addDraftResults:(NSSet *)value {    
    [self willChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"draftResults"] unionSet:value];
    [self didChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeDraftResults:(NSSet *)value {
    [self willChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"draftResults"] minusSet:value];
    [self didChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addTeamsObject:(Team *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"teams" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"teams"] addObject:value];
    [self didChangeValueForKey:@"teams" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeTeamsObject:(Team *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"teams" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"teams"] removeObject:value];
    [self didChangeValueForKey:@"teams" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addTeams:(NSSet *)value {    
    [self willChangeValueForKey:@"teams" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"teams"] unionSet:value];
    [self didChangeValueForKey:@"teams" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeTeams:(NSSet *)value {
    [self willChangeValueForKey:@"teams" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"teams"] minusSet:value];
    [self didChangeValueForKey:@"teams" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addPlayersObject:(MGOPlayer *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"players" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"players"] addObject:value];
    [self didChangeValueForKey:@"players" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePlayersObject:(MGOPlayer *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"players" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"players"] removeObject:value];
    [self didChangeValueForKey:@"players" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPlayers:(NSSet *)value {    
    [self willChangeValueForKey:@"players" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"players"] unionSet:value];
    [self didChangeValueForKey:@"players" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePlayers:(NSSet *)value {
    [self willChangeValueForKey:@"players" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"players"] minusSet:value];
    [self didChangeValueForKey:@"players" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


- (void)addRosterPositionsObject:(MGORosterPosition *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"rosterPositions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"rosterPositions"] addObject:value];
    [self didChangeValueForKey:@"rosterPositions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeRosterPositionsObject:(MGORosterPosition *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"rosterPositions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"rosterPositions"] removeObject:value];
    [self didChangeValueForKey:@"rosterPositions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addRosterPositions:(NSSet *)value {    
    [self willChangeValueForKey:@"rosterPositions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"rosterPositions"] unionSet:value];
    [self didChangeValueForKey:@"rosterPositions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeRosterPositions:(NSSet *)value {
    [self willChangeValueForKey:@"rosterPositions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"rosterPositions"] minusSet:value];
    [self didChangeValueForKey:@"rosterPositions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



@end
