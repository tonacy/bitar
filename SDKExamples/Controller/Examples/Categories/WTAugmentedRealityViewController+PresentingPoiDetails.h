//
//  WTAugmentedRealityViewController+PresentingPoiDetails.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 25/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityViewController.h"



/**
 * WTAugmentedRealityViewController (PresentingPoiDetails)
 *
 * This category provides implementation details for the example 'Browsing Pois - Native Detail Screen'
 *
 * It triggers a segue which pushes a poi detail view controller onto the current controller stack.
 */
@interface WTAugmentedRealityViewController (PresentingPoiDetails)

- (void)presentPoiDetails:(NSDictionary *)poiDetails;

@end
