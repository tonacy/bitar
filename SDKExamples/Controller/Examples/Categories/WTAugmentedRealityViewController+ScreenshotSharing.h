//
//  WTAugmentedRealityViewController+ScreenshotSharing.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 25/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityViewController.h"



/**
 * WTAugmentedRealityViewController (ScreenshotSharing)
 *
 * This category provides implementation details for the example 'Browsing Pois - Capture Screen Bonus'
 *
 * It implements two capture screen related architect view delegate methods. These methods provide information about the capture screen success state and the location of the saved screen shot.
 *
 * Furthermore it uses the screen shot to upload it to facebook if a account is specified. Oterwise the image is saved into the device photo library
 */
@interface WTAugmentedRealityViewController (ScreenshotSharing)

- (void)captureScreen;

@end
