# Hawk
A simple iOS control for picking map locations

![alt tag](http://chaseacton.com/cdn/Hawk/Hawk.png)

### Installation

* Copy the contents of the 'Source' folder to your project
* Import MapKit.framework

### Usage

#### .h
Import Hawk and set your view controller as the delegate
```objective-c
#import <UIKit/UIKit.h>
#import "HawkSearchController.h"

@interface ViewController : UIViewController <HawkDelegate>
```

#### .m
Create a new HawkSearchController and set the delegate
```objective-c
- (IBAction)pickLocation{
    HawkSearchController *hawk = [[HawkSearchController alloc] init];
    hawk.delegate = self;
    [self presentViewController:hawk animated:TRUE completion:nil];
}
```

Implement Hawk's delegate methods
```objective-c
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
```

#### Customization
Optionally, you can set Hawk's title and tint color
```objective-c
- (IBAction)pickLocation{
    HawkSearchController *hawk = [[HawkSearchController alloc] init];
    hawk.delegate = self;
    hawk.barTitle = @"Pick A Location";
    hawk.tintColor = [UIColor redColor];
    [self presentViewController:hawk animated:TRUE completion:nil];
}
```
#### Notes
* Hawk looks best when presented modally. Display issues may arise if inside a navigation controller.
