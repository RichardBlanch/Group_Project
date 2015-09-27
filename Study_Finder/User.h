//
//  User.h
//  Study_Finder
//
//  Created by Rich Blanchard on 9/26/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface User : MKPointAnnotation
@property (nonatomic,strong) NSString * name;
@property (nonatomic,strong) NSString * sub;
@property  CLLocationCoordinate2D  distance;
@property (nonatomic,strong) UIImage * picture;
- (instancetype)initWithName:(NSString * )name andSubtitle:(NSString *)subtitle andLocation:(CLLocationCoordinate2D)coordinate andImage:(UIImage *)image;

@end
