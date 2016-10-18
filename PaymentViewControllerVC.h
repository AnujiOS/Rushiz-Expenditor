//
//  PaymentViewController.h
//  Ruchiz
//
//  Created by mac on 7/6/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PayPalConfiguration.h>
#import <PayPalMobile.h>
#import <PayPalPaymentViewController.h>
#import <Stripe.h>
#import "PaymentViewController.h"

//@protocol STPBackendCharging;



@interface PaymentViewControllerVC : UIViewController<PayPalPaymentDelegate>
- (IBAction)promocodebtn_Action:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *promo_code_text;
- (IBAction)promo_cancle:(id)sender;
- (IBAction)paypal_payment:(id)sender;
@property(nonatomic, strong, readwrite) NSString *environment;
@property (weak, nonatomic) IBOutlet UILabel *total_amount_lbl;
- (IBAction)beginCustomPayment:(id)sender;

- (IBAction)beginApple_Pay:(id)sender;

- (IBAction)aBtnCheckedbox:(id)sender;

- (IBAction)menu_action:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *stripe_payment;
@property (weak, nonatomic) IBOutlet UIButton *paypal_payment;
- (IBAction)aBtnValidateClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *Btn_masterCard;
@property (weak, nonatomic) IBOutlet UIButton *Btn_visaCard;
- (IBAction)begin_masterPayment:(id)sender;

@property(nonatomic, strong, readwrite) NSString *resultText;
@end
