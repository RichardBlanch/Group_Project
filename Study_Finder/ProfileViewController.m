//
//  ProfileViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "ProfileViewController.h"
#import "ClassMapper.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SubjectsTableViewController.h"

@interface ProfileViewController ()
@property ClassMapper * mapper;
@property (nonatomic,strong) NSArray * classes;
@property (nonatomic,strong) PFObject * userClickedClass;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.classes = [[NSMutableArray alloc]init];
     self.tableView.separatorColor = [UIColor lightGrayColor];
    self.mapper = [[ClassMapper alloc]init];
    
    [self.mapper getClasses:^ void(NSMutableArray *who) {
        
        self.classes = who;
         [self setUpTableView];
     }];
    
   
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject * classHit = self.classes[indexPath.row];
    self.userClickedClass = classHit;
    [self performSegueWithIdentifier:@"goToSubjects" sender:self];
}



-(void)setUpTableView {
    dispatch_async(dispatch_get_main_queue(), ^{
        
    OrganicCell * helloWorldCell = [OrganicCell cellWithStyle:UITableViewCellStyleValue1 height:100 actionBlock:^{
        //
    }];
        helloWorldCell.textLabel.text = [ClassMapper getUserName:[PFUser currentUser]];
    helloWorldCell.imageView.image = [UIImage imageNamed: @"ballers"];
    
    OrganicCell * goodByeWorldCell = [OrganicCell cellWithStyle:UITableViewCellStyleValue2 height:55 actionBlock:^{
        //
    }];
    goodByeWorldCell.textLabel.text = @"";
    goodByeWorldCell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    OrganicSection * firstStaticSection = [OrganicSection sectionWithHeaderTitle:@"User" cells:@[helloWorldCell,goodByeWorldCell]];
    
    NSArray *demoDataSource = @[@"Computer Systems", @"Software-Development", @"Astronomy", @"Calculus"];
    OrganicSection *sectionWithReuse = [OrganicSection sectionSupportingReuseWithTitle:@"Classes" cellCount:self.classes.count cellHeight:55 cellForRowBlock:^UITableViewCell *(UITableView *tableView, NSInteger row) {
        static NSString *cellReuseID = @"celReuseID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
        NSLog(@"array is %@",self.mapper.userClasses);
       
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseID];
            
        }
        
        PFObject * class = self.classes[row];
        NSString * className = class[@"ClassName"];
        cell.textLabel.text = className;
        return cell;
        
    } actionBlock:^(NSInteger row) {
       
    }];
    
    self.sections = @[firstStaticSection, sectionWithReuse];
                   });
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToSubjects"]) {
        SubjectsTableViewController * vc = (SubjectsTableViewController *)segue.destinationViewController;
        vc.classClicked = self.userClickedClass;
    }
}




@end
