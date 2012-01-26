//
//  MGOLeagueStat.h
//  HowdIDraft
//
//  Created by Mike Oliver on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class League;

@interface MGOLeagueStat : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * league_id;
@property (nonatomic, retain) NSString * stat_id;
@property (nonatomic, retain) NSString * enabled;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * display_name;
@property (nonatomic, retain) NSNumber * sort_order;
@property (nonatomic, retain) NSString * position_type;
@property (nonatomic, retain) NSDecimalNumber * value;
@property (nonatomic, retain) League * league;

@end
