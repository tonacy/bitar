//
//  WTCreateURLViewController.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTCreateURLViewController.h"

#import "WTCoreServices.h"
#import "WTAugmentedRealityExperience.h"



NSString * const kWTSegueIdentifier_CancelURLCreation = @"WTSegueIdentifier_CancelURLCreation";
NSString * const kWTSegueIdentifier_SaveURL = @"WTSegueIdentifier_SaveURL";


@interface WTCreateURLViewController ()

@property (nonatomic, assign) BOOL                                  prepareUIForURLCreation;
@property (nonatomic, strong) WTAugmentedRealityExperience          *augmentedRealityExperience;

@end

@implementation WTCreateURLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.urlTextField.inputAccessoryView = [self shortURLAccessoryView];
    
    [self.urlTextField addTarget:self.titleTextField action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
    [self.titleTextField addTarget:self.urlTextField action:@selector(becomeFirstResponder) forControlEvents:UIControlEventEditingDidEndOnExit];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ( _prepareUIForURLCreation )
    {
        [self.urlTextField becomeFirstResponder];
        _prepareUIForURLCreation = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Public Methods

- (void)prepareForURLCreation
{
    self.prepareUIForURLCreation = YES;
}

- (WTAugmentedRealityExperience *)createdAugmentedRealityExperience
{
    return _augmentedRealityExperience;
}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    BOOL canPerformSegueWithIdentifier = YES;

    if ( [identifier isEqualToString:kWTSegueIdentifier_SaveURL] )
    {
        WTAugmentedRealityExperience *experience = [self experienceFromCurrentInput];
        if ( nil == experience )
        {
            canPerformSegueWithIdentifier = NO;
            self.state = WTURLCreationState_Error;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid information" message:@"Please verify the URL" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
    
    return canPerformSegueWithIdentifier;
}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ( [segue.identifier isEqualToString:kWTSegueIdentifier_SaveURL] )
    {
        self.augmentedRealityExperience = [self experienceFromCurrentInput];
        self.state = self.augmentedRealityExperience != nil ? WTURLCreationState_Success : WTURLCreationState_Error;
    }
    else if ( [segue.identifier isEqualToString:kWTSegueIdentifier_CancelURLCreation] )
    {
        self.augmentedRealityExperience = nil;
        self.state = WTURLCreationState_Canceled;
    }
}


#pragma mark - Private Methods

- (WTAugmentedRealityExperience *)experienceFromCurrentInput
{
    NSString *title = self.titleTextField.text;
    NSURL *URL = [NSURL URLWithString:self.urlTextField.text];
    WTAugmentedRealityMode mode = self.arModeSwitch.on ? WTAugmentedRealityMode_ImageRecognition : WTAugmentedRealityMode_Geo;
    
    return [WTAugmentedRealityExperience experienceWithTitle:title groupTitle:[URL host] URL:URL mode:mode];
}

#pragma mark Short URL handling

- (UIView *)shortURLAccessoryView
{
    UIView *inputAccessoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40)];
    inputAccessoryView.backgroundColor = [UIColor recentURLsInputAccessoryViewColor];
    
    UIButton *googleButton = [[UIButton alloc] init];
    googleButton.translatesAutoresizingMaskIntoConstraints = NO;
    [googleButton setTitleColor:[UIColor wikitudeColor] forState:UIControlStateNormal];
    [googleButton setTitle:@"goo.gl" forState:UIControlStateNormal];
    [googleButton addTarget:self action:@selector(preFillWithGoogleShortURL) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *tinyURLButton = [[UIButton alloc] init];
    tinyURLButton.translatesAutoresizingMaskIntoConstraints = NO;
    [tinyURLButton setTitleColor:[UIColor wikitudeColor] forState:UIControlStateNormal];
    [tinyURLButton setTitle:@"tinyurl" forState:UIControlStateNormal];
    [tinyURLButton addTarget:self action:@selector(preFillWithTinyURL) forControlEvents:UIControlEventTouchUpInside];
    
    [inputAccessoryView addSubview:googleButton];
    [inputAccessoryView addSubview:tinyURLButton];
    
    NSDictionary *metrics = @{@"buttonHeight": @30.0};
    NSDictionary *views = NSDictionaryOfVariableBindings(googleButton, tinyURLButton);
    NSString *visualFormat = @"|-[googleButton(tinyURLButton)]-[tinyURLButton]-|";
    
    [inputAccessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:visualFormat options:NSLayoutFormatAlignAllBaseline metrics:metrics views:views]];
    [inputAccessoryView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[googleButton]|" options:NSLayoutFormatAlignAllCenterY metrics:metrics views:views]];
    
    return inputAccessoryView;
}

- (void)preFillWithGoogleShortURL
{
    [self preFillWithPrefix:@"http://goo.gl/"];
}

- (void)preFillWithTinyURL
{
    [self preFillWithPrefix:@"http://tinyurl.com/"];
}

- (void)preFillWithPrefix:(NSString *)prefix
{
    self.urlTextField.text = prefix;
}

@end
