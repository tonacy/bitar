//
//  WTAugmentedRealityExperience.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityExperience.h"



static NSString * kWTAugmentedRealityExperienceArchiveKey_Title = @"TitleKey";
static NSString * kWTAugmentedRealityExperienceArchiveKey_Group = @"GroupKey";
static NSString * kWTAugmentedRealityExperienceArchiveKey_URL = @"URLKey";
static NSString * kWTAugmentedRealityExperienceArchiveKey_Mode = @"ModeKey";


@interface WTAugmentedRealityExperience ()

@property (nonatomic, strong) NSString                      *internalTitle;
@property (nonatomic, strong) NSString                      *internalGroupTitle;
@property (nonatomic, strong) NSURL                         *internalURL;
@property (nonatomic, assign) WTAugmentedRealityMode        internalMode;


//- (instancetype)initWithTitle:(NSString *)title URL:(NSURL *)URL mode:(WTAugmentedRealityMode)mode NS_DESIGNATED_INITIALIZER;

@end

@implementation WTAugmentedRealityExperience

+ (WTAugmentedRealityExperience *)experienceWithTitle:(NSString *)title groupTitle:(NSString *)groupTitle URL:(NSURL *)URL mode:(WTAugmentedRealityMode)mode
{
    WTAugmentedRealityExperience *experience = nil;
    
    if ( [URL isFileURL] )
    {
        if ( [[NSFileManager defaultManager] fileExistsAtPath:[NSString stringWithCString:[URL fileSystemRepresentation] encoding:[NSString defaultCStringEncoding]]] )
        {
            experience = [[WTAugmentedRealityExperience alloc] initWithTitle:title groupTitle:groupTitle URL:URL mode:mode];
        }
    }
    else
    {
        if ( [URL host] )
        {
            experience = [[WTAugmentedRealityExperience alloc] initWithTitle:title groupTitle:groupTitle URL:URL mode:mode];
        }
    }
    
    return experience;
}

- (instancetype)initWithTitle:(NSString *)title groupTitle:(NSString *)groutTitle URL:(NSURL *)URL mode:(WTAugmentedRealityMode)mode
{
    self = [super init];
    if (self)
    {
        _internalTitle = title;
        _internalGroupTitle = groutTitle;
        _internalURL = URL;
        _internalMode = mode;
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)decoder
{
    self = [super init];
    if (self)
    {
        _internalTitle = [decoder decodeObjectForKey:kWTAugmentedRealityExperienceArchiveKey_Title];
        _internalGroupTitle = [decoder decodeObjectForKey:kWTAugmentedRealityExperienceArchiveKey_Group];
        _internalURL = [decoder decodeObjectForKey:kWTAugmentedRealityExperienceArchiveKey_URL];
        _internalMode = [[decoder decodeObjectForKey:kWTAugmentedRealityExperienceArchiveKey_Mode] integerValue];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:_internalTitle forKey:kWTAugmentedRealityExperienceArchiveKey_Title];
    [encoder encodeObject:_internalGroupTitle forKey:kWTAugmentedRealityExperienceArchiveKey_Group];
    [encoder encodeObject:_internalURL forKey:kWTAugmentedRealityExperienceArchiveKey_URL];
    [encoder encodeObject:@(_internalMode) forKey:kWTAugmentedRealityExperienceArchiveKey_Mode];
}


#pragma mark - Properties

- (NSString *)title
{
    return _internalTitle;
}

- (NSString *)groupTitle
{
    return _internalGroupTitle;
}

- (NSURL *)URL
{
    return _internalURL;
}

- (WTAugmentedRealityMode)mode
{
    return _internalMode;
}

@end
