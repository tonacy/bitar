//
//  WTAugmentedRealityExperiencesManager+HostSections.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityExperiencesManager.h"



@interface WTAugmentedRealityExperiencesManager (HostSections)

- (instancetype)initWithHostSetup;


- (NSInteger)sectionForHost:(NSString *)host;
- (void)removeHostForSection:(NSInteger)section;

- (NSString *)hostForSection:(NSInteger)section;

@end
