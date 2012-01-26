//
//  MGOPlayerPosition.h
//  HowdIDraft
//
//  Created by Mike Oliver on 12/25/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class MGOPlayer;

@interface MGOPlayerPosition : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * season;
@property (nonatomic, retain) NSString * player_key;
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * league_key;
@property (nonatomic, retain) MGOPlayer * player;

@end
