//
//  OrderStatusTableViewCell.h
//  Ruchiz
//
//  Created by mac on 7/8/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderStatusTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lbl_Distance;

@property (weak, nonatomic) IBOutlet UILabel *lbl_time;
@property (weak, nonatomic) IBOutlet UIImageView *order_img;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Source_name;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Destination_name;
@property (weak, nonatomic) IBOutlet UIImageView *Image_orderstatus;
- (IBAction)btn_suivre:(id)sender;
@property(strong,nonatomic)UINavigationController *navigation;
@property (weak, nonatomic) IBOutlet UIImageView *star_Image;
@property (weak, nonatomic) IBOutlet UILabel *lbl_time1;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Distance1;
@property (weak, nonatomic) IBOutlet UILabel *owner_name;

@end
