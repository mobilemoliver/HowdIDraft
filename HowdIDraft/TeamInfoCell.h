//
//  TeamInfoCell.h
//  HowdIDraft
//
//  Created by Mike Oliver on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface TeamInfoCell : UITableViewCell {
    IBOutlet UILabel *leagueNameLabel;
    IBOutlet UILabel *teamNameLabel;
    IBOutlet UILabel *seasonLabel;
}

@property (nonatomic, retain) IBOutlet UILabel *leagueNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *teamNameLabel;
@property (nonatomic, retain) IBOutlet UILabel *seasonLabel;

@end
