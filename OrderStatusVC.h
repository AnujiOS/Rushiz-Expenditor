//
//  OrderStatusVC.h
//  Ruchiz
//
//  Created by mac on 7/8/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"

@interface OrderStatusVC : UIViewController<UIScrollViewDelegate,UITableViewDelegate,UIGestureRecognizerDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

- (IBAction)menu_btn:(id)sender;

@end
