//
//  League.m
//  HowdIDraft
//
//  Created by Mike Oliver on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "League.h"
#import "Team.h"


@implementation League
@dynamic name;
@dynamic league_id;
@dynamic league_key;
@dynamic order;
@dynamic teams;
@dynamic draftResults;

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


- (void)addDraftResultsObject:(NSManagedObject *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"draftResults"] addObject:value];
    [self didChangeValueForKey:@"draftResults" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeDraftResultsObject:(NSManagedObject *)value {
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


@end
