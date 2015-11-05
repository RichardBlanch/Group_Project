//
//  SubjectsTableViewController.h
//  Study_Finder
//
//  Created by Rich Blanchard on 9/25/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "GiveAlert.h"

@interface SubjectsTableViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray * subjectsArray;
@property (nonatomic,strong) PFObject * classClicked;
@property (nonatomic,strong) PFObject * subjectClicked;
@property (nonatomic,strong) NSSet * subjectSet;
@property (nonatomic,strong) NSArray * classmates;
@property (weak, nonatomic) IBOutlet UISegmentedControl *subjectsOrGroupSegmentControl;
@property (strong,nonatomic) NSMutableDictionary * casheGroupsDict;
@property (strong,nonatomic) NSArray * subjects;
@property (strong,nonatomic) NSArray * groups;
@property  NSInteger  indexPathForUse;
@end
