//
//  HawkLocationManager.m
//  Hawk
//
//  Created by Chase Acton on 6/5/15.
//  Copyright (c) 2015 Chase Acton. All rights reserved.
//

#import "HawkLocationManager.h"

@implementation HawkLocationManager

+ (id)sharedInstance {
    static HawkLocationManager *sharedMyInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyInstance = [[self alloc] init];
    });
    return sharedMyInstance;
}

- (id)init{
    self = [super init];
    if (self != nil){
    }
    return self;
}

- (void)startLocating{
    [self startUpdatingLocation];
}

- (void)startUpdatingLocation{
    //Initialize location manager and start retrieving current location
    locationManager = [[CLLocationManager alloc] init];
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.delegate = self;
    [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

- (void)getPlacemarkFromLocation:(CLLocation *)location completion:(void (^)(CLPlacemark *placemark)) block{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *result = [placemarks firstObject];
        block(result);
    }];
}

- (void)getPlacemarkFromSearch:(NSString *)search completion:(void (^)(CLPlacemark *placemark)) block{
    CLGeocoder *geoCoder = [[CLGeocoder alloc] init];
    [geoCoder geocodeAddressString:search completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *result = [placemarks firstObject];
        block(result);
    }];
}

- (void)locationManager:(CLLocationManager *)mgr didFailWithError:(NSError *)error{
    //Could not get location. This most likely means the user disallowed location permissions
    NSLog(@"Couldn't get location");
    [locationManager stopUpdatingLocation];
    locationManager = nil;
}

@end