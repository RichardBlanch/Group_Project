//
//  classmatesTableViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 10/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "classmatesTableViewController.h"

@interface classmatesTableViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation classmatesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupMembers = [[NSMutableArray alloc]init];
    self.tableView.allowsMultipleSelection = YES;
    self.tableView.userInteractionEnabled = YES;
    
    
   
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.classmates.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"classMateCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSeparatorStyleNone;
    PFObject * classMate = self.classmates[indexPath.row];
    cell.textLabel.text = classMate[@"username"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (selectedCell.accessoryType == UITableViewCellAccessoryNone)
    {
        PFObject * classMate = self.classmates[indexPath.row];
        selectedCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [self.tableView reloadData];
        [self.groupMembers insertObject:classMate atIndex:0];
    }
}

-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    if (selectedCell.accessoryType == UITableViewCellAccessoryCheckmark)
    {
        PFObject * classMate = self.classmates[indexPath.row];
        selectedCell.accessoryType = UITableViewCellAccessoryNone;
        [self.groupMembers removeObject:classMate];
    }
    
}
- (IBAction)createGroup:(UIButton *)sender {
    NSString * groupText = [[NSString alloc]init];
     PFObject * group = [PFObject objectWithClassName:@"Group"];
    
    UIAlertController * alertController = [[UIAlertController alloc]init];
   
   
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        }];
        UIAlertAction * OK = [UIAlertAction actionWithTitle:@"Add Group" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
           
        }];
        [alertController addAction:OK];
        [self presentViewController:alertController animated:YES completion:nil];
        groupText = alertController.textFields[0].text;
        group[@"groupName"] = groupText;

    
    PFRelation * groupMembers = [group relationForKey:@"GroupMembers"];
    for(PFObject * groupMemberAdded in self.groupMembers) {
        [groupMembers addObject:groupMemberAdded];
        
    }
    [group saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"success");
            PFRelation * setGroupForClass = [self.classs relationForKey:@"GroupsForClass"];
            [setGroupForClass addObject:group];
            [self.classs saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if(succeeded) {
                    NSLog(@"savedGroupForClass");
                }
            }];
            
            
                   }
    }];
    
   
   
    
}





@end
