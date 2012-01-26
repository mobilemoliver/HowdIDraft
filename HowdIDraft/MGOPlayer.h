//
//  MGOPlayer.h
//  HowdIDraft
//
//  Created by Mike Oliver on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class League, MGOPlayerPosition, MGOPlayerStat;

@interface MGOPlayer : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * league_key;
@property (nonatomic, retain) NSString * editorial_team_full_name;
@property (nonatomic, retain) NSString * last_name;
@property (nonatomic, retain) NSString * player_id;
@property (nonatomic, retain) NSString * player_key;
@property (nonatomic, retain) NSString * first_name;
@property (nonatomic, retain) NSSet* playerPositions;
@property (nonatomic, retain) League * playerLeague;
@property (nonatomic, retain) NSSet* playerStats;

@end
