//
//  WTAugmentedRealityExperiencesManager+ExampleSections.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityExperiencesManager+ExampleSections.h"

#import "WTAugmentedRealityExperience.h"



@implementation WTAugmentedRealityExperiencesManager (ExampleSections)


#pragma mark - Public Methods

- (BOOL)hasLoadedAugmentedRealityExperiencesFromPlist
{
    return [self numberOfSections] > 0;
}

- (void)loadAugmentedRealityExperiencesFromPlist:(WTAugmentedRealityExperiencesLoadCompletionHandler)completionHandler
{
    NSURL *examplesPlistURL = [[NSBundle mainBundle] URLForResource:@"Examples" withExtension:@"plist"];
    NSArray *examplesArray = [NSArray arrayWithContentsOfURL:examplesPlistURL];
    if (examplesPlistURL)
    {
        NSUInteger section = 0;
        for ( NSArray *groupArray in examplesArray )
        {
            for ( NSDictionary *example in groupArray )
            {
                NSString *title = [example objectForKey:@"Title"];
                NSString *groupTitle = [example objectForKey:@"GroupTitle"];
                NSString *relativePath = [example objectForKey:@"Path"];
                WTAugmentedRealityMode mode = [self augmentedRealityModeFromString:[example objectForKey:@"Mode"]];
                
                NSString *bundleSubdirectory = [[NSString stringWithFormat:@"ARchitectExamples"] stringByAppendingPathComponent:relativePath];                
                NSURL *absoluteURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html" subdirectory:bundleSubdirectory];
                
                WTAugmentedRealityExperience *experience = [WTAugmentedRealityExperience experienceWithTitle:title groupTitle:groupTitle URL:absoluteURL mode:mode];
                [self addAugmentedRealityExperience:experience inSection:section moveToTop:NO];
            }
            
            section++;
        }
    }
    
    if ( completionHandler )
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler();
        });
    }
}

- (NSString *)exampleGroupTitleForSection:(NSInteger)section
{
    WTAugmentedRealityExperience *experience = [self augmentedRealityExperienceForIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
    return experience.groupTitle;
}

#pragma mark - Private Methods


- (WTAugmentedRealityMode)augmentedRealityModeFromString:(NSString *)modeString
{
    WTAugmentedRealityMode mode = WTAugmentedRealityMode_GeoAndImageRecognition;
    
    if ( modeString )
    {
        if ( [[modeString lowercaseString] isEqualToString:@"ir"] )
        {
            mode = WTAugmentedRealityMode_ImageRecognition;
        }
        else if ( [[modeString lowercaseString] isEqualToString:@"geo"] )
        {
            mode = WTAugmentedRealityMode_Geo;
        }
    }
    
    return mode;
}

@end
