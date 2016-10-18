//
//  PaymentViewController.m
//  Ruchiz
//
//  Created by mac on 7/6/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "PaymentViewControllerVC.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import <PayPalConfiguration.h>
#import "OrderStatusVC.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "PaymentViewController.h"
#import "ShippingManager.h"
#import "PaiementVC.h"
#import <QuartzCore/QuartzCore.h>

#define POST_BODY_BOURDARY  @"boundary"

#define kPayPalEnvironment PayPalEnvironmentSandbox
@interface PaymentViewControllerVC ()<PaymentViewControllerDelegate, PKPaymentAuthorizationViewControllerDelegate,NSURLSessionDelegate>
{
    NSString *token_id;
    NSString *promocode;
    NSMutableArray *cart_contains;
    double TotalCount;
    NSString *cart_id;
    NSString *total_euro;
    NSString *cart_type;
    NSString *last_four;
    NSString *trans_id;
    NSString *te;
    NSString *total_amount;
    NSString *final_total;
    
    
    NSString *promotype;
    NSString *promo_value;
    NSString *promo_id;
     double promo_price;;
    NSData *data;
    NSURLSession *urlSession;
    NSMutableData *receiveData;
    int flag;
    PaiementVC *payment;
    
    NSString *byme;
}
@property(nonatomic, strong, readwrite) PayPalConfiguration *payPalConfig;
@property (nonatomic) BOOL applePaySucceeded;
@property (nonatomic) NSError *applePayError;
@property (nonatomic) ShippingManager *shippingManager;
@property (weak, nonatomic) IBOutlet UIButton *applePayButton;
@end

@implementation PaymentViewControllerVC
- (BOOL)acceptCreditCards
{
    return self.payPalConfig.acceptCreditCards;
}
- (void)setAcceptCreditCards:(BOOL)acceptCreditCards
{
    self.payPalConfig.acceptCreditCards = acceptCreditCards;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    flag = 0;
    payment = [[PaiementVC alloc] init];
    //[self.promo_code_text setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.promo_code_text setValue:[UIColor colorWithRed:225.0/255.0 green:205.0/255.0 blue:106.0/255.0 alpha:1.0] forKeyPath:@"_placeholderLabel.textColor"];
     
    self.paypal_payment.enabled = NO;
    self.Btn_visaCard.enabled = NO;
    self.Btn_masterCard.enabled = NO;
    self.shippingManager = [[ShippingManager alloc] init];
    self.applePayButton.enabled = [self applePayEnabled];
    
    
    
    total_amount = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"total_Amount"];
    
    self.total_amount_lbl.text = total_amount;
    
    [self.promo_code_text setReturnKeyType:UIReturnKeyGo];
    
    [self.promo_code_text addTarget:self action:@selector(txt_promo:) forControlEvents:UIControlEventEditingDidEndOnExit ];
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    // Set up payPalConfig
    _payPalConfig = [[PayPalConfiguration alloc] init];
#if HAS_CARDIO
    // You should use the PayPal-iOS-SDK+card-Sample-App target to enable this setting.
    // For your apps, you will need to link to the libCardIO and dependent libraries. Please read the README.md
    // for more details.
    _payPalConfig.acceptCreditCards = YES;
#else
    
