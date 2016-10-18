//
//  Order_CartTableViewCell.h
//  Ruchiz
//
//  Created by ganesh on 6/8/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Order_CartTableViewCell : UITableViewCell
{
    
}
@property (weak, nonatomic) IBOutlet UIImageView *article_img;

@property (weak, nonatomic) IBOutlet UILabel *distance;
@property (weak, nonatomic) IBOutlet UILabel *estimate_time;
@property (weak, nonatomic) IBOutlet UILabel *article_type;
@property (weak, nonatomic) IBOutlet UILabel *article_price;
@property (weak, nonatomic) IBOutlet UILabel *price_type;
- (IBAction)aBtn_packinfo:(id)sender;
@property(strong,nonatomic)UINavigationController *navigation;
@property (weak, nonatomic) IBOutlet UIButton *aBtn_packdetails;
@property (weak, nonatomic) IBOutlet UIButton *aBtn_deletepack;
@property (weak, nonatomic) IBOutlet UIButton *ABtn_Orderedit;

@end
