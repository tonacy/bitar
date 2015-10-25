//
//  WTAugmentedRealityViewController+ExampleCategoryManagement.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 25/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityViewController+ExampleCategoryManagement.h"

#import "WTAugmentedRealityExperience.h"

#import "WTAugmentedRealityViewController+ApplicationModelExample.h"
#import "WTAugmentedRealityViewController+PresentingPoiDetails.h"
#import "WTAugmentedRealityViewController+ScreenshotSharing.h"



@implementation WTAugmentedRealityViewController (ExampleCategoryManagement)

#pragma mark - Public Methods

- (void)loadExampleSpecificCategoryForAugmentedRealityExperience:(WTAugmentedRealityExperience *)augmentedRealityExperience
{
    if ( [self isAugmentedRealityExperience:augmentedRealityExperience kindOfExample:@"4_ObtainPoiData_1_FromApplicationModel"] )
    {
        [self startLocationUpdatesForPoiInjection];
    }
}

#pragma mark - Private Methods

- (BOOL)isAugmentedRealityExperience:(WTAugmentedRealityExperience *)augmentedRealityExperience kindOfExample:(NSString *)exampleIdentifier
{
    return NSNotFound != [[augmentedRealityExperience.URL absoluteString] rangeOfString:exampleIdentifier].location;
}

@end