#endif
    _payPalConfig.acceptCreditCards = YES;
    _payPalConfig.merchantName = @"Rushiz";
    _payPalConfig.merchantPrivacyPolicyURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/privacy-full"];
    _payPalConfig.merchantUserAgreementURL = [NSURL URLWithString:@"https://www.paypal.com/webapps/mpp/ua/useragreement-full"];
    
    // Setting the languageOrLocale property is optional.
    //
    // If you do not set languageOrLocale, then the PayPalPaymentViewController will present
    // its user interface according to the device's current language setting.
    //
    // Setting languageOrLocale to a particular language (e.g., @"es" for Spanish) or
    // locale (e.g., @"es_MX" for Mexican Spanish) forces the PayPalPaymentViewController
    // to use that language/locale.
    //
    // For full details, including a list of available languages and locales, see PayPalPaymentViewController.h.
    
    _payPalConfig.languageOrLocale = [NSLocale preferredLanguages][0];
    
    
    // Setting the payPalShippingAddressOption property is optional.
    //
    // See PayPalConfiguration.h for details.
    
    _payPalConfig.payPalShippingAddressOption = PayPalShippingAddressOptionPayPal;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    
    // Do any additional setup after loading the view.
    // use default environment, should be Production in real life
    self.environment = kPayPalEnvironment;
    
    NSLog(@"PayPal iOS SDK version: %@", [PayPalMobile libraryVersion]);
    self.promo_code_text.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;

}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
    
    if (lowercaseCharRange.location != NSNotFound) {
        textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                 withString:[string uppercaseString]];
        return NO;
    }
    
    return YES;
}
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
{
    [self.promo_code_text resignFirstResponder];
   
}
-(BOOL)txt_promo:(id)sender
{
    [self promocodebtn_Action:sender];
    return NO;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    // Preconnect to PayPal early
    [self setPayPalEnvironment:self.environment];
    //[self setPayPalEnvironment:PayPalEnvironmentSandbox];
    
    // [PayPalPaymentViewController setEnvironment:PayPalEnvironmentNoNetwork];
}
- (void)setPayPalEnvironment:(NSString *)environment
{
    self.environment = environment;
    [PayPalMobile preconnectWithEnvironment:environment];
    //[PayPalPaymentViewController setEnvironment:PayPalEnvironmentSandbox];
}
#pragma mark PayPalPaymentDelegate methods

- (void)payPalPaymentViewController:(PayPalPaymentViewController *)paymentViewController didCompletePayment:(PayPalPayment *)completedPayment
{
    NSLog(@"PayPal Payment Success!");
    self.resultText = [completedPayment description];
    //[self showSuccess];
    
    [self sendCompletedPaymentToServer:completedPayment]; // Payment was processed successfully; send to server for verification and fulfillment
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)payPalPaymentDidCancel:(PayPalPaymentViewController *)paymentViewController
{
    NSLog(@"PayPal Payment Canceled");
    self.resultText = nil;
    //self.successView.hidden = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark Proof of payment validation

- (void)sendCompletedPaymentToServer:(PayPalPayment *)completedPayment
{
    // TODO: Send completedPayment.confirmation to server
    NSLog(@"Here is your proof of payment:\n\n%@\n\nSend this to your server for confirmation and fulfillment.", completedPayment.confirmation);
    
    NSDictionary *payment_order = [[NSDictionary alloc]init];
    payment_order = [completedPayment.confirmation valueForKey:@"response"];
    cart_type = @"Visa";
    last_four = @"4444";
    trans_id = [payment_order valueForKey:@"id"];
    if (final_total == nil) {
        te = [NSString stringWithFormat:@"%@",total_amount];
    }
    else{
    te = [NSString stringWithFormat:@"%@",final_total];//total_euro
    }
    [self order_confirm];
    
}
-(void)order_confirm
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if ([[AppDelegate sharedAppDelegate]connected])
        {
            NSString *promo = [NSString stringWithFormat:@"%f",promo_price];
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:cart_type forKey:@"card_type"];
            [dictParam setValue:strUserID forKey:@"id"];
            [dictParam setValue:last_four forKey:@"last_four"];
            [dictParam setValue:trans_id forKey:@"trans_id"];
            [dictParam setValue:te forKey:@"total_euro"];
            [dictParam setValue:promo_id forKey:@"code_id"];
            [dictParam setValue:promocode forKey:@"promo_code"];
            [dictParam setValue:promo_value forKey:@"promo_euro"];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_PAYMENT_ORDER withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Validation Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         OrderStatusVC *back = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderStatusVC"];
                         [self.navigationController pushViewController:back animated:YES];
                     }
                     else
                     {
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }
                 
             }];
        }
        else
        {
            
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)promocodebtn_Action:(id)sender
{
    if([ self.promo_code_text isFirstResponder]){
        [ self.promo_code_text resignFirstResponder];
    }
    
    promocode = [NSString stringWithFormat:@"%@",self.promo_code_text.text];
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if ([[AppDelegate sharedAppDelegate]connected])
        {
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:strUserID forKey:@"id"];
            [dictParam setValue:promocode forKey:@"promo_code"];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_PROMO_CODE withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Delete Order Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         promotype = [NSString stringWithFormat:@"%@",[response valueForKey:@"promo_type"]];
                         promo_value = [NSString stringWithFormat:@"%@",[response valueForKey:@"promo_value"]];
                         promo_id = [NSString stringWithFormat:@"%@",[response valueForKey:@"promo_id"]];
                         
                         if ([promotype isEqualToString:@"1"]) {
                             
                             promo_price = [total_amount intValue]*[promo_value intValue] /100;
                             final_total = [NSString stringWithFormat:@"%.2f%@",[total_amount doubleValue]-promo_price,@"\u20ac" ];
                             self.total_amount_lbl.text = final_total;
                         }
                         if ([promotype isEqualToString:@"2"]) {
                             promo_price = [total_amount intValue]-[promo_value intValue];
                            final_total = [NSString stringWithFormat:@"%.2f%@",promo_price,@"\u20ac"];
                             
                             self.total_amount_lbl.text = final_total;
                         }
                        
                         self.promo_code_text.text = @"";
                         
                
                     }
                     else
                     {
                         
                         
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }
                 
             }];
        }
        else
        {
            
                   }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    
}
- (IBAction)promo_cancle:(id)sender
{
    self.promo_code_text.text =@"";
    
    if([ self.promo_code_text isFirstResponder])
    {
        [ self.promo_code_text resignFirstResponder];
    }
}

