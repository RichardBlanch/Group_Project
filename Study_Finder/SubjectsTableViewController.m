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
@property (nonatomic,strong)  NSString * addSubjectTextField;

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
            self.subjectSet = self.subjectsArray;
            [self.tableView reloadData];
        }
    }];
    [self addSubject];
       
    UIBarButtonItem * ADD = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubject)];

    self.navigationItem.rightBarButtonItem = ADD;
     self.navigationController.navigationBar.hidden = NO;
    
   
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
        NSArray * arrayFromSet = [self.subjectSet allObjects];
        PFObject * subject = arrayFromSet[indexPath.row];
        NSString * titleForSection = subject[@"SubjectTitle"];
        cell.textLabel.text = titleForSection;
    }
    else {
    cell.textLabel.text = @"Hello World!";
    }
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * arrayFromSet = [self.subjectSet allObjects];
    self.subjectClicked = arrayFromSet[indexPath.row];
    [self performSegueWithIdentifier:@"goToMessages" sender:self];
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToMessages"])
    {
        MessageViewController * mVC = (MessageViewController *)segue.destinationViewController;
        mVC.clickedSubject = self.subjectClicked;
    }
}
-(void)addSubject{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Add Subject" message:@"subject name" preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
    
    }];
    UIAlertAction * addSubject = [UIAlertAction actionWithTitle:@"Add Class" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UITextField * string = alert.textFields[0];
        
      
        [ClassMapper saveSubject:self.classClicked WithSubject:@"study sesh" refreshTableView:self.tableView];
        
        [ClassMapper getSubjects:self.classClicked block:^(NSArray *parseReturnedSubjects) {
            if (parseReturnedSubjects.count > 0) {
                self.subjectsArray = parseReturnedSubjects;
                self.subjectSet = self.subjectsArray;
                [self.tableView reloadData];
            }
        }];
        
    }];
    [alert addAction:addSubject];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //cancel
    }];
    [alert addAction:cancel];
    [self presentViewController:alert animated:YES completion:nil];
   
    

    
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Subjects";
}



@end
