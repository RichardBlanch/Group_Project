//
//  User.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/26/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "User.h"

@implementation User
- (instancetype)initWithName:(NSString * )name andSubtitle:(NSString *)subtitle andLocation:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image
{
    self = [super init];
    if (self) {
        self.name = name;
        self.sub = subtitle;
        self.coordinate = coordinate;
        self.picture = image;
        
    }
    return self;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        //
    }
    return self;
}

@end
