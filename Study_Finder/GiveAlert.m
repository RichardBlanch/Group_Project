//
//  GiveAlert.m
//  Study_Finder
//
//  Created by Rich Blanchard on 10/27/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "GiveAlert.h"


@implementation GiveAlert
+(void)giveAlertForSubjectsAndSave:(NSString *)Title message:(NSString *)message  buttonActionTitle:(NSString *)buttonActionTitle additionalObject:(PFObject *)object tableView:(UITableView *)tableView forViewController:(UIViewController *)vc  {
   
   
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Add Subject" message:@"Subject Name" preferredStyle:(UIAlertControllerStyleAlert)];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
    }];
    UIAlertAction * addSubject = [UIAlertAction actionWithTitle:buttonActionTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField * string = alert.textFields[0];
        
        
        
        [ClassMapper saveSubject:object WithSubject:string.text refreshTableView:tableView];
        
        
       
        
    }];
    [alert addAction:addSubject];
    UIAlertAction * cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //cancel
    }];
    [alert addAction:cancel];
    [vc presentViewController:alert animated:YES completion:nil];
   
}
@end
