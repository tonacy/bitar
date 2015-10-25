//
//  WTManageURLsViewController.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 23/09/14.
//  Copyright (c) 2014 Wikitude. All rights reserved.
//

#import "WTManageURLsViewController.h"

#import "WTAugmentedRealityExperience.h"
#import "WTAugmentedRealityExperiencesManager.h"
#import "WTAugmentedRealityExperiencesManager+HostSections.h"

#import "WTCreateURLViewController.h"
#import "WTAugmentedRealityViewController.h"



static NSString * kWTCellIdentifier_RecentURLCell = @"kWTCellIdentifier_RecentURLCell";

NSString * const kWTSegueIdentifier_CloseURLManagement = @"WTSegueIdentifier_CloseURLManagement";
NSString * const kWTSegueIdentifier_PresentURL_CompactSize = @"kWTSegueIdentifier_PresentURL_CompactSize";
NSString * const kWTSegueIdentifier_PresentURL_RegularSize = @"kWTSegueIdentifier_PresentURL_RegularSize";


@interface WTManageURLsViewController ()
@property (nonatomic, strong) WTAugmentedRealityExperiencesManager              *augmentedRealityExperiencesManager;
@end

@implementation WTManageURLsViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _augmentedRealityExperiencesManager = [[WTAugmentedRealityExperiencesManager alloc] initWithHostSetup];        
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.augmentedRealityExperiencesManager numberOfSections];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.augmentedRealityExperiencesManager hostForSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.augmentedRealityExperiencesManager numberOfExperiencesInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WTAugmentedRealityExperience *experience = [self.augmentedRealityExperiencesManager augmentedRealityExperienceForIndexPath:indexPath];
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:kWTCellIdentifier_RecentURLCell];
    
    cell.textLabel.text = [experience.URL absoluteString];
    cell.detailTextLabel.text = experience.title;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *segueIdentifier = kWTSegueIdentifier_PresentURL_CompactSize;
    UITableViewCell *senderCell = [tableView cellForRowAtIndexPath:indexPath];
    
    if ( NSClassFromString(@"UITraitCollection") )
    {
        if ( self.traitCollection.userInterfaceIdiom == UIUserInterfaceIdiomPad )
        {
            segueIdentifier = kWTSegueIdentifier_PresentURL_RegularSize;
        }
    }
    else
    {
        if ( UIUserInterfaceIdiomPad == [[UIDevice currentDevice] userInterfaceIdiom] )
        {
            segueIdentifier = kWTSegueIdentifier_PresentURL_RegularSize;
        }
    }
    
    [self performSegueWithIdentifier:segueIdentifier sender:senderCell];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL removedSection = [self.augmentedRealityExperiencesManager removeAugmentedRealityExperienceAtIndexPath:indexPath];
    
    if (removedSection)
    {
        [self.augmentedRealityExperiencesManager removeHostForSection:indexPath.section];
        [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    else
    {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }
    
    [self.augmentedRealityExperiencesManager saveAugmentedRealityExperiencesToDisk];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ( [[segue destinationViewController] isKindOfClass:[UINavigationController class]] )
    {
        UINavigationController *navigationController = (UINavigationController *)segue.destinationViewController;
        UIViewController *topViewController = navigationController.topViewController;
        if ( [topViewController isKindOfClass:[WTCreateURLViewController class]] )
        {
            WTCreateURLViewController *urlCreationViewController = (WTCreateURLViewController *)navigationController.topViewController;
            [urlCreationViewController prepareForURLCreation];
        }
        else if ( [topViewController isKindOfClass:[WTAugmentedRealityViewController class]] )
        {
            UITableViewCell *cell = (UITableViewCell *)sender;
            NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
            WTAugmentedRealityExperience *experience = [self.augmentedRealityExperiencesManager augmentedRealityExperienceForIndexPath:indexPath];
            WTAugmentedRealityViewController *augmentedRealityViewController = (WTAugmentedRealityViewController *)topViewController;
            [augmentedRealityViewController loadAugmentedRealityExperience:experience showOnlyBackButton:NO];
        }
    }
    else if ( [[segue destinationViewController] isKindOfClass:[WTAugmentedRealityViewController class]] )
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


- (IBAction)shouldGoBackToURLManagement:(UIStoryboardSegue *)segue
{
    if ( [segue.sourceViewController isKindOfClass:[WTCreateURLViewController class]] )
    {
        WTCreateURLViewController *urlCreationViewController = (WTCreateURLViewController *)segue.sourceViewController;
        
        if ( WTURLCreationState_Success == urlCreationViewController.state )
        {
            WTAugmentedRealityExperience *experience = [urlCreationViewController createdAugmentedRealityExperience];
            NSInteger section = [self.augmentedRealityExperiencesManager sectionForHost:experience.URL.host];
            if ( section >= 0 )
            {
                BOOL newSectionAdded = [self.augmentedRealityExperiencesManager addAugmentedRealityExperience:experience inSection:section moveToTop:YES];
                
                if (newSectionAdded)
                {
                    [self.tableView insertSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationTop];
                }
                else
                {
                    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:section]] withRowAnimation:UITableViewRowAnimationTop];
                }
                
                [self.augmentedRealityExperiencesManager saveAugmentedRealityExperiencesToDisk];
            }
            else
            {
                NSLog(@"Unable to add experience '%@' for host '%@'.", experience, experience.URL.host);
            }
        }
        else if ( WTURLCreationState_Canceled == urlCreationViewController.state )
        {
            NSLog(@"url creation cancelled");
        }
    }
}

@end
