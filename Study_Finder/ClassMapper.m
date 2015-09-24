//
//  ClassMapper.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/23/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "ClassMapper.h"




@implementation ClassMapper
+(NSArray *)create{
    NSMutableDictionary * dic = [[NSMutableDictionary alloc] init];
    NSString * path = [[NSBundle mainBundle]pathForResource:@"computerScience" ofType:@"txt"];
    NSString * text = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSMutableArray * text2 = [text componentsSeparatedByString:@"\n"];
    return text2;
    
}

+(NSString *)hookUpClasses:(NSString *)key
{
   return @"";
}
+(void)MakeDictionary {
    NSMutableString * classes = [NSMutableString string];
    NSArray * class = [self create];
    for (int i = 0; i < class.count; i++) {
        NSString * clas = class[i];
        if (clas != @"") {
            NSArray * splitter = [clas componentsSeparatedByString:@" "];
            NSLog(@"the first is %@",splitter[i]);
        }
    }
    
   // return @{@"hi":5};
    
    
}


@end
