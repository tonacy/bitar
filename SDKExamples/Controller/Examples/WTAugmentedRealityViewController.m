//
//  WTAugmentedRealityViewController.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTAugmentedRealityViewController.h"

#import "NSURL+ParameterQuery.h"

#import "WTAugmentedRealityExperience.h"

#import "WTAugmentedRealityViewController+ExampleCategoryManagement.h"
#import "WTAugmentedRealityViewController+PresentingPoiDetails.h"
#import "WTAugmentedRealityViewController+ScreenshotSharing.h"



/* Wikitude SDK license key (only valid for this application's bundle identifier) */
#define kWT_LICENSE_KEY @"tW3Ht861dC8lNC2/xnahrP7DRI7nqfXDGZfUvdeIGJsc64QLICf0leLIO50svo8me8yrGBcglCEHwAQEhqs8eOceTQ0iXJhF6Glf016W/tDsCSXMetFz4vdZIHzOdNOOBJEKuIEPYZgyffutNigYtdWpPzS33L1OQLoVkdQ3z/NTYWx0ZWRfX21xcPVHf8nkO6IcVarrd+BPN3s78E/Ac39sjGX90LKiVK47DeMMovn5X5X3vXIcwrxe3WRZqL6sczpdObKvll+Qwvpbrnej1ausee5uUCCXFC6oevbcnuWyqgYXzctjCjrJlcdfzL1EgPi9W4i87bnT1uf8IYISiPwBlK7vNvLpBIfryzyn9t4EKMGr5X0GTgXA11G5BJW2wkgukMSt7zp8fE1XurT/C97tTtN9P/w5lyWnpjm/1Qt8n409QxB09A9ZW2x9vcOoTzyCKQyTXduWyhW4hv6gXHZUU5A88PJBGtFpX63f40VURgi+6hMNy2Q4I57Ck0d+NTJHQnPbm2NoHKiAkFr5LS2A91lnhF3BI9Qx8YPpjStPNslW93NJPXOstmSFDLep9MpNx+tLzPMRBj5HLjSTPCzWZSQSuXSj31hc/nwoaVl+0MvQzNC1YQdS1QcjeQx5Ln6nFaW+eCmRHOOAZZQJUJeaVvLSMll+zaYwZ+WrIYDCMx/nCwjtQ7Y+Voj2sivGIxPNrcDUuWul6q2D3WJmUwjquibs2M97lLljwojpgLfRf8hWynpvnfliTgk2OZUT96+vcwLW3FHkCLFteuRQ2g=="


@interface WTAugmentedRealityViewController ()

@property (nonatomic, assign) BOOL                                          showsBackButtonOnlyInNavigationItem;
@property (nonatomic, weak) WTAugmentedRealityExperience                    *augmentedRealityExperience;
@property (nonatomic, copy) WTNavigation                                    *loadedArchitectWorldNavigation;
@property (nonatomic, weak) WTNavigation                                    *loadingArchitectWorldNavigation;
@property (weak, nonatomic) IBOutlet UIButton *leftB;
@property (weak, nonatomic) IBOutlet UIButton *rightB;
@property (weak, nonatomic) IBOutlet UILabel *leftL;
@property (weak, nonatomic) IBOutlet UILabel *rightL;
@property (weak, nonatomic) IBOutlet UIButton *resetB;
@property (strong, nonatomic) WTArchitectView *otherAV;

@end


@implementation WTAugmentedRealityViewController


- (IBAction)leftPressed:(id)sender {
	int x = [self.leftL.text intValue];
	x++;
	self.leftL.text = [NSString stringWithFormat:@"%i", x];
	
}


- (IBAction)rightPressed:(id)sender {
	int x = [self.rightL.text intValue];
	x++;
	self.rightL.text = [NSString stringWithFormat:@"%i", x];
	
}



- (IBAction)resetPressed:(id)sender {
	self.rightL.text = @"0";
	self.leftL.text = @"0";
}



- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /* Architect view specific initialization code 
     * - a license key is set to enable all SDK features
     * - the architect view delegate is set so that the application can react on SDK specific events
     */
    [self.architectView setLicenseKey:kWT_LICENSE_KEY];
    self.architectView.delegate = self;
	
	

    /* The architect view needs to be paused/resumed when the application is not active. We use UIApplication specific notifications to pause/resume architet view rendering depending on the application state */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveApplicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	
	NSString *title = @"Image On Target";
	NSString *groupTitle = @"Image Recognition";
	NSString *relativePath = @"1_ImageRecognition_1_ImageOnTarget";
	WTAugmentedRealityMode mode = WTAugmentedRealityMode_ImageRecognition;
	
	NSString *bundleSubdirectory = [[NSString stringWithFormat:@"ARchitectExamples"] stringByAppendingPathComponent:relativePath];
	NSURL *absoluteURL = [[NSBundle mainBundle] URLForResource:@"index" withExtension:@"html" subdirectory:bundleSubdirectory];
	
	WTAugmentedRealityExperience *experience = [WTAugmentedRealityExperience experienceWithTitle:title groupTitle:groupTitle URL:absoluteURL mode:mode];
	
	[self loadAugmentedRealityExperience:experience showOnlyBackButton:YES];
    
    /* Set’s a nicely formatted navigation item title based on from where this view controller was pushed onto the navigation stack */
    NSString *navigationItemTitle = self.augmentedRealityExperience.title;
    if ( UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom] )
    {
        NSString *urlString = [self.augmentedRealityExperience.URL isFileURL] ? @"" : [NSString stringWithFormat:@" - %@", [self.augmentedRealityExperience.URL absoluteString]];
        navigationItemTitle = [NSString stringWithFormat:@"%@%@", self.augmentedRealityExperience.title, urlString];
    }
    self.navigationItem.title = navigationItemTitle;
    
    if ( self.showsBackButtonOnlyInNavigationItem )
    {
        self.navigationItem.rightBarButtonItem = nil;
    }
    
    /* Depending on the currently load architect world a new world will be loaded */
    [self checkExperienceLoadingStatus];
    /* And the Wikitude SDK rendering is resumed if it’s currently paused */
    [self startArchitectViewRendering];
    /* Just to make sure that the Wikitude SDK is rendering in the correct interface orientation just in case the orientation changed while this view was not visible */
    [self.architectView setShouldRotate:YES toInterfaceOrientation:self.interfaceOrientation];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    /* Pause architect view rendering when this view is not visible anymore */
    [self stopArchitectViewRendering];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Methods

