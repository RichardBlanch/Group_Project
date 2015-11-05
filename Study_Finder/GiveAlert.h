//
//  GiveAlert.h
//  Study_Finder
//
//  Created by Rich Blanchard on 10/27/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>
#import <UIKit/UIKit.h>
#import "ClassMapper.h"

@interface GiveAlert : NSObject
+(void)giveAlertForSubjectsAndSave:(NSString *)Title message:(NSString *)message  buttonActionTitle:(NSString *)buttonActionTitle additionalObject:(PFObject *)object tableView:(UITableView *)tableView forViewController:(UIViewController *)vc;

@property (nonatomic,strong) NSArray * subjectsArray;

@end
