//
//  CustomMessageTableViewCell.h
//  Study_Finder
//
//  Created by Rich Blanchard on 10/8/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomMessageTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *messageContentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *senderLabel;

@end