- (void)loadAugmentedRealityExperience:(WTAugmentedRealityExperience *)experience showOnlyBackButton:(BOOL)showBackButtonOnlyInNavigationItem
{
    /* This method could be called at any time so we keep a referenz to the experience object and load it’s architect world once it’s guaranteed that the architect view is loaded from the storyboard */
    self.augmentedRealityExperience = experience;
    
    
    /* Depending from where this view controller was pushed we want to display the back button only or an additional done button. */
    self.showsBackButtonOnlyInNavigationItem = showBackButtonOnlyInNavigationItem;
    
    
    /* A few architect world examples require additional iOS specific implementation details. These details are given in three class extensions.
     * Some example specific code is done once the example should be loaded.
     */
    [self loadExampleSpecificCategoryForAugmentedRealityExperience:experience];
}


#pragma mark - Layout / Rotation

/* Wikitude SDK Rotation handling */
/* Although this method is deprecated in iOS 8 and later it’s still the best place to tell the Wikitude SDK that it should rotate to the new interface orientation */
- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.architectView setShouldRotate:YES toInterfaceOrientation:toInterfaceOrientation];
}


#pragma mark - Delegation
#pragma mark WTArchitectView

/* This architect view delegate method is used to keep the currently loaded architect world url. Every time this view becomes visible again, the controller checks if the current url is not equal to the new one and then loads the architect world */
- (void)architectView:(WTArchitectView *)architectView didFinishLoadArchitectWorldNavigation:(WTNavigation *)navigation
{
    if ( [self.loadingArchitectWorldNavigation isEqual:navigation] )
    {
        self.loadedArchitectWorldNavigation = navigation;
		self.otherAV = architectView;
    }
}

- (void)architectView:(WTArchitectView *)architectView didFailToLoadArchitectWorldNavigation:(WTNavigation *)navigation withError:(NSError *)error
{
    NSLog(@"architect view '%@' \ndid fail to load navigation '%@' \nwith error '%@'", architectView, navigation, error);
}

/* As mentioned before, some architect examples require iOS specific implementation details.
 * Here is the decision made which iOS specific details should be executed
 */
- (void)architectView:(WTArchitectView *)architectView invokedURL:(NSURL *)URL
{
    NSDictionary *parameters = [URL URLParameter];
    if ( parameters )
    {
        if ( [[URL absoluteString] hasPrefix:@"architectsdk://button"] )
        {
            NSString *action = [parameters objectForKey:@"action"];
            if ( [action isEqualToString:@"captureScreen"] )
            {
                [self captureScreen];
            }
        }
        else if ( [[URL absoluteString] hasPrefix:@"architectsdk://markerselected"])
        {
            [self presentPoiDetails:parameters];
        }
    }
}


#pragma mark - Notifications
/* UIApplication specific notifications are used to pause/resume the architect view rendering */
- (void)didReceiveApplicationWillResignActiveNotification:(NSNotification *)notification
{
    [self stopArchitectViewRendering];
}

- (void)didReceiveApplicationDidBecomeActiveNotification:(NSNotification *)notification
{
    [self startArchitectViewRendering];
}


#pragma mark - Private Methods

/* The method that is invoked everytime the view becomes visible again and then decides if a new architect world needs to be loaded or not */
- (void)checkExperienceLoadingStatus
{
    if ( ![self.loadedArchitectWorldNavigation.originalURL isEqual:self.augmentedRealityExperience.URL] )
    {
	self.loadingArchitectWorldNavigation = [self.architectView loadArchitectWorldFromURL:self.augmentedRealityExperience.URL withAugmentedRealityMode:self.augmentedRealityExperience.mode];
    }
}

/* The next two methods actually start/stop architect view rendering */
- (void)startArchitectViewRendering
{
    if ( ![self.architectView isRunning] )
    {
        [self.architectView start];
    }
}

- (void)stopArchitectViewRendering
{
    if ( [self.architectView isRunning] )
    {
        [self.architectView stop];
    }
}

@end
