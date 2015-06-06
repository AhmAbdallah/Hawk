//
//  ViewController.m
//  Hawk
//
//  Created by Chase Acton on 6/5/15.
//  Copyright (c) 2015 Chase Acton. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

- (IBAction)pickLocation{
    HawkSearchController *hawk = [[HawkSearchController alloc] init];
    hawk.delegate = self;
    hawk.barTitle = @"Pick A Location";
    hawk.tintColor = [UIColor redColor];
    [self presentViewController:hawk animated:TRUE completion:nil];
}

#pragma mark - Hawk Delegate -

- (void)didCancelMapSearch{
    NSLog(@"User cancelled picking location");
}

- (void)didSelectMapLocation:(CLPlacemark *)placemark{
    NSLog(@"User picked location");
    
    NSDictionary *addressDictionary = placemark.addressDictionary;
    locationLabel.text = [NSString stringWithFormat:@"%@, %@, %@ %@, %@",
                          [addressDictionary valueForKey:@"Street"],
                          [addressDictionary valueForKey:@"SubAdministrativeArea"],
                          [addressDictionary valueForKey:@"State"],
                          [addressDictionary valueForKey:@"ZIP"],
                          [addressDictionary valueForKey:@"CountryCode"]];
}

@end