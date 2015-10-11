//
//  CustomMessageTableViewCell.m
//  Study_Finder
//
//  Created by Rich Blanchard on 10/8/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "CustomMessageTableViewCell.h"

@implementation CustomMessageTableViewCell

- (void)awakeFromNib {
    // Initialization code
     self.profileImageView.layer.cornerRadius = (self.profileImageView.frame.size.width / 2);
    
}
-(void)layoutSubviews {
    self.profileImageView.layer.cornerRadius = (self.profileImageView.frame.size.width / 2);
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
