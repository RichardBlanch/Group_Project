//
//  ParseDetails.h
//  
//
//  Created by Rich Blanchard on 11/2/15.
//
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseDetails : NSObject
+ (ParseDetails *)sharedParseDetails;
- (id)init;
@property (nonatomic,strong) NSCache * parseDetails;
- (void)getClasses:(void(^)(NSMutableArray * userClasses))completionHandler;

@end
