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
                
                
                
            }];
            [self groups:groups withSubjects:subjects andClass:classesFromDict];
           
           
//            OrderedDictionary * test = [[OrderedDictionary alloc]init];
//            [test insertObject:groups forKey:@"groups" atIndex:0];
//            [test insertObject:subjects forKey:@"subjects" atIndex:0];
//            [test insertObject:classesFromDict forKey:@"Class" atIndex:0];
//            [test insertObject:arrayForMessages forKey:@"Messages" atIndex:0];
//            NSMutableArray * checker = [self.parseDetails objectForKey:@"indexedSubjects"];
//            [checker insertObject:test atIndex:0];
            
            
        
        }];
    }
    
    
}
-(void)groups:(NSArray*)groups withSubjects:(NSArray *)subjects andClass:(PFObject *)Class
{
     OrderedDictionary * test = [[OrderedDictionary alloc]init];

    
    [test insertObject:groups forKey:@"groups" atIndex:0];
    [test insertObject:subjects forKey:@"subjects" atIndex:0];
    [test insertObject:Class forKey:@"Class" atIndex:0];
    NSMutableArray * checker = [self.parseDetails objectForKey:@"indexedSubjects"];
    [checker insertObject:test atIndex:0];
}
-(void)sortOrder {
     NSMutableArray * checker = [self.parseDetails objectForKey:@"indexedSubjects"];
    NSMutableArray * arrayOfArraysForMessages = [[NSMutableArray alloc]init];
   dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
     dispatch_async(queue, ^{
         for(int i =0; i < checker.count; i++) {
        OrderedDictionary * dict = checker[i];
        NSArray * subjectArray = [dict valueForKey:@"subjects"];
        for(int j = 0; j < subjectArray.count; j++) {
        
            PFObject * subject = subjectArray[j];
        PFRelation * getMessages = [subject relationForKey:@"Messages"];
        PFQuery * queryMessages = [getMessages query];
        [queryMessages findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
            if(objects.count > 0) {
            [arrayOfArraysForMessages addObject:objects];
            }
        }];
             //[dict setValue:arrayOfArraysForMessages forKey:@"Messages"];
            
        }
             [dict insertObject:arrayOfArraysForMessages forKey:@"Messages" atIndex:i];
    }
         
         });
}


@end
