//
//  Team.m
//  HowdIDraft
//
//  Created by Mike Oliver on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Team.h"
#import "DraftEntry.h"
#import "League.h"
#import "Manager.h"


@implementation Team
@dynamic name;
@dynamic team_key;
@dynamic team_id;
@dynamic league_id;
@dynamic rank;
@dynamic manager_id;
@dynamic season;
@dynamic league;
@dynamic managers;
@dynamic draftResults;


- (void)addManagersObject:(Manager *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"managers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"managers"] addObject:value];
    [self didChangeValueForKey:@"managers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)removeManagersObject:(Manager *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"managers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"managers"] removeObject:value];
    [self didChangeValueForKey:@"managers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addManagers:(NSSet *)value {    
    [self willChangeValueForKey:@"managers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"managers"] unionSet:value];
    [self didChangeValueForKey:@"managers" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeManagers:(NSSet *)value {
    [self willChangeValueForKey:@"managers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"managers"] minusSet:value];
    [self didChangeValueForKey:@"managers" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


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


@end
