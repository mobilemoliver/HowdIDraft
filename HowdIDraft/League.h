//
//  League.h
//  HowdIDraft
//
//  Created by Mike Oliver on 1/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class DraftEntry, MGOLeagueStat, MGOPlayer, MGORosterPosition, Team;

@interface League : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * league_key;
@property (nonatomic, retain) NSNumber * order;
@property (nonatomic, retain) NSString * league_id;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * is_finished;
@property (nonatomic, retain) NSString * draft_status;
@property (nonatomic, retain) NSSet* draftResults;
@property (nonatomic, retain) NSSet* teams;
@property (nonatomic, retain) NSSet* players;
@property (nonatomic, retain) NSSet* rosterPositions;
@property (nonatomic, retain) MGOLeagueStat * leagueStats;

@end
