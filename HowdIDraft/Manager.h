//
//  Manager.h
//  HowdIDraft
//
//  Created by Mike Oliver on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Team;

@interface Manager : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * team_id;
@property (nonatomic, retain) NSString * manager_id;
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * is_current_login;
@property (nonatomic, retain) Team * team;

@end
