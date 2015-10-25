//
//  WTAugmentedRealityExperiencesManager.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import <UIKit/UIKit.h>



@class WTAugmentedRealityExperience;

@interface WTAugmentedRealityExperiencesManager : NSObject


- (NSUInteger)numberOfSections;
- (NSInteger)numberOfExperiencesInSection:(NSInteger)section;

- (BOOL)addAugmentedRealityExperience:(WTAugmentedRealityExperience *)experience inSection:(NSUInteger)section moveToTop:(BOOL)moveToTop;
- (BOOL)removeAugmentedRealityExperienceAtIndexPath:(NSIndexPath *)indexPath;

- (WTAugmentedRealityExperience *)augmentedRealityExperienceForIndexPath:(NSIndexPath *)indexPath;

@end

@interface WTAugmentedRealityExperiencesManager (ObjectPersitence)

- (BOOL)saveAugmentedRealityExperiencesToDisk;
- (void)loadAugmentedRealityExperiencesFromDisk;

@end
