//
//  ProfileViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "ProfileViewController.h"
#import "ClassMapper.h"
#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "SubjectsTableViewController.h"
#import "classmatesTableViewController.h"
#import "ParseDetails.h"
#import "OrderedDictionary.h"

@interface ProfileViewController ()  <dismissToGroupsAndClasses>
@property ClassMapper * mapper;
@property (nonatomic,strong) NSMutableArray * classes;
@property (nonatomic,strong) PFObject * userClickedClass;
@property (nonatomic,strong) UIImage * profPicChanged;
@property (nonatomic,strong) UIImage * profPicGrabbedFromParse;
@property (nonatomic,strong) NSMutableArray * groupSelected;
@property (nonatomic,strong) NSMutableArray * subjectSelected;
@property (nonatomic,strong) NSMutableDictionary * functionalDict;
@property  NSInteger  indexPathForUse;


@end

@implementation ProfileViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.groupSelected = [[NSMutableArray alloc]init];
    self.subjectSelected = [[NSMutableArray alloc]init];
     ParseDetails * parseCache = [ParseDetails sharedParseDetails];
    NSMutableArray * something = [parseCache.parseDetails objectForKey:@"indexedSubjects"];
    for(NSDictionary * dict in something) {
        OrderedDictionary * classMatesWithPhotos = [dict objectForKey:@"ClassmatesWithPhotos"];
        NSLog(@"The classmate is %@",[classMatesWithPhotos valueForKey:@"ClassMember"]);
        NSLog(@"The picture is %@",[classMatesWithPhotos valueForKey:@"Picture"]);
    }
    
    
    
     self.classes = [[NSMutableArray alloc]init];
     self.tableView.separatorColor = [UIColor lightGrayColor];
    self.mapper = [[ClassMapper alloc]init];

        [self setUpTableView];
    
    
    self.navigationController.navigationBar.hidden = NO;
   
    

    

   
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ParseDetails * parseCache = [ParseDetails sharedParseDetails];
//     self.subjectSelected = [self.functionalDict valueForKey:[NSString stringWithFormat:@"Subject%d",indexPath.row]];
//    self.groupSelected = [self.functionalDict valueForKey:[NSString stringWithFormat:@"Group%d",indexPath.row]];
   NSArray * tempArray =  [parseCache.parseDetails objectForKey:@"indexedSubjects"];
    self.groupSelected = [tempArray[indexPath.row] valueForKey:@"groups"];
    self.subjectSelected = [tempArray[indexPath.row] valueForKey:@"subjects"];
    self.indexPathForUse = indexPath.row;
   
    
    [self performSegueWithIdentifier:@"goToSubjects" sender:self];
}



-(void)setUpTableView {
    
    ParseDetails * parseCache = [ParseDetails sharedParseDetails];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.classes = [parseCache.parseDetails objectForKey:@"classes"];
        
    OrganicCell * helloWorldCell = [OrganicCell cellWithStyle:UITableViewCellStyleValue1 height:100 actionBlock:^{
        //
    }];
       
        
        PFUser * currentUser = [PFUser currentUser];
        PFFile * file = currentUser[@"profilePicture"];
        [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            if(data) {
                UIImage * profPicFromParse = [UIImage imageWithData:data];
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.profPicGrabbedFromParse = profPicFromParse;
                    helloWorldCell.imageView.image = self.profPicGrabbedFromParse;
                    helloWorldCell.textLabel.text = [ClassMapper getUserName:[PFUser currentUser]];
                    helloWorldCell.imageView.userInteractionEnabled = YES;
                    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addPhoto)];
                    helloWorldCell.imageView.gestureRecognizers = @[tap];
                    
                });
            }
        }];

   
        
    
    OrganicCell * goodByeWorldCell = [OrganicCell cellWithStyle:UITableViewCellStyleValue2 height:55 actionBlock:^{
        //
    }];
    goodByeWorldCell.textLabel.text = @"";
    goodByeWorldCell.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0];
    
    OrganicSection * firstStaticSection = [OrganicSection sectionWithHeaderTitle:@"User" cells:@[helloWorldCell,goodByeWorldCell]];
    
    NSArray *demoDataSource = @[@"Computer Systems", @"Software-Development", @"Astronomy", @"Calculus"];
    OrganicSection *sectionWithReuse = [OrganicSection sectionSupportingReuseWithTitle:@"Classes" cellCount:self.classes.count cellHeight:55 cellForRowBlock:^UITableViewCell *(UITableView *tableView, NSInteger row) {
        static NSString *cellReuseID = @"celReuseID";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseID];
      //  NSLog(@"array is %@",self.mapper.userClasses);
       
        
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellReuseID];
            
        }
        
        PFObject * class = [self.functionalDict valueForKey:[NSString stringWithFormat:@"Class%d",row]];
        NSMutableArray * something = [parseCache.parseDetails objectForKey:@"indexedSubjects"];
        PFObject * test = [something[row] valueForKey:@"Class"];
        NSString * className = test[@"ClassName"];
        cell.textLabel.text = className;
        return cell;
        
    } actionBlock:^(NSInteger row) {
       
    }];
    
    self.sections = @[firstStaticSection, sectionWithReuse];
                   });
   //  [self addBarButtonItem];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"goToSubjects"]) {
        SubjectsTableViewController * vc = (SubjectsTableViewController *)segue.destinationViewController;
        vc.subjects = self.subjectSelected;
        vc.groups = self.groupSelected;
        vc.indexPathForUse = self.indexPathForUse;
    }
}
-(void)addPhoto {
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc]init];
    [self presentViewController:imagePicker animated:YES completion:nil];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
}
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    PFUser * user = [PFUser currentUser];
    self.profPicChanged = info[@"UIImagePickerControllerOriginalImage"];
    [self dismissViewControllerAnimated:YES completion:nil];
    [ClassMapper updateImage:user withPhoto:self.profPicChanged];
    
}







@end
