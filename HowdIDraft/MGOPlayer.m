//
//  MGOPlayer.m
//  HowdIDraft
//
//  Created by Mike Oliver on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MGOPlayer.h"
#import "League.h"
#import "MGOPlayerPosition.h"
#import "MGOPlayerStat.h"


@implementation MGOPlayer
@dynamic league_key;
@dynamic editorial_team_full_name;
@dynamic last_name;
@dynamic player_id;
@dynamic player_key;
@dynamic first_name;
@dynamic playerPositions;
@dynamic playerLeague;
@dynamic playerStats;

- (void)addPlayerPositionsObject:(MGOPlayerPosition *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"playerPositions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"playerPositions"] addObject:value];
    [self didChangeValueForKey:@"playerPositions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePlayerPositionsObject:(MGOPlayerPosition *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"playerPositions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"playerPositions"] removeObject:value];
    [self didChangeValueForKey:@"playerPositions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPlayerPositions:(NSSet *)value {    
    [self willChangeValueForKey:@"playerPositions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"playerPositions"] unionSet:value];
    [self didChangeValueForKey:@"playerPositions" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePlayerPositions:(NSSet *)value {
    [self willChangeValueForKey:@"playerPositions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"playerPositions"] minusSet:value];
    [self didChangeValueForKey:@"playerPositions" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}



- (void)addPlayerStatsObject:(MGOPlayerStat *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"playerStats" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"playerStats"] addObject:value];
    [self didChangeValueForKey:@"playerStats" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removePlayerStatsObject:(MGOPlayerStat *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"playerStats" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"playerStats"] removeObject:value];
    [self didChangeValueForKey:@"playerStats" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addPlayerStats:(NSSet *)value {    
    [self willChangeValueForKey:@"playerStats" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"playerStats"] unionSet:value];
    [self didChangeValueForKey:@"playerStats" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removePlayerStats:(NSSet *)value {
    [self willChangeValueForKey:@"playerStats" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"playerStats"] minusSet:value];
    [self didChangeValueForKey:@"playerStats" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