- (IBAction)paypal_payment:(id)sender
{
    //if ([sender isSelected]) {
       // [sender setTitle:@"" forState:UIControlStateNormal];
          //  [self.paypal_payment setBackgroundColor:[UIColor redColor]];
        //[[self.paypal_payment.layer setBorderColor:[UIColor blackColor] ] ];
        [self.paypal_payment.layer setBorderColor:[[UIColor clearColor]CGColor]];
        [[self.paypal_payment layer] setBorderWidth:3.0f];
        [self.Btn_visaCard.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [[self.Btn_visaCard layer] setBorderWidth:3.0f];
        [self.Btn_masterCard.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [[self.Btn_masterCard layer] setBorderWidth:3.0f];
        
        //self.paypal_payment.alpha = 0.5;
        //self.stripe_payment.alpha = 1.0;
     //   [self.stripe_payment setBackgroundColor:nil];

        flag = 1;
       // [sender setSelected:NO];
   // }
   // else
   // {
//       [sender setTitle:@"" forState:UIControlStateSelected];
//        [self.paypal_payment.layer setBorderColor:[[UIColor blackColor]CGColor]];
//        [[self.paypal_payment layer] setBorderWidth:3.0f];
//
//       //  [self.paypal_payment setBackgroundColor:nil];
//        //self.paypal_payment.alpha = 1.0;
//        flag = 0;
//       [sender setSelected:YES];
//        
//    }

    
    
}
- (IBAction)beginCustomPayment:(id)sender
{
    //if ([sender isSelected]) {
        //[sender setTitle:@"" forState:UIControlStateNormal];
        
       // [self.stripe_payment setBackgroundColor:[UIColor redColor]];
//        self.stripe_payment.alpha = 0.5;
//        self.paypal_payment.alpha = 1.0;
       // [self.paypal_payment setBackgroundColor:nil];
        
        [self.Btn_visaCard.layer setBorderColor:[[UIColor clearColor]CGColor]];
        [[self.Btn_visaCard layer] setBorderWidth:3.0f];
        [self.Btn_masterCard.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [[self.Btn_masterCard layer] setBorderWidth:3.0f];
        [self.paypal_payment.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [[self.paypal_payment layer] setBorderWidth:3.0f];

        flag = 2;
       // [sender setSelected:NO];
   // }
   // else
  //  {
//        [sender setTitle:@"" forState:UIControlStateSelected];
//        [self.Btn_visaCard.layer setBorderColor:[[UIColor blackColor]CGColor]];
//        [[self.Btn_visaCard layer] setBorderWidth:3.0f];
//      // [self.stripe_payment setBackgroundColor:nil];
//       // self.stripe_payment.alpha = 1.0;
//        flag = 0;
//        [sender setSelected:YES];
    
   // }

    
}
- (IBAction)begin_masterPayment:(id)sender
{
   // if ([sender isSelected]) {
     //   [sender setTitle:@"" forState:UIControlStateNormal];
        
        // [self.stripe_payment setBackgroundColor:[UIColor redColor]];
        //        self.stripe_payment.alpha = 0.5;
        //        self.paypal_payment.alpha = 1.0;
        // [self.paypal_payment setBackgroundColor:nil];

        [self.Btn_masterCard.layer setBorderColor:[[UIColor clearColor]CGColor]];
        [[self.Btn_masterCard layer] setBorderWidth:3.0f];
        [self.paypal_payment.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [[self.paypal_payment layer] setBorderWidth:3.0f];
        [self.Btn_visaCard.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [[self.Btn_visaCard layer] setBorderWidth:3.0f];

        
        flag = 3;
       // [sender setSelected:NO];
   // }
   // else
   // {
//        [sender setTitle:@"" forState:UIControlStateSelected];
//        [self.Btn_masterCard.layer setBorderColor:[[UIColor blackColor]CGColor]];
//        [[self.Btn_masterCard layer] setBorderWidth:3.0f];
//        
//        // [self.stripe_payment setBackgroundColor:nil];
//        // self.stripe_payment.alpha = 1.0;
//        flag = 0;
//        [sender setSelected:YES];
    
    //}
    
    
}


- (IBAction)beginApple_Pay:(id)sender
{
        self.applePaySucceeded = NO;
        self.applePayError = nil;
        NSString *merchantId = AppleMerchantId;
        PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:merchantId];
        if ([Stripe canSubmitPaymentRequest:paymentRequest]) {
            [paymentRequest setRequiredShippingAddressFields:PKAddressFieldPostalAddress];
            [paymentRequest setRequiredBillingAddressFields:PKAddressFieldPostalAddress];
            paymentRequest.shippingMethods = [self.shippingManager defaultShippingMethods];
            paymentRequest.paymentSummaryItems = [self summaryItemsForShippingMethod:paymentRequest.shippingMethods.firstObject];
            PKPaymentAuthorizationViewController *auth = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:paymentRequest];
            auth.delegate = self;
            if (auth) {
                [self presentViewController:auth animated:YES completion:nil];
            } else {
                NSLog(@"Apple Pay returned a nil PKPaymentAuthorizationViewController - make sure you've configured Apple Pay correctly, as outlined at https://stripe.com/docs/mobile/apple-pay");
            }
        }

}

- (IBAction)aBtnCheckedbox:(id)sender
{
    UIImage *unselectedImage = [UIImage imageNamed:@"ios_uncheck.png"];
    UIImage *selectedImage = [UIImage imageNamed:@"ios_check.png"];
    if ([sender isSelected]) {
        [sender setImage:selectedImage forState:UIControlStateNormal];
    
        self.paypal_payment.enabled = YES;
        self.Btn_visaCard.enabled = YES;
        self.Btn_masterCard.enabled = YES;
        
        [self.paypal_payment.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [[self.paypal_payment layer] setBorderWidth:3.0f];
        
        [self.Btn_visaCard.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [[self.Btn_visaCard layer] setBorderWidth:3.0f];
        
        [self.Btn_masterCard.layer setBorderColor:[[UIColor blackColor]CGColor]];
        [[self.Btn_masterCard layer] setBorderWidth:3.0f];
       // self.stripe_payment.enabled = YES;

        [sender setSelected:NO];
    } else {
        [sender setImage:unselectedImage forState:UIControlStateSelected];
        self.paypal_payment.enabled = NO;
        self.Btn_visaCard.enabled = NO;
        self.Btn_masterCard.enabled = NO;
        //self.stripe_payment.enabled = NO;
        
        
        [self.paypal_payment.layer setBorderColor:[[UIColor clearColor]CGColor]];
        [[self.paypal_payment layer] setBorderWidth:3.0f];
        
        [self.Btn_visaCard.layer setBorderColor:[[UIColor clearColor]CGColor]];
        [[self.Btn_visaCard layer] setBorderWidth:3.0f];
        
        [self.Btn_masterCard.layer setBorderColor:[[UIColor clearColor]CGColor]];
        [[self.Btn_masterCard layer] setBorderWidth:3.0f];
        [sender setSelected:YES];
        
    }
}

- (void)paymentViewController:(PaymentViewController *)controller didFinish:(NSError *)error
{
        [self dismissViewControllerAnimated:YES completion:^
         {
            if (error)
            {
                [self presentError:error];
            } else
            {
                [self order_confirm_strip];
                [self paymentSucceeded];
                OrderStatusVC *back = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderStatusVC"];
                [self.navigationController pushViewController:back animated:YES];
            }
        }];
}

- (IBAction)menu_action:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)presentError:(NSError *)error
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:nil message:[error localizedDescription] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
    [self presentViewController:controller animated:YES completion:nil];
}

- (void)paymentSucceeded
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Success" message:@"Payment successfully created!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
}
#pragma mark - Apple Pay

- (BOOL)applePayEnabled
{
    if ([PKPaymentRequest class]) {
        PKPaymentRequest *paymentRequest = [Stripe paymentRequestWithMerchantIdentifier:AppleMerchantId];
        return [Stripe canSubmitPaymentRequest:paymentRequest];
    }
    return NO;
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingAddress:(ABRecordRef)address completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKShippingMethod *> * _Nonnull, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
    [self.shippingManager fetchShippingCostsForAddress:address
                                            completion:^(NSArray *shippingMethods, NSError *error)
    {
        if (error)
        {
            completion(PKPaymentAuthorizationStatusFailure, @[], @[]);
            return;
        }
        completion(PKPaymentAuthorizationStatusSuccess,
                   shippingMethods,
                   [self summaryItemsForShippingMethod:shippingMethods.firstObject]);
    }];
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didSelectShippingMethod:(PKShippingMethod *)shippingMethod completion:(void (^)(PKPaymentAuthorizationStatus, NSArray<PKPaymentSummaryItem *> * _Nonnull))completion
{
    completion(PKPaymentAuthorizationStatusSuccess, [self summaryItemsForShippingMethod:shippingMethod]);
}

- (NSArray *)summaryItemsForShippingMethod:(PKShippingMethod *)shippingMethod
{
    PKPaymentSummaryItem *shirtItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Cool Shirt" amount:[NSDecimalNumber decimalNumberWithString:@"10.00"]];
    NSDecimalNumber *total = [shirtItem.amount decimalNumberByAdding:shippingMethod.amount];
    PKPaymentSummaryItem *totalItem = [PKPaymentSummaryItem summaryItemWithLabel:@"Stripe Shirt Shop" amount:total];
    return @[shirtItem, shippingMethod, totalItem];
}

//- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller                       didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
//{
//    [[STPAPIClient sharedClient] createTokenWithPayment:payment
//                                             completion:^(STPToken *token, NSError *error)
//    {
//        [self createBackendChargeWithToken:token completion:^(STPBackendChargeResult status, NSError *error)
//        {
//            if (status == STPBackendChargeResultSuccess)
//            {
//                self.applePaySucceeded = YES;
//                completion(PKPaymentAuthorizationStatusSuccess);
//            }
//            else
//            {
//                self.applePayError = error;
//                completion(PKPaymentAuthorizationStatusFailure);
//            }
//        }];
//        
//    }];
//}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:^
    {
        if (self.applePaySucceeded)
        {
            [self paymentSucceeded];
        }
        else if (self.applePayError)
        {
            [self presentError:self.applePayError];
        }
        self.applePaySucceeded = NO;
        self.applePayError = nil;
    }];
}


//#pragma mark - STPBackendCharging
//
//- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion
//{
//    if (!BackendChargeURLString)
//    {
//        NSError *error = [NSError errorWithDomain:StripeDomain code:STPInvalidRequestError userInfo:@
//        {
//        NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Good news! Stripe turned your credit card into a token: %@ \nYou can follow the "@"instructions in the README to set up an example backend, or use this "@"token to manually create charges at dashboard.stripe.com .",token.tokenId]
//        }];
//        completion(STPBackendChargeResultFailure, error);
//        return;
//    }
//    
//    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
//    NSString *urlString = [BackendChargeURLString stringByAppendingPathComponent:@"charge"];
//    NSURL *url = [NSURL URLWithString:urlString];
//    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
//    request.HTTPMethod = @"POST";
//    NSString *postBody = [NSString stringWithFormat:@"stripeToken=%@&amount=%@", token.tokenId, @1000];
//    token_id = [NSString stringWithFormat:@"%@",token.tokenId];
//    data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *newStr1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//    NSLog(@"Data %@",newStr1);
//    NSDictionary *allDataDictionary=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSLog(@"DATA: %@",allDataDictionary);
//    
//    
//    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
//    {
//        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
//        if (!error && httpResponse.statusCode != 200)
//        {
//            error = [NSError errorWithDomain:StripeDomain code:STPInvalidRequestError userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
//        }
//        if (error)
//        {
//            completion(STPBackendChargeResultFailure, error);
//        }
//        else
//        {
//            completion(STPBackendChargeResultSuccess, nil);
//            NSLog(@"Response : %@",response);
//            NSDictionary *allDataDictionary=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//            NSLog(@"DATA: %@",allDataDictionary);
//        }
//    }];
//    
//    [uploadTask resume];
//}
//

-(void)order_confirm_strip
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if ([[AppDelegate sharedAppDelegate]connected])
        {
            NSString *promo = [NSString stringWithFormat:@"%f",promo_price];
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            last_four = @"4242";
            cart_type = @"VISA";
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:cart_type forKey:@"card_type"];
            [dictParam setValue:strUserID forKey:@"id"];
            [dictParam setValue:last_four forKey:@"last_four"];
            [dictParam setValue:token_id forKey:@"trans_id"];
            if (final_total == nil)
            {
                [dictParam setValue:total_amount forKey:@"total_euro"];
            }
            else
            {
                [dictParam setValue:final_total forKey:@"total_euro"];
            }
            [dictParam setValue:promo_id forKey:@"code_id"];
            [dictParam setValue:promocode forKey:@"promo_code"];
            [dictParam setValue:promo_value forKey:@"promo_euro"];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_PAYMENT_ORDER withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Validation Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         OrderStatusVC *back = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderStatusVC"];
                         [self.navigationController pushViewController:back animated:YES];

                     }
                     else
                     {
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }
                 
             }];
        }
        else
        {
        
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    
}


