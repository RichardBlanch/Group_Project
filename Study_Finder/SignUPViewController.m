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

@interface SignUPViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet KBRoundedButton *roundedButton;

@end

@implementation SignUPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.roundedButton setTitleColorForStateNormal:[UIColor blackColor]];
    [self.roundedButton setBackgroundColorForStateNormal:[UIColor colorWithRed:196.0/255.0 green:171.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [self.roundedButton setTitle:@"Sign Up" forState:UIControlStateNormal];
    self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)signUp:(id)sender {
    PFUser * currentUser = [PFUser user];
    currentUser.username = self.usernameTextField.text;
    currentUser.password = self.passwordTextField.text;
    currentUser.email = self.emailTextField.text;
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



@end
