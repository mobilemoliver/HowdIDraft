//
//  DraftEntry.h
//  HowdIDraft
//
//  Created by Mike Oliver on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class League, Team;

@interface DraftEntry : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * league_key;
@property (nonatomic, retain) NSString * team_key;
@property (nonatomic, retain) NSString * player_key;
@property (nonatomic, retain) NSNumber * pick;
@property (nonatomic, retain) NSNumber * round;
@property (nonatomic, retain) NSNumber * cost;
@property (nonatomic, retain) League * league;
@property (nonatomic, retain) Team * team;

@end
