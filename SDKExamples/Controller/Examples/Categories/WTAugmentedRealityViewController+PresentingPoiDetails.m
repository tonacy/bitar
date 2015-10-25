//
//  WTAugmentedRealityViewController+PresentingPoiDetails.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 25/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityViewController+PresentingPoiDetails.h"

#import <objc/runtime.h>

#import "WTPoi.h"
#import "WTPoiManager.h"

#import "WTAugmentedRealityViewController+ApplicationModelExample.h"
#import "WTPoiDetailViewController.h"



NSString * const kWTSegueIdentifier_PresentPoiDetails = @"kWTSegueIdentifier_PresentPoiDetails";


@implementation WTAugmentedRealityViewController (PresentingPoiDetails)

#pragma mark - Public Methods

- (void)presentPoiDetails:(NSDictionary *)poiDetails
{
    NSInteger poiIdentifier = [[poiDetails objectForKey:@"id"] integerValue];
    NSString *poiName = [poiDetails objectForKey:@"title"];
    NSString *poiDescription = [poiDetails objectForKey:@"description"];
    
    WTPoi *poi = [[WTPoi alloc] initWithIdentifier:poiIdentifier location:nil name:poiName detailedDescription:poiDescription];
    
    if (poi)
    {
        [self performSegueWithIdentifier:kWTSegueIdentifier_PresentPoiDetails sender:poi];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.destinationViewController isKindOfClass:[WTPoiDetailViewController class]]
        &&
         [sender isKindOfClass:[WTPoi class]]  )
    {
        WTPoiDetailViewController *poiDetailViewController = (WTPoiDetailViewController *)segue.destinationViewController;
        WTPoi *poi = (WTPoi *)sender;
        poiDetailViewController.poi = poi;
    }
}

@end
