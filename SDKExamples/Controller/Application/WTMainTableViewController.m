//
//  ViewController.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 22/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTMainTableViewController.h"

#import "WTCoreServices.h"
#import "UIDevice+SystemVersion.h"

#import "WTAugmentedRealityExperience.h"
#import "WTAugmentedRealityExperiencesManager.h"
#import "WTAugmentedRealityExperiencesManager+ExampleSections.h"

#import "WTManageURLsViewController.h"
#import "WTAugmentedRealityViewController.h"



static NSString *kWTCellIdentifier_ExampleCell = @"kWTCellIdentifier_ExampleCell";


@interface WTMainTableViewController ()
@property (nonatomic, strong) WTAugmentedRealityExperiencesManager                  *augmentedRealityExperiencesManager;
@end

@implementation WTMainTableViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        _augmentedRealityExperiencesManager = [[WTAugmentedRealityExperiencesManager alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if ( ![self.augmentedRealityExperiencesManager hasLoadedAugmentedRealityExperiencesFromPlist] )
    {
        [self.augmentedRealityExperiencesManager loadAugmentedRealityExperiencesFromPlist:^
        {
             [self.tableView insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 7)] withRowAnimation:UITableViewRowAnimationFade];
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Public Methods

- (IBAction)shouldGoBackToMainViewControllerFromURLsManagement:(UIStoryboardSegue *)segue
{
    /* iOS 8 workaround */
    if ( [UIDevice isRunningiOS:kWTiOSVersion_8] )
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ( [[segue destinationViewController] isKindOfClass:[WTAugmentedRealityViewController class]] )
    {
        WTAugmentedRealityViewController *augmentedRealityViewController = (WTAugmentedRealityViewController *)segue.destinationViewController;
     
        if ( [sender isKindOfClass:[UITableViewCell class]] )
        {
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            WTAugmentedRealityExperience *experience = [self.augmentedRealityExperiencesManager augmentedRealityExperienceForIndexPath:indexPath];
            [augmentedRealityViewController loadAugmentedRealityExperience:experience showOnlyBackButton:YES];
        }
    }
}


#pragma mark - Delegation
#pragma mark UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.augmentedRealityExperiencesManager numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.augmentedRealityExperiencesManager numberOfExperiencesInSection:section];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.augmentedRealityExperiencesManager exampleGroupTitleForSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kWTCellIdentifier_ExampleCell];
    
    WTAugmentedRealityExperience *exampleExperience = [self.augmentedRealityExperiencesManager augmentedRealityExperienceForIndexPath:indexPath];
    
    cell.textLabel.text = exampleExperience.title;    
    
    return cell;
}

@end
