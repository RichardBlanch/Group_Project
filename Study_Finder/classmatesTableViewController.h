//
//  classmatesTableViewController.h
//  Study_Finder
//
//  Created by Rich Blanchard on 10/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@protocol dismissToGroupsAndClasses
-(void)extendedSegue;

@end



@interface classmatesTableViewController : UIViewController <UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong) NSArray * classmates;
@property (nonatomic,strong) NSMutableArray * groupMembers;
@property (nonatomic,strong) PFObject * classs;
@property (nonatomic,weak) id delegate;

@end
