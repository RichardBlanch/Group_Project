//
//  SearchClassesViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "SearchClassesViewController.h"
#import "ClassMapper.h"

@interface SearchClassesViewController ()
@property (weak, nonatomic) IBOutlet UITextField *classNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *classNumberTwoTextField;

@end

@implementation SearchClassesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)search:(id)sender {
    NSMutableString * userSearch = [[NSMutableString alloc]init];
    [userSearch appendString:self.classNumberTextField.text];
    [userSearch appendString:self.classNumberTwoTextField.text];
    NSString * classFound = [ClassMapper hookUpClasses:userSearch];
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"Your Class" message:[NSString stringWithFormat:@"%@",classFound] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * yes = [UIAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //ADD CODE FOR SEGUE
    }];
    [alertController addAction:yes];
    [self presentViewController:alertController animated:YES completion:nil];
    [ClassMapper matchSearchWithClass:userSearch];
    
    
    
}




@end