- (IBAction)aBtnValidateClicked:(id)sender
{
    if (flag == 1) {
        // Remove our last completed payment, just for demo purposes.
        self.resultText = nil;
        
        PayPalItem *item1 = [PayPalItem itemWithName:@"Old jeans with holes"
                                        withQuantity:2
                                           withPrice:[NSDecimalNumber decimalNumberWithString:@"84.99"]
                                        withCurrency:@"USD"
                                             withSku:@"Hip-00037"];
        PayPalItem *item2 = [PayPalItem itemWithName:@"Free rainbow patch"
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:@"0.00"]
                                        withCurrency:@"USD"
                                             withSku:@"Hip-00066"];
        PayPalItem *item3 = [PayPalItem itemWithName:@"Long-sleeve plaid shirt (mustache not included)"
                                        withQuantity:1
                                           withPrice:[NSDecimalNumber decimalNumberWithString:@"37.99"]
                                        withCurrency:@"USD"
                                             withSku:@"Hip-00291"];
        NSArray *items = @[item1, item2, item3];
        NSDecimalNumber *subtotal = [PayPalItem totalPriceForItems:items];
        
        // Optional: include payment details
        NSDecimalNumber *shipping = [[NSDecimalNumber alloc] initWithString:@"0.00"];//5.99
        NSDecimalNumber *tax = [[NSDecimalNumber alloc] initWithString:@"0.00"];//2.50
        //    PayPalPaymentDetails *paymentDetails = [PayPalPaymentDetails paymentDetailsWithSubtotal:subtotal
        //                                                                               withShipping:shipping
        //                                                                                    withTax:tax];
        //
        // NSDecimalNumber *total = [[subtotal decimalNumberByAdding:shipping] decimalNumberByAdding:tax];
        
        PayPalPayment *payment_paypal = [[PayPalPayment alloc] init];
        if (final_total == nil) {
            NSDecimalNumber *cow = [NSDecimalNumber decimalNumberWithString:total_amount];//total_euro
            payment_paypal.amount = cow;
            payment_paypal.currencyCode = @"EUR";
            payment_paypal.shortDescription = @"Rushiz";
            payment_paypal.items = nil;//items;  // if not including multiple items, then leave payment.items as nil
            payment_paypal.paymentDetails = nil;//paymentDetails; // if not including payment details, then leave
        }
        else{
            NSDecimalNumber *cow = [NSDecimalNumber decimalNumberWithString:final_total];//total_euro
            payment_paypal.amount = cow;
            payment_paypal.currencyCode = @"EUR";
            payment_paypal.shortDescription = @"Rushiz";
            payment_paypal.items = nil;//items;  // if not including multiple items, then leave payment.items as nil
            payment_paypal.paymentDetails = nil;//paymentDetails; // if not including payment details, then leave
        }
        
        //        NSDecimalNumber *cow = [NSDecimalNumber decimalNumberWithString:final_total];//total_euro
        //        payment.amount = cow;
        //        payment.currencyCode = @"EUR";
        //        payment.shortDescription = @"Rushiz";
        //        payment.items = nil;//items;  // if not including multiple items, then leave payment.items as nil
        //        payment.paymentDetails = nil;//paymentDetails; // if not including payment details, then leave payment.paymentDetails as nil
        
        if (!payment_paypal.processable) {
            // This particular payment will always be processable. If, for
            // example, the amount was negative or the shortDescription was
            // empty, this payment wouldn't be processable, and you'd want
            // to handle that here.
        }
        
        // Update payPalConfig re accepting credit cards.
        self.payPalConfig.acceptCreditCards = self.acceptCreditCards;
        
        PayPalPaymentViewController *paymentViewController = [[PayPalPaymentViewController alloc] initWithPayment:payment_paypal                                                                           configuration:self.payPalConfig                                                                                                    delegate:self];
        [self presentViewController:paymentViewController animated:YES completion:nil];

    }
    else if (flag == 2)
    {
//#pragma mark - Custom Credit Card Form
//        PaymentViewController *paymentViewController = [[PaymentViewController alloc] initWithNibName:nil bundle:nil];
//        //paymentViewController.amount = [NSDecimalNumber decimalNumberWithString:@"10.00"];
        
        if (final_total == nil)
        {
//            payment.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",total_amount]];
             byme = [NSString stringWithFormat:@"%@",total_amount];
        }
        else
        {
            //payment.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",final_total]];
            byme = [NSString stringWithFormat:@"%@",final_total];
        }
        
        //payment.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",total_amount]];
       // payment.backendCharger = self;
//        payment.delegate = self;
//        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:paymentViewController];
//        [self presentViewController:navController animated:YES completion:nil];
//        STPAddCardViewController *addCardViewController = [[STPAddCardViewController alloc] init];
//        addCardViewController.delegate = self;
//        // STPAddCardViewController must be shown inside a UINavigationController.
//        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCardViewController];
//        [self presentViewController:navigationController animated:YES completion:nil];
//
        payment = [self.storyboard instantiateViewControllerWithIdentifier:@"PaiementVC"];
        payment.CardType = @"Visa";
        payment.str_amount =byme;
        [self.navigationController pushViewController:payment animated:NO];
        
   
    }
    else if (flag == 3)
    {
        if (final_total == nil)
        {
           byme = [NSString stringWithFormat:@"%@",total_amount];
        }
        else
        {
            byme = [NSString stringWithFormat:@"%@",final_total];

        }
       // payment.amount = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",total_amount]];
       // payment.backendCharger = self;
        payment = [self.storyboard instantiateViewControllerWithIdentifier:@"PaiementVC"];
        payment.str_amount =byme;
        payment.CardType = @"MasterCard";
        [self.navigationController pushViewController:payment animated:NO];

    }
    else if(flag == 0)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"S'il vous plaît Sélectionnez le mode de paiement" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];
    }
}
#pragma mark STPAddCardViewControllerDelegate


- (void)addCardViewControllerDidCancel:(STPAddCardViewController *)addCardViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)addCardViewController:(STPAddCardViewController *)addCardViewController
               didCreateToken:(STPToken *)token
                   completion:(STPErrorBlock)completion {
    
    
//    [self submitTokenToBackend:token completion:^(NSError *error) {
//        if (error) {
//            completion(error);
//        } else {
//            [self dismissViewControllerAnimated:YES completion:^{
//                [self showReceiptPage];
//            }];
//        }
//    }];
}







@end
