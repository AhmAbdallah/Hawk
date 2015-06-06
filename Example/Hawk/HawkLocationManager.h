//
//  HawkLocationManager.h
//  Hawk
//
//  Created by Chase Acton on 6/5/15.
//  Copyright (c) 2015 Chase Acton. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface HawkLocationManager : NSObject <CLLocationManagerDelegate>{
    
    CLLocationManager *locationManager;
    float lat;
    float lon;
    
}

+ (id)sharedInstance;
- (void)startLocating;
- (void)getPlacemarkFromLocation:(CLLocation *)location completion:(void (^)(CLPlacemark *placemark)) block;
- (void)getPlacemarkFromSearch:(NSString *)search completion:(void (^)(CLPlacemark *placemark)) block;

@end