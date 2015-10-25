//
//  WTAugmentedRealityExperiencesManager.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityExperiencesManager.h"

#include "WTAugmentedRealityExperience.h"



@interface WTAugmentedRealityExperiencesManager ()
@property (nonatomic, strong) NSMutableArray                        *augmentedRealityExperiences;
@end


@implementation WTAugmentedRealityExperiencesManager

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _augmentedRealityExperiences = [NSMutableArray arrayWithCapacity:1];
    }
    
    return self;
}


- (NSUInteger)numberOfSections
{
    return self.augmentedRealityExperiences.count;
}

- (NSInteger)numberOfExperiencesInSection:(NSInteger)section
{
    NSInteger numberOfExperiencesInSection = 0;
    
    if (self.augmentedRealityExperiences.count >= section)
    {
        NSMutableArray *sectionArray = [self.augmentedRealityExperiences objectAtIndex:section];
        numberOfExperiencesInSection = sectionArray.count;
    }
    
    return numberOfExperiencesInSection;
}


- (BOOL)addAugmentedRealityExperience:(WTAugmentedRealityExperience *)experience inSection:(NSUInteger)section moveToTop:(BOOL)moveToTop
{
    BOOL addedNewSection = NO;
    
    if (experience)
    {        
        /* section does not exist -> create section and add experience */
        if ( self.augmentedRealityExperiences.count <= section )
        {
            NSMutableArray *sectionArray = [NSMutableArray arrayWithObject:experience];
            [self.augmentedRealityExperiences addObject:sectionArray];
            
            addedNewSection = YES;
        }
        /* section exists -> add experience */
        else
        {
            NSMutableArray *sectionArray = [self.augmentedRealityExperiences objectAtIndex:section];
            if (moveToTop)
            {
                [sectionArray insertObject:experience atIndex:0];
            }
            else
            {
                [sectionArray addObject:experience];
            }
        }
    }
    
    return addedNewSection;
}

- (BOOL)removeAugmentedRealityExperienceAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL removedSection = NO;
    
    if ( self.augmentedRealityExperiences.count >= indexPath.section )
    {
        NSMutableArray *sectionArray = [self.augmentedRealityExperiences objectAtIndex:indexPath.section];
        if (sectionArray)
        {
            [sectionArray removeObjectAtIndex:indexPath.row];
            
            if ( 0 == sectionArray.count )
            {
                [self.augmentedRealityExperiences removeObjectAtIndex:indexPath.section];
                removedSection = YES;
            }
        }
    }
    
    return removedSection;
}

- (WTAugmentedRealityExperience *)augmentedRealityExperienceForIndexPath:(NSIndexPath *)indexPath
{
    WTAugmentedRealityExperience *experience = nil;
    
    if ( self.augmentedRealityExperiences.count >= indexPath.section )
    {
        NSMutableArray *sectionArray = [self.augmentedRealityExperiences objectAtIndex:indexPath.section];
        if (sectionArray && sectionArray.count >= indexPath.row)
        {
            experience = [sectionArray objectAtIndex:indexPath.row];
        }
    }
    
    return experience;
}

@end


@implementation WTAugmentedRealityExperiencesManager (ObjectPersistence)

- (BOOL)saveAugmentedRealityExperiencesToDisk
{
    return [NSKeyedArchiver archiveRootObject:[self.augmentedRealityExperiences copy] toFile:[self persitentExperiencesFilePath]];
}

- (void)loadAugmentedRealityExperiencesFromDisk
{
    id unarchivedObject = [NSKeyedUnarchiver unarchiveObjectWithFile:[self persitentExperiencesFilePath]];
    if (unarchivedObject)
    {
        self.augmentedRealityExperiences = [unarchivedObject mutableCopy];
    }
}

- (NSString *)persitentExperiencesFilePath
{
    NSString *persistentAugmentedRealityExperiencesFilePath = nil;
    
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (searchPaths) {
        NSString *path = [searchPaths firstObject];
        path = [path stringByAppendingPathComponent:@"Application Support/PersitentObjects"];
        
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        BOOL isDirectory;
        BOOL fileExist = [fileManager fileExistsAtPath:path isDirectory:&isDirectory];
        if ( !fileExist )
        {
            BOOL directoryCreated = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
            if ( !directoryCreated ) {
                NSLog(@"Unable to create directory for persistent augmented reality experiences");
            }
        }
        
        NSURL *attributesURL = [NSURL fileURLWithPath:path isDirectory:YES];
        if (attributesURL)
        {
            NSError *error = nil;
            BOOL success = [attributesURL setResourceValue:@(YES) forKey:NSURLIsExcludedFromBackupKey error:&error];
            if (!success) {
                NSLog(@"Error setting URL attribute for backup exclude: %@", error);
            }
        }
        
        persistentAugmentedRealityExperiencesFilePath = [path stringByAppendingPathComponent:@"augemntedRealityExperiences"];
    }
    
    return persistentAugmentedRealityExperiencesFilePath;
}

@end
