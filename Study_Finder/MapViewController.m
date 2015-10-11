//
//  MapViewController.m
//  Study_Finder
//
//  Created by Rich Blanchard on 9/26/15.
//  Copyright © 2015 Rich. All rights reserved.
//

#import "MapViewController.h"
#import "LocationManagerHandler.h"
#import <MapKit/MapKit.h>
#import <Parse/Parse.h>
#import "ClassMapper.h"
#import "User.h"
#import <KBRoundedButton.h>

#define zoominMapArea 2100

@interface MapViewController () <MKMapViewDelegate>
@property (nonatomic,strong)CLLocation* currentLocation;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property MKCircleView *areaOfMessage;
@property (weak, nonatomic) IBOutlet KBRoundedButton *roundedButton;
@property (weak, nonatomic) IBOutlet UISlider *slider;

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpButton];
    self.navigationController.navigationBar.hidden = NO;
    [self.mapView setMapType:MKMapTypeHybrid];
    
    LocationManagerHandler *theLocationManagerHandler = [LocationManagerHandler defaultLocationManagerHandler];
    
    _currentLocation = [[CLLocation alloc] initWithLatitude:theLocationManagerHandler.currentLocation.coordinate.latitude longitude:theLocationManagerHandler.currentLocation.coordinate.longitude];
        NSLog(@"current location is %f", _currentLocation.coordinate.latitude);
    CLLocationCoordinate2D zoomLocation = CLLocationCoordinate2DMake(_currentLocation.coordinate.latitude - 0.0075, _currentLocation.coordinate.longitude - 0.0008);
    MKCoordinateRegion adjustedRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, zoominMapArea, zoominMapArea);
    
    [_mapView setRegion:adjustedRegion animated:YES];
    _mapView.showsUserLocation = YES;
    
    
    PFUser * currentUser = [PFUser currentUser];
    [ClassMapper saveUserLocation:self.currentLocation forUser:currentUser];

}
#pragma mark - Circular Overlay

- (void)addCircle:(NSInteger)radius {
    CLLocationCoordinate2D center = {_currentLocation.coordinate.latitude, _currentLocation.coordinate.longitude};
    MKCircle *circle = [MKCircle circleWithCenterCoordinate:center radius:radius];
    
    [self.mapView addOverlay:circle];
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay {
    self.areaOfMessage = [[MKCircleView alloc] initWithOverlay:overlay];
    [self.areaOfMessage setFillColor:[UIColor redColor]];
    [self.areaOfMessage setAlpha:0.5f];
    return self.areaOfMessage;
}
- (IBAction)changeSize:(UISlider *)sender {
   
    [self.mapView removeOverlay:self.areaOfMessage.circle];
    [self addCircle:sender.value * 200];
    NSLog(@"Your distance is %f",(sender.value*200 / 100));
    
}
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
   
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"String"];
    pin.animatesDrop = YES;
    pin.canShowCallout = YES;
    User * user = annotation;
    UIButton *  rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    pin.rightCalloutAccessoryView = rightButton;
    UIImageView * profilePicImageView = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, 55, 55)];
    profilePicImageView.image = [UIImage imageNamed:@"ballers"];
    //NEED TO BE ABLE TO PUT OTHER USERS PICTURE IN.    
    profilePicImageView.layer.cornerRadius = profilePicImageView.frame.size.width / 2;
    pin.leftCalloutAccessoryView = profilePicImageView;
    
    
    return pin;
}
-(void)setUpButton {
    [self.roundedButton setTitleColorForStateNormal:[UIColor blackColor]];
    [self.roundedButton setBackgroundColorForStateNormal:[UIColor colorWithRed:196.0/255.0 green:171.0/255.0 blue:105.0/255.0 alpha:1.0]];
    [self.roundedButton setTitle:@"Search Users" forState:UIControlStateNormal];
    [self.roundedButton addTarget:self action:@selector(queryLocations) forControlEvents:UIControlEventTouchUpInside];

}
-(void)queryLocations  {
    NSLog(@"I am being called");
    
    PFUser * currentUser = [PFUser currentUser];
    
    PFQuery * queryLocations = [PFUser query];
    PFGeoPoint * geoPoint = [PFGeoPoint geoPointWithLocation:self.currentLocation];
    [queryLocations whereKey:@"Location" nearGeoPoint:geoPoint withinKilometers:(self.slider.value * 200 / 1000)];
    NSLog(@"the 'KM' Is %f",(self.slider.value * 200));
    [queryLocations findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (objects.count > 0) {
            for(PFUser * userWithinRadius in objects) {
                PFGeoPoint * point = userWithinRadius[@"Location"];
                double latitude = point.latitude;
                double longitude = point.longitude;
                CLLocationCoordinate2D friendsCoordinates = CLLocationCoordinate2DMake(latitude, longitude);
                // MKPointAnnotation * spot = [[MKPointAnnotation alloc]init];
                User * spot = [[User alloc]init];
                NSString * user = userWithinRadius[@"username"];
                if(user != currentUser[@"username"]) {
                    
                    spot.title = user;
                    spot.subtitle = @"Norlin";
                    spot.coordinate = friendsCoordinates;
                    [ClassMapper getProfilePictureFromParse:userWithinRadius block:^(NSData *imageReturnedAsData) {
                        spot.picture = [UIImage imageWithData:imageReturnedAsData];
                    }];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [_mapView addAnnotation:spot];
                });
            }
        }
    }];

    
}




@end
