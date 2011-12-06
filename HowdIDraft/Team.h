//
//  Team.h
//  HowdIDraft
//
//  Created by Mike Oliver on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DraftEntry, League, Manager;

@interface Team : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * team_key;
@property (nonatomic, retain) NSString * team_id;
@property (nonatomic, retain) NSString * league_id;
@property (nonatomic, retain) NSNumber * rank;
@property (nonatomic, retain) NSString * manager_id;
@property (nonatomic, retain) NSNumber * season;
@property (nonatomic, retain) League * league;
@property (nonatomic, retain) NSSet* managers;
@property (nonatomic, retain) NSSet* draftResults;

@end
