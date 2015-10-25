//
//  WTAugmentedRealityExperiencesManager+ExampleSections.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityExperiencesManager.h"



typedef void(^WTAugmentedRealityExperiencesLoadCompletionHandler)(void);


@interface WTAugmentedRealityExperiencesManager (ExampleSections)

- (BOOL)hasLoadedAugmentedRealityExperiencesFromPlist;

- (void)loadAugmentedRealityExperiencesFromPlist:(WTAugmentedRealityExperiencesLoadCompletionHandler)completionHandler;

- (NSString *)exampleGroupTitleForSection:(NSInteger)section;

@end
