//
//  WTAugmentedRealityViewController+ApplicationModelExample.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 25/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityViewController+ApplicationModelExample.h"

#import <CoreLocation/CoreLocation.h>
#import <objc/runtime.h>

#import "WTPoi.h"
#import "WTPoiManager.h"



/* this is used to create random positions around you */
#define WT_RANDOM(startValue, endValue) ((((float) (arc4random() % ((unsigned)RAND_MAX + 1)) / RAND_MAX) * (endValue - startValue)) + startValue)


@implementation WTAugmentedRealityViewController (ApplicationModelExample)

- (void)startLocationUpdatesForPoiInjection
{
    WTPoiManager *poiManager = [[WTPoiManager alloc] init];
    objc_setAssociatedObject(self, kWTAugmentedRealityViewController_AssociatedPoiManagerKey, poiManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    CLLocationManager *locationManager = [[CLLocationManager alloc] init];
    objc_setAssociatedObject(self, kWTAugmentedRealityViewController_AssociatedLocationManagerKey, locationManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    locationManager.delegate = self;
    [locationManager startUpdatingLocation];
}

#pragma mark - Delegation
#pragma mark CLLocationManager
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    id firstLocation = [locations firstObject];
    if ( firstLocation )
    {
        CLLocation *location = (CLLocation *)firstLocation;
        [manager stopUpdatingLocation];
        manager.delegate = nil;
        
        [self generatePois:20 aroundLocation:location];
        
        WTPoiManager *poiManager = objc_getAssociatedObject(self, kWTAugmentedRealityViewController_AssociatedPoiManagerKey);
        NSString *poisInJsonData = [poiManager convertPoiModelToJson];
        
        [self.architectView callJavaScript:[NSString stringWithFormat:@"World.loadPoisFromJsonData(%@)", poisInJsonData]];
    }
}

- (void)generatePois:(NSUInteger)numberOfPois aroundLocation:(CLLocation *)referenceLocation
{
    WTPoiManager *poiManager = objc_getAssociatedObject(self, kWTAugmentedRealityViewController_AssociatedPoiManagerKey);
    [poiManager removeAllPois];
    
    for (NSUInteger i = 0; i < numberOfPois; ++i) {
        
        NSString *poiName = [NSString stringWithFormat:@"POI #%lu", (unsigned long)i];
        NSString *poiDescription = [NSString stringWithFormat:@"Probably one of the best POIs you have ever seen. This is the description of Poi #%lu", (unsigned long)i];
        
        CLLocationCoordinate2D locationCoordinate = CLLocationCoordinate2DMake(referenceLocation.coordinate.latitude + WT_RANDOM(-0.3, 0.3), referenceLocation.coordinate.longitude + WT_RANDOM(-0.3, 0.3));
        CLLocationDistance altitude = referenceLocation.verticalAccuracy ? referenceLocation.altitude + WT_RANDOM(0, 200) : -32768.f;
        
        CLLocation *location = [[CLLocation alloc] initWithCoordinate:locationCoordinate
                                                             altitude:altitude
                                                   horizontalAccuracy:referenceLocation.horizontalAccuracy
                                                     verticalAccuracy:referenceLocation.verticalAccuracy
                                                            timestamp:referenceLocation.timestamp];
        
        WTPoi *poi = [[WTPoi alloc] initWithIdentifier:i
                                              location:location
                                                  name:poiName
                                   detailedDescription:poiDescription];
        
        
        [poiManager addPoi:poi];
    }
}

@end
