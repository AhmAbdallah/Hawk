//
//  HawkSearchController.h
//  Hawk
//
//  Created by Chase Acton on 6/5/15.
//  Copyright (c) 2015 Chase Acton. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@protocol HawkDelegate
@optional
-(void)didSelectMapLocation:(CLPlacemark *)placemark;
-(void)didCancelMapSearch;
@end

@interface HawkSearchController : UIViewController <MKMapViewDelegate, UISearchBarDelegate>{
    
    bool userLocationShown;
    
    CLPlacemark *currentPlacemark;
        
    IBOutlet MKMapView *mapView;
    IBOutlet UILabel *addressLabel, *selectLabel, *titleLabel;
    IBOutlet UIToolbar *toolbar;
    IBOutlet UISearchBar *searchBar;
    IBOutlet UIButton *centerButton;
    
}

@property(nonatomic, retain) id <HawkDelegate> delegate;
@property (nonatomic,retain) UIColor *tintColor;
@property (nonatomic, retain) NSString *barTitle;

@end