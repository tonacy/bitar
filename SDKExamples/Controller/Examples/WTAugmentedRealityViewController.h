//
//  WTAugmentedRealityViewController.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <WikitudeSDK/WikitudeSDK.h>



@class WTAugmentedRealityExperience;

/**
 * WTAugmentedRealityViewController class
 *
 * This class manages a instance of the WTArchitectView class.
 * It can receive a object of type WTAugmentedRealityExperience which includes information from where the architect view should loaded the Architect World.
 * Also application lifecycle events like UIApplicationWillResignActiveNotification or UIApplicationDidBecomeActiveNotification are handled internally to pause/resume the architect view when the application switches it's state.
 */
@interface WTAugmentedRealityViewController : UIViewController <WTArchitectViewDelegate>

@property (nonatomic, weak) IBOutlet WTArchitectView                *architectView;


- (void)loadAugmentedRealityExperience:(WTAugmentedRealityExperience *)experience showOnlyBackButton:(BOOL)showBackButtonOnlyInNavigationItem;

@end
