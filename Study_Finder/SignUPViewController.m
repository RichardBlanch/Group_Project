//
//  SignUPViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "SignUPViewController.h"
#import <Parse/Parse.h>

@interface SignUPViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@end

@implementation SignUPViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
        }
        else {
             NSLog(@"ERROR SIGNING UP");
        }
                }];
}



@end
