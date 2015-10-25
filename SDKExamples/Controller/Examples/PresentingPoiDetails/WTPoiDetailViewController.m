//
//  WTPoiDetailViewController.m
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 8/26/13.
//  Copyright (c) 2013 Wikitude. All rights reserved.
//

#import "WTPoiDetailViewController.h"

#import "WTPoi.h"



static NSString * kWTCellIdentifier_PoiDetailCell = @"kWTCellIdentifier_PoiDetailCell";


@interface WTPoiDetailViewController ()

@end

@implementation WTPoiDetailViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationItem.title = self.poi.name;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"Details for Poi #%ld", (long)self.poi.identifier];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kWTCellIdentifier_PoiDetailCell];
    
    NSString *informationTitle, *information;
    
    
    switch (indexPath.row)
    {
        case 0:
            informationTitle = @"Name:";
            information = self.poi.name;
        break;
        
        case 1:
            informationTitle = @"Description:";
            information = self.poi.detailedDescription;
        break;
            
        default:
            break;
    }
    
    cell.textLabel.text = informationTitle;
    cell.detailTextLabel.text = information;
    
    return cell;
}

@end
