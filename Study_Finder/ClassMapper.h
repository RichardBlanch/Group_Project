//
//  ClassMapper.h
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ClassMapper : NSObject
+(NSDictionary *)MakeDictionary;
+(NSArray *)create;
+(NSString *)hookUpClasses:(NSString *)userClassSearch;
+(void )matchSearchWithClass:(NSString *)userSearch;
@end
