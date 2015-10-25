//
//  WTAugmentedRealityViewController+ScreenshotSharing.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 25/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityViewController+ScreenshotSharing.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>



@implementation WTAugmentedRealityViewController (ScreenshotSharing)

#pragma mark - Public Methods

- (void)captureScreen
{
    if ( [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook] )
    {
        NSDictionary* info = @{};
        [self.architectView captureScreenWithMode: WTScreenshotCaptureMode_CamAndWebView usingSaveMode:WTScreenshotSaveMode_Delegate saveOptions:WTScreenshotSaveOption_None context:info];
    }
    else
    {
        NSDictionary* info = @{};
        [self.architectView captureScreenWithMode: WTScreenshotCaptureMode_CamAndWebView usingSaveMode:WTScreenshotSaveMode_PhotoLibrary saveOptions:WTScreenshotSaveOption_CallDelegateOnSuccess context:info];
    }
}

#pragma mark - Delegation
#pragma mark WTArchitectView

- (void)architectView:(WTArchitectView *)architectView didCaptureScreenWithContext:(NSDictionary *)context
{
    UIImage* image = (UIImage *)[context objectForKey:kWTScreenshotImageKey];
    WTScreenshotSaveMode saveMode = [[context objectForKey:kWTScreenshotSaveModeKey] unsignedIntegerValue];
    
    switch (saveMode)
    {
        case WTScreenshotSaveMode_Delegate:
            [self postImageOnFacebook:image];
            break;
            
        case WTScreenshotSaveMode_PhotoLibrary:
            [self showPhotoLibraryAlert];
            break;
            
        default:
            break;
    }
    
}

- (void)architectView:(WTArchitectView *)architectView didFailCaptureScreenWithError:(NSError *)error
{
    NSLog(@"Error capturing screen: %@", error);
}

#pragma mark - Private Methods

- (void)postImageOnFacebook:(UIImage *)image
{
    SLComposeViewController* composerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    
    [composerSheet setInitialText:@"Wikitude screen shot"];
    [composerSheet addImage:image];
    [composerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result)
        {
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
            break;
            
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
            break;
                
            default:
            break;
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Facebook" message:output delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        [alert show];
    }];
    
    [self presentViewController:composerSheet animated:YES completion:nil];
}

- (void)showPhotoLibraryAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Success" message:@"Shapshot was stored in your photo library" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

@end
