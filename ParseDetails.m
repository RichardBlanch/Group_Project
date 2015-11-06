//
//  ParseDetails.m
//  
//
//  Created by Rich Blanchard on 11/2/15.
//
//

#import "ParseDetails.h"
#import "OrderedDictionary.h"

@implementation ParseDetails

+ (ParseDetails *)sharedParseDetails
{
    static ParseDetails *theSharedCart = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        theSharedCart = [[ParseDetails alloc] init];
    });
    
    return theSharedCart;
}
- (id)init
{
    if (self = [super init]) {
        self.parseDetails = [[NSCache alloc]init];
        [self getClasses:^(NSMutableArray *userClasses) {
        }];
        
        
    }
    
    return self;
}
- (void)getClasses:(void(^)(NSMutableArray * userClasses))completionHandler{
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
            [self.parseDetails setObject:tempArrayForClasses forKey:@"classes"];
            [self getSubjects:tempArrayForClasses];
        }
        
        
    }];
}
-(void)getSubjects:(NSArray *)tempArrayForClasses
{
   
   
    
    NSMutableArray * arrayOfDict = [[NSMutableArray alloc]init];
     NSMutableArray* classWithClassMates = [[NSMutableArray alloc]init];
    
    [self.parseDetails setObject:arrayOfDict forKey:@"indexedSubjects"];
    
   
    
    for(int i = 0; i < tempArrayForClasses.count; i ++) {
        PFObject * classesFromDict = tempArrayForClasses[i];
            PFRelation * subjectsForClass = [classesFromDict relationForKey:@"SubjectsForClass"];
            PFQuery * query = [subjectsForClass query];
        NSMutableArray * groups = [[NSMutableArray alloc]init];
        
        [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            NSArray * subjects;
           
            subjects = objects;
           
            
        
                
           
            PFRelation * groupsForClass = [tempArrayForClasses[i] relationForKey:@"GroupsForClass"];
            PFQuery * excecuteQuery = [groupsForClass query];
            
            [excecuteQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                for(PFObject * group in objects) {
                    [groups addObject:group];
                   
                    
                }
               
                dispatch_queue_t queue;
                queue = dispatch_queue_create("getClassmates", NULL);
                 dispatch_async(queue, ^{
                
                PFRelation * classmates = [tempArrayForClasses[i] relationForKey:@"ClassMember"];
                PFQuery * classMateQuery = classmates.query;
                 
                     for(PFObject * classMate in [classMateQuery findObjects]) {
                         [classWithClassMates addObject:classMate];
                     }
                      [self groups:groups withSubjects:subjects andClass:classesFromDict andWithClassmates:classWithClassMates];
                 });
                
                
            }];
           
        }];
    }
    
    
}
-(void)groups:(NSArray*)groups withSubjects:(NSArray *)subjects andClass:(PFObject *)Class andWithClassmates:(NSArray *)classMates
{
     OrderedDictionary * test = [[OrderedDictionary alloc]init];
    NSMutableArray * dictionaryOfClassMatesWithPhotos = [[NSMutableArray alloc]init];
     dispatch_queue_t queue;
    queue = dispatch_queue_create("getClassmates", NULL);
    dispatch_async(queue, ^{
        for(PFObject * classmate in classMates) {
            OrderedDictionary * classMateWithPhoto = [[OrderedDictionary alloc]init];
            PFFile * file = classmate[@"profilePicture"];
            NSData * userPick = [file getData];
            UIImage * userPicture = [UIImage imageWithData:userPick];
            
            [classMateWithPhoto insertObject:classmate forKey:@"ClassMember" atIndex:0];
            if(userPicture != nil) {
            [classMateWithPhoto insertObject:userPicture forKey:@"Picture" atIndex:0];
            }
            [dictionaryOfClassMatesWithPhotos insertObject:classMateWithPhoto atIndex:0];
        
        }
    });
    
    
    [test insertObject:groups forKey:@"groups" atIndex:0];
    [test insertObject:subjects forKey:@"subjects" atIndex:0];
    [test insertObject:Class forKey:@"Class" atIndex:0];
    [test insertObject:dictionaryOfClassMatesWithPhotos forKey:@"ClassmatesWithPhotos" atIndex:0];
    NSMutableArray * checker = [self.parseDetails objectForKey:@"indexedSubjects"];
    [checker insertObject:test atIndex:0];
}



@end
