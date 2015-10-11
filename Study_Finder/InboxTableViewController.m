//
//  InboxTableViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 10/7/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "InboxTableViewController.h"
#import <Parse/Parse.h>
#import "CustomMessageTableViewCell.h"
#import "ClassMapper.h"

@interface InboxTableViewController ()
@property (nonatomic,strong) NSMutableDictionary * senders;
@property int counter;

@end

@implementation InboxTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.estimatedRowHeight = 80;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.senders = [[NSMutableDictionary alloc]init];
   self.navigationItem.title = @"Inbox";
   
    for(PFObject * message in self.messages) {
        self.counter = 0;
         PFRelation * sender = [message relationForKey:@"SentFrom"];
        PFQuery * queryUsers = [sender query];
        [queryUsers findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(objects){
                PFUser * user = objects[0];
            [ClassMapper getProfilePictureFromParse:user block:^(NSData *imageReturnedAsData) {
                UIImage * userImage = [UIImage imageWithData:imageReturnedAsData];
                NSMutableArray * pictureAndUser = [[NSMutableArray alloc]init];
                [pictureAndUser addObject:user[@"username"]];
                [pictureAndUser addObject:userImage];
                
                
                
                [self.senders setObject:pictureAndUser forKey:[NSString stringWithFormat:@"Message%d",self.counter]];
                self.counter++;
                 [self.tableView reloadData];
               
                
            }];
            }
        }];
       
    }
    NSLog(@"dic is %@",self.senders);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return self.senders.allKeys.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CustomMessageTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MessageCell"];
    PFObject * message = self.messages[indexPath.row];
   

     NSString * messageContent = message[@"Message"];
    cell.messageContentLabel.text = messageContent;
    
    cell.profileImageView.image = self.senders.allValues[indexPath.row][1];
    cell.senderLabel.text = self.senders.allValues[indexPath.row][0];
     NSLog(@"dic is %@",self.senders);
    return cell;
   
}




@end
