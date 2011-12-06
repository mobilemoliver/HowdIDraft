//
//  YahooUser.h
//  HowdIDraft
//
//  Created by Mike Oliver on 12/4/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface YahooUser : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * guid;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * familyName;
@property (nonatomic, retain) NSString * nickname;

@end
