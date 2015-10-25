//
//  WTCreateURLViewController.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import <UIKit/UIKit.h>



typedef NS_ENUM(NSUInteger, WTURLCreationState) {
    WTURLCreationState_Success,
    WTURLCreationState_Canceled,
    WTURLCreationState_Error
};


@class WTAugmentedRealityExperience;

@interface WTCreateURLViewController : UITableViewController

@property (nonatomic, weak) IBOutlet UITextField            *urlTextField;
@property (nonatomic, weak) IBOutlet UITextField            *titleTextField;
@property (nonatomic, weak) IBOutlet UISwitch               *arModeSwitch;

@property (nonatomic, assign) WTURLCreationState            state;


- (void)prepareForURLCreation;
- (WTAugmentedRealityExperience *)createdAugmentedRealityExperience;

@end
