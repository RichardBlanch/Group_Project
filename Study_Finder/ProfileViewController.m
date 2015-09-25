//
//  ProfileViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "ProfileViewController.h"
#import "ClassMapper.h"

@interface ProfileViewController ()
@property ClassMapper * mapper;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpTableView];
     self.tableView.separatorColor = [UIColor lightGrayColor];
    self.mapper =   [[ClassMapper alloc]init];
}



-(void)setUpTableView {
    OrganicCell * helloWorldCell = [OrganicCell cellWithStyle:UITableViewCellStyleValue1 height:100 actionBlock:^{
        //
    }];
    helloWorldCell.textLabel.text = @"Rich Blanchard";
    helloWorldCell.imageView.image = [UIImage imageNamed: @"ballers"];
    
    OrganicCell * goodByeWorldCell = [OrganicCell cellWithStyle:UITableViewCellStyleValue2 height:55 actionBlock:^{
        //
    }];
    goodByeWorldCell.textLabel.text = @"";
    goodByeWorldCell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    OrganicSection * firstStaticSection = [OrganicSection sectionWithHeaderTitle:@"User" cells:@[helloWorldCell,goodByeWorldCell]];
    
    NSArray *demoDataSource = @[@"Computer Systems", @"Software-Development", @"Astronomy", @"Calculus"];
    OrganicSection *sectionWithReuse = [OrganicSection sectionSupportingReuseWithTitle:@"Classes" cellCount:demoDataSource.count cellHeight:55 cellForRowBlock:^UITableViewCell *(UITableView *tableView, NSInteger row) {
        static NSString *cellReuseID = @"celReuseID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
        [self.mapper getClasses];
        NSLog(@"array is %@",self.mapper.userClasses);
       
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseID];
            
        }
        
        cell.textLabel.text = demoDataSource[row];
        
        return cell;
        
    } actionBlock:^(NSInteger row) {
       
    }];
    
    self.sections = @[firstStaticSection, sectionWithReuse];}



@end
