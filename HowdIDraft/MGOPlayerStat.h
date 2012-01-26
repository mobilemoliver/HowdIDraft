//
//  MGOPlayerStat.h
//  HowdIDraft
//
//  Created by Mike Oliver on 1/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MGOPlayer;

@interface MGOPlayerStat : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * player_key;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * season;
@property (nonatomic, retain) NSString * stat_id;
@property (nonatomic, retain) NSString * league_key;
@property (nonatomic, retain) MGOPlayer * player;

@end
