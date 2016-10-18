//
//  NotationVC.h
//  Ruchiz
//
//  Created by mac on 9/26/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RateView.h"

@interface NotationVC : UIViewController<RateViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *Img_Deliveryboy_image;
@property (weak, nonatomic) IBOutlet UILabel *Lbl_DeliveryBoy_name;
@property (weak, nonatomic) IBOutlet UITextView *TextView_commentaires;

- (IBAction)Btn_Validate:(id)sender;
- (IBAction)Btn_Backmenu:(id)sender;
@property (weak, nonatomic) IBOutlet RateView *rateView;







@end
