//
//  TeamInfoCell.m
//  HowdIDraft
//
//  Created by Mike Oliver on 11/23/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TeamInfoCell.h"


@implementation TeamInfoCell

@synthesize leagueNameLabel;
@synthesize teamNameLabel;
@synthesize seasonLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
