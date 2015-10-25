//
//  WTPoiDetailViewController.h
//  SDKExamples
//
//  Created by Andreas Schacherbauer on 8/26/13.
//  Copyright (c) 2013 Wikitude. All rights reserved.
//

#import <UIKit/UIKit.h>



@class WTPoi;


/**
 * WTPoiDetailViewController
 *
 * A very simple view controller to present poi specific information
 */
@interface WTPoiDetailViewController : UITableViewController

@property (nonatomic, strong) WTPoi                   *poi;

@end
