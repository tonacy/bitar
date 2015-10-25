//
//  WTAugmentedRealityViewController+ApplicationModelExample.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 25/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityViewController.h"



static char *kWTAugmentedRealityViewController_AssociatedPoiManagerKey = "kWTARVCAMEWTP";
static char *kWTAugmentedRealityViewController_AssociatedLocationManagerKey = "kWTARVCAMECLK";


/**
 * WTAugmentedRealityViewController (ApplicationModelExample)
 *
 * This category provides implementation details for the example 'Obtain Poi Data - From Application Model'
 *
 * It uses a CLLocationManager to get the current location, then creates poi data around this location and finally inject's the newly created poi data into JavaScript where the actual drawables are created.
 */
@interface WTAugmentedRealityViewController (ApplicationModelExample) <CLLocationManagerDelegate>

- (void)startLocationUpdatesForPoiInjection;

@end
