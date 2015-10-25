//
//  WTAugmentedRealityExperience.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WikitudeSDK/WikitudeSDK.h>



/**
 * WTAugmentedREalityExperience class
 *
 * This class represents a Wikitude SDK example in this application.
 * A example has a title, group title, URL and a augmented reality mode which specifies which requirements the ARchitect World has in regards of functionality.
 *
 * Also custom URLs are represented as an object of this class.
 */
@interface WTAugmentedRealityExperience : NSObject <NSCoding>

@property (nonatomic, strong, readonly) NSString                        *title;
@property (nonatomic, strong, readonly) NSString                        *groupTitle;
@property (nonatomic, strong, readonly) NSURL                           *URL;
@property (nonatomic, assign, readonly) WTAugmentedRealityMode          mode;


+ (WTAugmentedRealityExperience *)experienceWithTitle:(NSString *)title groupTitle:(NSString *)groupTitle URL:(NSURL *)URL mode:(WTAugmentedRealityMode)mode;

@end
