//
//  ClassMapper.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "ClassMapper.h"







@implementation ClassMapper
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.userClasses = [[NSMutableArray alloc]init];
    }
    return self;
}
+(NSArray *)create{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"computerScience" ofType:@"txt"];
    NSString * text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray * text2 = [text componentsSeparatedByString:@"\n"];
    return text2;
    
}
- (void)getClasses:(void(^)(NSMutableArray * who))completionHandler{
    PFUser * currentUser = [PFUser currentUser];
    NSMutableArray * tempArrayForClasses = [[NSMutableArray alloc]init];
    
    PFRelation * relation = [currentUser relationForKey:@"Classes"];
    PFQuery * query = [relation query];
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
           if(objects.count > 0) {
               for (PFObject * object in objects) {
                   [tempArrayForClasses addObject:object];

               }
               
               completionHandler(tempArrayForClasses);
           }
           
       }];


   
}


+(NSString *)hookUpClasses:(NSString *)userClassSearch
{
    NSDictionary * dictionaryForMappingUserSearch = [self MakeDictionary];
    NSArray * classNumber = dictionaryForMappingUserSearch.allKeys;
    NSArray * classDecription = dictionaryForMappingUserSearch.allValues;

    if([classNumber containsObject:userClassSearch]) {
        NSLog(@"YEAH WE GOT THAT GUY");
        return userClassSearch;
    }
    
    
    return  @"";
    
    
}
+(NSDictionary *)MakeDictionary {
    NSMutableDictionary * mapForSearch = [[NSMutableDictionary alloc]init];
    NSMutableString * classes = [NSMutableString string];
    NSSet * set = [NSSet setWithArray:[self create]];
    
    
    for(NSString * string in set) {
        NSString * realString = string;
        if(![realString isEqualToString:@""])
        {
            NSMutableString * stringToAppendClassDetails = [[NSMutableString alloc]init];
            NSArray * classNumbers = [realString componentsSeparatedByString:@" " ];
            NSMutableString * classNumberCulminated = [[NSMutableString alloc]init];
            [classNumberCulminated appendString:classNumbers[0]];
             [classNumberCulminated appendString:classNumbers[1]];
            
            
            for( int i = 5;  i < classNumbers.count ; i++)
            {
                if(![classNumbers[i] isEqualToString:@"REC"]) {
                    if(![classNumbers[i] isEqualToString:@"LEC"]) {
                    [stringToAppendClassDetails appendFormat:@" %@",classNumbers[i]];
                    }
                
                }
               
            }
            [mapForSearch setObject:stringToAppendClassDetails forKey:classNumberCulminated];

           
           
        }
    }
    NSDictionary * mapDict = [NSDictionary dictionaryWithDictionary:mapForSearch];
       NSLog(@"mapDict is %@",mapDict);
    

    return mapDict;
}
+(NSString *)getUserName:(PFUser *)currentUser {
    NSString * userName = currentUser[@"username"];
    return userName;
    
}

+(void)matchSearchWithClass:(NSString *)userSearch {
    PFQuery * query = [PFQuery queryWithClassName:@"Class"];
    [query whereKey:@"ClassName" containsString:userSearch];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        NSLog(@"objects are %@",objects);
        PFUser * currentUser = [PFUser currentUser];
        PFRelation * relation = [currentUser relationForKey:@"Classes"];
        PFObject * class = objects[0];
        [relation addObject:class];
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            if(succeeded)
            {
                
                PFRelation * ClassMembers = [class relationForKey:@"ClassMember"];
                [ClassMembers addObject:currentUser];
                [class saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                    if (succeeded) {
                        NSLog(@"all gucci");
                    }
                }];
                
                
            }
        }];
        
        
            }];
}
+(void)saveSubject:(PFObject *)classToCheck WithSubject:(NSString *)subjectToSave refreshTableView:(UITableView *)tableView {
    
    PFObject * newSubject = [PFObject objectWithClassName:@"Subject"];
    newSubject[@"SubjectTitle"] = subjectToSave;
    [newSubject saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"saved dummy Subject");
            PFRelation * relation = [classToCheck relationForKey:@"SubjectsForClass"];
            [relation addObject:newSubject];
            [classToCheck saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
                if (error == nil) {
                    NSLog(@"potentially saved relationship.");
                    [tableView reloadData];
                }
            }];
        }
    }];

}

+ (void)getSubjects:(PFObject *)classToSearch block:(void(^)(NSArray * parseReturnedSubjects))completionHandler {
    PFRelation * subjectsForClass = [classToSearch relationForKey:@"SubjectsForClass"];
    PFQuery * query = [subjectsForClass query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(objects.count > 0) {
            completionHandler(objects);
        }
    }];

}
+ (void)getMessages:(PFObject *)subjectsToSearch block:(void(^)(NSArray * parseReturnedMessages))completionHandler {
    PFRelation * messagesForClass = [subjectsToSearch relationForKey:@"Messages"];
    PFQuery * query = [messagesForClass query];
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(objects.count > 0) {
            completionHandler(objects);
        }
    }];
    
}
+(void)updateImage:(PFUser *)currentUser withPhoto:(UIImage *)profilePic {
    NSData * data = UIImageJPEGRepresentation(profilePic, 0.5f);
    PFFile * imageFile = [PFFile fileWithName:@"Image.jpg" data:data];
    currentUser[@"profilePicture"] = imageFile;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if(succeeded) {
            NSLog(@"saved photo");
        }
    }];
}
+ (void)getProfilePictureFromParse:(PFUser *)currentUser block:(void(^)(NSData * imageReturnedAsData))completionHandler {
    
    PFFile * file = currentUser[@"profilePicture"];
    [file getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        if(data) {
            completionHandler(data);
        }
    }];
}
+(void)saveUserLocation:(CLLocation *)currentLocation forUser:(PFUser *)currentUser {
    PFGeoPoint * location = [PFGeoPoint geoPointWithLocation:currentLocation];
    currentUser[@"Location"] = location;
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"saved users location");
        }
    }];
}
+(void)getClassmates:(PFObject *)class block:(void (^)(NSArray * parseReturnedClassmates))completionHandler {
    
    PFRelation * classmates = [class relationForKey:@"ClassMember"];
    PFQuery * query = classmates.query;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if(objects.count > 0) {
            completionHandler(objects);
            
        }
    }];
}
+(void)getInbox:(PFUser *)User block:(void (^)(NSArray * parseReturnedClassmates))completionHandler {
    PFRelation * inbox = [User relationForKey:@"Inbox"];
    PFQuery * query = inbox.query;
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            for(PFObject * message in objects) {
                NSString * string = message[@"Message"];
                NSLog(@"%@",string);
            }
            completionHandler(objects);
        }
    }];
}





@end
