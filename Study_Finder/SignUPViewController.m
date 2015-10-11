//
//  SignUPViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "SignUPViewController.h"
#import <Parse/Parse.h>
#import <KBRoundedButton.h>
#import "ClassMapper.h"
#import "SearchClassesViewController.h"

@interface SignUPViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet KBRoundedButton *roundedButton;
@property (weak,nonatomic) UIImage * imageToSaveToParse;

@end

@implementation SignUPViewController 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.roundedButton setTitleColorForStateNormal:[UIColor blackColor]];
    [self.roundedButton setBackgroundColorForStateNormal:[UIColor colorWithRed:196.0/255.0 green:171.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [self.roundedButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    self.navigationController.navigationBar.hidden = YES;
}
- (IBAction)addImage:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    NSLog(@"info is %@",info);
    picker.delegate = self;
    self.imageToSaveToParse = info[UIImagePickerControllerOriginalImage];
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}

- (IBAction)signUp:(id)sender {
    PFUser * currentUser = [PFUser user];
    currentUser.username = self.usernameTextField.text;
    currentUser.password = self.passwordTextField.text;
    currentUser.email = self.emailTextField.text;
   // currentUser[@"profilePicture"]
    [currentUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (error == nil) {
            NSLog(@"sucess user signed up.");
           
            
            
            [self performSegueWithIdentifier:@"searchClasses" sender:self];
        }
        else {
             NSLog(@"ERROR SIGNING UP");
        }
                }];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"searchClasses"]) {
        SearchClassesViewController * scvc = (SearchClassesViewController *)segue.destinationViewController;
        scvc.imageToSave = self.imageToSaveToParse;
        
    }
}




@end
