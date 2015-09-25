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
            
            
            for( int i = 5;  i < classNumbers.count ; i++) //NEED TO FIX THIS WHY CRASH?
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

@end
