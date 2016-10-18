//
//  AccordionHeaderView.h
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 6/7/15.
//  Copyright (c) 2015 Fuzz Productions, LLC. All rights reserved.
//

#import "FZAccordionTableView.h"
#import <UIKit/UIKit.h>


static const CGFloat kDefaultAccordionHeaderViewHeight = 50.0;
static NSString *const kAccordionHeaderViewReuseIdentifier = @"AccordionHeaderViewReuseIdentifier";

@interface AccordionHeaderView :FZAccordionTableViewHeaderView

@property (weak, nonatomic) IBOutlet UIButton *aOrderAddBtn;
- (IBAction)aBtnOrderAdd:(id)sender;
@property(strong,nonatomic)NSString *flag;
@property(strong,nonatomic)UINavigationController *navigation;
@property (weak, nonatomic) IBOutlet UILabel *number_qty;
@end
