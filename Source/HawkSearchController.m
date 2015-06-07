//
//  HawkSearchController.m
//  Hawk
//
//  Created by Chase Acton on 6/5/15.
//  Copyright (c) 2015 Chase Acton. All rights reserved.
//

#import "HawkSearchController.h"
#import "HawkLocationManager.h"

@implementation HawkSearchController
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [[HawkLocationManager sharedInstance] startLocating];
    [self setupUI];
}

- (void)setupUI{
    mapView.showsUserLocation = YES;
    toolbar.clipsToBounds = TRUE;
    
    if (self.tintColor){
        [selectLabel setTextColor:self.tintColor];
        toolbar.tintColor = self.tintColor;
        searchBar.tintColor = self.tintColor;
        [centerButton setBackgroundColor:self.tintColor];
    }
    
    if (self.barTitle){
        titleLabel.text = self.barTitle;
    }
}

- (IBAction)selectLocation{
    [self.delegate didSelectMapLocation:currentPlacemark];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

- (IBAction)cancel{
    [self.delegate didCancelMapSearch];
    [self dismissViewControllerAnimated:TRUE completion:nil];
}

#pragma mark - MKMapView -

- (void)mapView:(MKMapView *)map regionDidChangeAnimated:(BOOL)animated{
    [self updateToLocation:map.centerCoordinate];
}

- (void)mapView:(MKMapView *)map regionWillChangeAnimated:(BOOL)animated{
    selectLabel.text = @"Updating your location...";
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    centerButton.hidden = FALSE;
}

- (void)updateToLocation:(CLLocationCoordinate2D)location{
    CLLocation *searchLocation = [[CLLocation alloc] initWithLatitude:location.latitude longitude:location.longitude];
    [[HawkLocationManager sharedInstance] getPlacemarkFromLocation:searchLocation completion:^(CLPlacemark *placemark) {
        currentPlacemark = placemark;
        NSDictionary *addressDictionary = placemark.addressDictionary;
        selectLabel.text = @"Select this location";
        addressLabel.text = [NSString stringWithFormat:@"%@, %@, %@ %@, %@",
                              [addressDictionary valueForKey:@"Street"],
                              [addressDictionary valueForKey:@"City"],
                              [addressDictionary valueForKey:@"State"],
                              [addressDictionary valueForKey:@"ZIP"],
                              [addressDictionary valueForKey:@"CountryCode"]];
    }];
}

- (void)mapView:(MKMapView *)map didUpdateUserLocation:(MKUserLocation *)userLocation {
    if(userLocationShown){
        return;
    }
    
    userLocationShown = TRUE;
    CLLocationCoordinate2D location;
    location.latitude = userLocation.coordinate.latitude;
    location.longitude = userLocation.coordinate.longitude;
    [self centerMapOnLocation:location animated:FALSE];
    [self updateToLocation:map.centerCoordinate];
}

- (void)centerMapOnLocation:(CLLocationCoordinate2D)coordinate animated:(BOOL)animated{
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.005;
    span.longitudeDelta = 0.005;
    region.span = span;
    region.center = coordinate;
    [mapView setRegion:region animated:animated];
}

- (IBAction)toggleSearchBar{
    searchBar.hidden = !searchBar.hidden;
    if (searchBar.hidden){
        [self.view endEditing:TRUE];
    }else{
        [searchBar becomeFirstResponder];
    }
}

- (IBAction)centerMap{
    [self centerMapOnLocation:mapView.userLocation.coordinate animated:TRUE];
    centerButton.hidden = TRUE;
}

#pragma mark - UISearchBar -

- (void)searchBarCancelButtonClicked:(UISearchBar *)bar{
    [self.view endEditing:TRUE];
    [self toggleSearchBar];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)bar{
    [[HawkLocationManager sharedInstance] getPlacemarkFromSearch:searchBar.text completion:^(CLPlacemark *placemark) {
        [self centerMapOnLocation:placemark.location.coordinate animated:FALSE];
        [self updateToLocation:placemark.location.coordinate];
        [self.view endEditing:TRUE];
        centerButton.hidden = FALSE;
    }];
}

@end