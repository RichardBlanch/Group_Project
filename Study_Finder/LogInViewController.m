//
//  LogInViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/26/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "LogInViewController.h"
#import <Parse/Parse.h>
#import <KBRoundedButton.h>

#import "OrderedDictionary.h"

@interface LogInViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextfield;
@property (weak, nonatomic) IBOutlet KBRoundedButton *roundedButton;

@end

@implementation LogInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.roundedButton setTitleColorForStateNormal:[UIColor blackColor]];
    [self.roundedButton setBackgroundColorForStateNormal:[UIColor colorWithRed:196.0/255.0 green:171.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [self.roundedButton setTitle:@"Log In" forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)login:(id)sender {
    self.roundedButton.working = YES;
    [PFUser logInWithUsernameInBackground:self.usernameTextField.text password:self.passwordTextfield.text block:^(PFUser * _Nullable user, NSError * _Nullable error) {
        if(error ) {
            NSLog(@"ERROR!");
        }
        else {
            NSLog(@"sucess");
            [self performSegueWithIdentifier:@"searchClasses" sender:self];
        }
        
    }];
    
}
- (IBAction)SignUpSegue:(id)sender {
    [self performSegueWithIdentifier:@"goToSignUp" sender:self];
}


@end
