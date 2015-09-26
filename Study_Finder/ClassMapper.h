//
//  ClassMapper.h
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>


@interface ClassMapper : NSObject
@property NSMutableArray *userClasses;
+(NSDictionary *)MakeDictionary;
+(NSArray *)create;
+(NSString *)hookUpClasses:(NSString *)userClassSearch;
+(void )matchSearchWithClass:(NSString *)userSearch;
- (void)getClasses:(void(^)(NSMutableArray * who))completionHandler;
+(NSString *)getUserName:(PFUser *)currentUser;
+(void)dummySaveSubject:(PFObject *)classToCheck;
+ (void)getSubjects:(PFObject *)classToSearch block:(void(^)(NSArray * parseReturnedSubjects))completionHandler;
+ (void)getMessages:(PFObject *)subjectsToSearch block:(void(^)(NSArray * parseReturnedMessages))completionHandler;
@end
