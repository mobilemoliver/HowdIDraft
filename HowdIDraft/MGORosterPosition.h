//
//  MGORosterPosition.h
//  HowdIDraft
//
//  Created by Mike Oliver on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class League;

@interface MGORosterPosition : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * position;
@property (nonatomic, retain) NSString * position_type;
@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * league_id;
@property (nonatomic, retain) League * league;

@end
