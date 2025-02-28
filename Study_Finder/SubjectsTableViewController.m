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
#import "ParseDetails.h"
#import "OrderedDictionary.h"


@interface SubjectsTableViewController ()
@property (nonatomic,strong)  NSString * addSubjectTextField;
@property (nonatomic,strong)  NSArray * groupsArray;
@property (nonatomic,strong)  NSMutableArray * messages;
@property (nonatomic,strong)  NSMutableArray * postedBy;
@property (nonatomic,strong)  NSMutableDictionary * postedByDict;




@end

@implementation SubjectsTableViewController
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setUpController];
    self.postedBy = [[NSMutableArray alloc]init];
    self.postedByDict = [[NSMutableDictionary alloc]init];
}





#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
        return self.subjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuse" forIndexPath:indexPath];
    if(self.subjectsOrGroupSegmentControl.selectedSegmentIndex == 0) {
       
        if(self.subjects.count > 0) {
            PFObject * subject = self.subjects[indexPath.row];
            NSString * titleForSection = subject[@"SubjectTitle"];
            cell.textLabel.text = titleForSection;
        }
   
//        if (self.subjectsArray.count > 0) {
//        NSArray * arrayFromSet = [self.subjectSet allObjects];
//        PFObject * subject = arrayFromSet[indexPath.row];
//        NSString * titleForSection = subject[@"SubjectTitle"];
//        cell.textLabel.text = titleForSection;
//    }
    }
    else {

        PFObject* group = self.groupsArray[indexPath.row];
        cell.textLabel.text = group[@"groupName"];
        
    }
    
    
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray * arrayFromSet = [self.subjectSet allObjects];
    self.subjectClicked = arrayFromSet[indexPath.row];
    ParseDetails * parseCache = [ParseDetails sharedParseDetails];
    NSArray * tempArray =  [parseCache.parseDetails objectForKey:@"indexedSubjects"];
    NSDictionary * tempDict = tempArray[indexPath.row];
    self.messages = [tempDict valueForKey:@"Messages"];
   
    
    OrderedDictionary * classAndPicsDict = [tempDict valueForKey:@"ClassmatesWithPhotos"];
    
    
    ParseDetails * parse = [ParseDetails sharedParseDetails];
    NSMutableArray * something = [parse.parseDetails objectForKey:@"indexedSubjects"];
    NSDictionary * subjectsAndMessages = something[self.indexPathForUse];
    NSArray * MessagesArrayBig = [subjectsAndMessages valueForKey:@"Messages"];
    OrderedDictionary * orderDict = MessagesArrayBig[indexPath.row];
    self.messages = [orderDict valueForKey:@"Messages"];
    self.postedBy = [orderDict valueForKey:@"postedBy"];
    NSArray * classMembers = [classAndPicsDict valueForKey:@"ClassMember"];
    NSMutableSet * mutableSetOne = [NSMutableSet setWithArray:self.postedBy];
    NSMutableSet * mutableSetTwo = [NSMutableSet setWithArray:classMembers];
    NSArray * postedByStringSubject;
    NSArray * postedByStringClass;
    /*
     for(int i = 0; i < self.postedBy.count; i++) {
     
     PFUser * test = [[classAndPicsDict keyAtIndex:i] valueForKey:@"ClassMember"];
     NSLog(@"Test is %@",test[@"username"]);
     [self.postedByDict setObject:[classAndPicsDict valueForKey:@"Picture"] forKey:@"Picture"];
     
     if([classAndPicsDict valueForKey:@"Picture"] != nil) {
     [self.postedByDict setObject:[classAndPicsDict valueForKey:@"ClassMember"] forKey:@"ClassMember"];
     }
     else {
     [self.postedByDict setObject:[UIImage imageNamed:@"ballers"] forKey:@"ClassMember"];
     }
     INSERT PHOTOS HERE
     
     
     NSLog(@"postedByDict = %@",self.postedByDict);
     }
     INSERT PHOTOS HERE
     */

   
    for(PFObject * postedBy in [classAndPicsDict valueForKey:@"ClassMember"]) {
        if([self.postedBy containsObject:postedBy]) {
            [ self.postedByDict setObject:[classAndPicsDict valueForKey:@"Picture"] forKey:@"Picture"];
            if([classAndPicsDict valueForKey:@"Picture"] != nil) {
            [self.postedByDict setObject:[classAndPicsDict valueForKey:@"ClassMember"] forKey:@"ClassMember"];
            }
            else {
                [self.postedByDict setObject:[UIImage imageNamed:@"ballers"] forKey:@"ClassMember"];
            }
            
        }
        NSLog(@"postedByDict = %@",self.postedByDict);
    }
    
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self performSegueWithIdentifier:@"goToMessages" sender:self];
    });
    

    
    
    
   
    
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToMessages"])
    {
        MessageViewController * mVC = (MessageViewController *)segue.destinationViewController;
        mVC.clickedSubject = self.subjectClicked;
        mVC.classmates = self.classmates;
        mVC.parentClass = self.classClicked;
        mVC.messages = self.messages;
        mVC.postedBy = self.postedBy;
        
    }
}
-(void)addSubject {
    
    [GiveAlert giveAlertForSubjectsAndSave:@"Subject Name" message:@"Message" buttonActionTitle:@"Add Subject" additionalObject:self.classClicked tableView:self.tableView forViewController:self];
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Subjects";
}
-(void)setUpController {

   
            
            [self.tableView reloadData];
    
    
    UIBarButtonItem * ADD = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addSubject)];
    
    self.navigationItem.rightBarButtonItem = ADD;
}
- (IBAction)changeToGroupOrSection:(id)sender {
    switch (self.subjectsOrGroupSegmentControl.selectedSegmentIndex) {
        case 0:
            [self.tableView reloadData];
            break;
        case 1:
             [self.tableView reloadData];
            break;
           
            
            
        default:
            break;
    }
}





@end
