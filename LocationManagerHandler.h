//
//  LocationManagerHandler.h
//  iOS-MessagingApp
//
//  Created by ricardo antonio cacho on 2015-07-29.
//  Copyright (c) 2015 ricardo antonio cacho. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationManagerHandler : NSObject

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong,nonatomic) CLLocation *currentLocation;

+ (instancetype)defaultLocationManagerHandler;

-(void)setUpLocationManager;

@end
