//
//  SubjectsTableViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/25/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "SubjectsTableViewController.h"
#import "ClassMapper.h"
#import "MessageViewController.h"

@interface SubjectsTableViewController ()

@end

@implementation SubjectsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = NO;
    NSLog(@"class is %@",self.classClicked);
   //r [ClassMapper dummySaveSubject:self.classClicked];
    [ClassMapper getSubjects:self.classClicked block:^(NSArray *parseReturnedSubjects) {
        if (parseReturnedSubjects.count > 0) {
            self.subjectsArray = parseReturnedSubjects;
            [self.tableView reloadData];
        }
    }];
       
   

   
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.subjectsArray.count > 0) {
        return self.subjectsArray.count;
    }
    else {
        return 0;
    }
        }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    if (self.subjectsArray.count > 0) {
        PFObject * subject = self.subjectsArray[indexPath.row];
        NSString * titleForSection = subject[@"SubjectTitle"];
        cell.textLabel.text = titleForSection;
    }
    else {
    cell.textLabel.text = @"Hello World!";
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.subjectClicked = self.subjectsArray[indexPath.row];
    [self performSegueWithIdentifier:@"goToMessages" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToMessages"])
    {
        MessageViewController * mVC = (MessageViewController *)segue.destinationViewController;
        mVC.clickedSubject = self.subjectClicked;
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
