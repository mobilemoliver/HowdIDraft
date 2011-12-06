//
//  League.h
//  HowdIDraft
//
//  Created by Mike Oliver on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface League : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * league_id;
@property (nonatomic, retain) NSString * league_key;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSSet* teams;
@property (nonatomic, retain) NSSet* draftResults;

@end
