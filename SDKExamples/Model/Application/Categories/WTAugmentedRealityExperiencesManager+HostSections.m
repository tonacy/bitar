//
//  WTAugmentedRealityExperiencesManager+HostSections.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityExperiencesManager+HostSections.h"

#import <objc/runtime.h>

#import "WTAugmentedRealityExperience.h"



static char *kWTAugmentedRealityExperienceManager_AssociatedObjectKey = "kWTAREMAOK";

@implementation WTAugmentedRealityExperiencesManager (HostSections)

- (instancetype)initWithHostSetup
{
    self = [self init];
    if (self)
    {
        NSMutableDictionary *hostLookupTable = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, kWTAugmentedRealityExperienceManager_AssociatedObjectKey, hostLookupTable, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self loadAugmentedRealityExperiencesFromDisk];
        
        for (NSUInteger i = 0; i < [self numberOfSections]; i++)
        {
            WTAugmentedRealityExperience *experience = [self augmentedRealityExperienceForIndexPath:[NSIndexPath indexPathForRow:0 inSection:i]];
            [self sectionForHost:experience.groupTitle];
        }
    }
    
    return self;
}


- (NSInteger)sectionForHost:(NSString *)host
{
    NSInteger section = -1;
    
    if (host)
    {
        NSMutableDictionary *hostLookupTable = (NSMutableDictionary *)objc_getAssociatedObject(self, kWTAugmentedRealityExperienceManager_AssociatedObjectKey);
        id object = [hostLookupTable objectForKey:host];
        if ( !object )
        {
            section = [[hostLookupTable allKeys] count];
            [hostLookupTable setObject:@(section) forKey:host];
        }
        else
        {
            section = [object integerValue];
        }
    }
    
    return section;
}

- (void)removeHostForSection:(NSInteger)section
{
    NSString *hostToRemove = [self hostForSection:section];

    if ( hostToRemove )
    {
        NSMutableDictionary *hostLookupTable = (NSMutableDictionary *)objc_getAssociatedObject(self, kWTAugmentedRealityExperienceManager_AssociatedObjectKey);
        [hostLookupTable removeObjectForKey:hostToRemove];
    }
}

- (NSString *)hostForSection:(NSInteger)section
{
    NSString *hostToFind = nil;
        
    NSMutableDictionary *hostLookupTable = (NSMutableDictionary *)objc_getAssociatedObject(self, kWTAugmentedRealityExperienceManager_AssociatedObjectKey);
    for ( NSString *host in [hostLookupTable allKeys] )
    {
        id object = [hostLookupTable objectForKey:host];
        if ( section == [object integerValue] )
        {
            hostToFind = host;
        }
    }
    
    return hostToFind;
}

@end
