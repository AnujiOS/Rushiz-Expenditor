//
//  AjouterPaymentVC.m
//  Ruchiz
//
//  Created by mac on 9/5/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "AjouterPaymentVC.h"
#import "CommandPageViewController.h"
#import "PaiementVC.h"
#import "MFSideMenu.h"
#import <Stripe.h>
#import "CreditCard-Validator.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "PaiementVC.h"
#import "CardIOPaymentViewControllerDelegate.h"
#import "CardIO.h"


#import "STPImageLibrary.h"
#define kVISA_TYPE          @"^4[0-9]{3}?"
#define kMASTER_CARD_TYPE   @"^5[1-5][0-9]{2}$"

@interface AjouterPaymentVC ()<UITextFieldDelegate,STPPaymentCardTextFieldDelegate,CardIOPaymentViewControllerDelegate>
{
    
    NSRegularExpression *regex;
    NSError *error;
    NSString *expMonth;
    NSString *expYear;
    NSString *temp_selectedmonth;
    NSString *temp_selctedyear;
}
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (strong, nonatomic) STPCardParams* stripeCard;
@property (weak, nonatomic) STPPaymentCardTextField *paymentTextField;
@property(nonatomic, strong, readwrite) NSString *txt_cc_type;

@end

@implementation AjouterPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *string = [NSString stringWithFormat:@"%@",_CardType];
    
    _txt_cc_type = [NSString stringWithFormat:@"%@",string];
    
    self.cardNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.CVCNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.selectedMonth.keyboardType = UIKeyboardTypeNumberPad;
    self.selectedYear.keyboardType = UIKeyboardTypeNumberPad;
     self.infoLabel.text = @"";
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    
    [self.view addGestureRecognizer:tap];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [CardIOUtilities preload];
}
-(void)dismissKeyboard {
    [self.cardNumber resignFirstResponder];
    [self.CVCNumber resignFirstResponder];

    [self.selectedMonth resignFirstResponder];

    [self.selectedYear resignFirstResponder];

    
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - CardIOPaymentViewControllerDelegate

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"Scan succeeded with info: %@", info);
    // Do whatever needs to be done to deliver the purchased items.
    [self dismissViewControllerAnimated:YES completion:nil];
    
    self.infoLabel.text = [NSString stringWithFormat:@"Received card info. Number: %@, expiry: %02lu/%lu, cvv: %@.", info.cardNumber, (unsigned long)info.expiryMonth, (unsigned long)info.expiryYear, info.cvv];
    
    self.cardNumber.text = info.cardNumber;
    self.CVCNumber.text = info.cvv;
    self.selectedMonth.text = [NSString stringWithFormat:@"%lu",(unsigned long)info.expiryMonth];
    self.selectedYear.text = [NSString stringWithFormat:@"%lu",(unsigned long)info.expiryYear];
}

- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)paymentViewController {
    NSLog(@"User cancelled scan");
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)aBtn_backClicked:(id)sender
{
    PaiementVC *payment = [self.storyboard instantiateViewControllerWithIdentifier:@"PaiementVC"];
    payment.CardType = self.txt_cc_type;
    [self.navigationController pushViewController:payment animated:NO];
}

- (IBAction)aBtn_ajouter_la_carte:(id)sender {
    
   //[CreditCard_Validator checkCardBrandWithNumber:self.cardNumber.text];
  // [CreditCard_Validator checkCreditCardNumber:self.cardNumber.text];

    temp_selectedmonth = [NSString stringWithFormat:@"%@",self.selectedMonth.text];
    temp_selctedyear = [NSString stringWithFormat:@"%@",self.selectedYear.text];

    self.stripeCard = [[STPCardParams alloc] init];
    //self.stripeCard.name = self.nameTextField.text;
    self.stripeCard.number = self.cardNumber.text;
    self.stripeCard.cvc = self.CVCNumber.text;
    self.stripeCard.expMonth = [self.selectedMonth.text intValue];
    self.stripeCard.expYear = [self.selectedYear.text intValue];
    
    
    
    
    
//    STPPaymentCardTextField *paymentTextField = [[STPPaymentCardTextField alloc] init];
//    paymentTextField.delegate = self;
//    paymentTextField.cursorColor = [UIColor purpleColor];
//    self.paymentTextField = paymentTextField;
//    [self.view addSubview:paymentTextField];

    
    
    
    if ([self validateCustomerInfo]) {
        [self performStripeOperation];
       
    }
}

//- (BOOL)validateCustomerInfo {
//    
//    UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Veuillez réessayer"
//                                                     message:@"S'il vous plaît entrer toutes les informations requises"
//                                                    delegate:nil
//                                           cancelButtonTitle:@"OK"
//                                           otherButtonTitles:nil];
//    
//    //1. Validate name & email
//    if (self.cardNumber.text.length == 0 ||
//        self.CVCNumber.text.length == 0 || self.selectedMonth.text.length ==0 || self.selectedYear.text.length == 0) {
//        
//        [alert show];
//        return NO;
//    }
//    
//    //2. Validate card number, CVC, expMonth, expYear
//    NSError* error = nil;
//    [self.stripeCard validateCardReturningError:&error];
//    
//    //3
//    if (error) {
//        alert.message = [error localizedDescription];
//        [alert show];
//        return NO;
//    }
//    
//    return YES;
//}
- (BOOL)validateCustomerInfo {
    
    
    //2. Validate card number, CVC, expMonth, expYear
    expMonth = [NSString stringWithFormat:@"%lu",(unsigned long)self.stripeCard.expMonth];
    expYear = [NSString stringWithFormat:@"%lu",(unsigned long)self.stripeCard.expYear];
    [STPCardValidator validationStateForExpirationMonth:expMonth];
    [STPCardValidator validationStateForExpirationYear:expYear inMonth:expMonth];
    if ([self.txt_cc_type isEqualToString:@"Visa"]) {
        [STPCardValidator validationStateForCVC:self.stripeCard.cvc cardBrand:STPCardBrandVisa];
        [STPCardValidator validationStateForNumber:self.stripeCard.number validatingCardBrand:STPCardBrandVisa];
        regex = [NSRegularExpression regularExpressionWithPattern:kVISA_TYPE options:0 error:nil];
        NSUInteger matches = [regex numberOfMatchesInString:self.stripeCard.number options:0 range:NSMakeRange(0, 4)];
        NSLog(@"%d",matches);
        if (matches == 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                             message:@"S'il vous plaît Entrez Visa Card Détails"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];
            
        }

    }

    
    else if ([self.txt_cc_type isEqualToString:@"MasterCard"]){
        [STPCardValidator validationStateForCVC:self.stripeCard.cvc cardBrand:STPCardBrandMasterCard];
        [STPCardValidator validationStateForNumber:self.stripeCard.number validatingCardBrand:STPCardBrandMasterCard];
        

        regex = [NSRegularExpression regularExpressionWithPattern:kMASTER_CARD_TYPE options:0 error:nil];
        NSUInteger matches = [regex numberOfMatchesInString:self.stripeCard.number options:0 range:NSMakeRange(0, 4)];
        NSLog(@"%d",matches);
        if (matches == 0) {
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                             message:@"S'il vous plaît Entrez MasterCard Détails"
                                                            delegate:nil
                                                   cancelButtonTitle:@"OK"
                                                   otherButtonTitles:nil];
            [alert show];

        }
        
    }
    return YES;
    
}

- (void)performStripeOperation
{
    [[STPAPIClient sharedClient] createTokenWithCard:self.stripeCard
                                          completion:^(STPToken *token, NSError *error)
    {
                                              if (error)
                                              {
                                                  //                                           [self handleError:error];
                                                  NSLog(@"ERRRRR = %@",error);
                                                  UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Please try again"
                                                                                                   message:[NSString stringWithFormat:@"%@",error.localizedDescription]
                                                                                                  delegate:nil
                                                                                         cancelButtonTitle:@"OK"
                                                                                         otherButtonTitles:nil];
                                                  [alert show];
                                              } else
                                              {
                                                   NSLog(@"Successful");
                                                  //when credit card details is correct code here
                                                  [self service];
                                              }
                                          }];
}

-(void)service
{
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
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
                [dictParam setValue:self.txt_cc_type forKey:@"card_type"];
                [dictParam setValue:self.cardNumber.text forKey:@"card_num"];
                [dictParam setValue:self.CVCNumber.text forKey:@"csv_num"];
                [dictParam setValue:temp_selctedyear forKey:@"ex_year"];
                [dictParam setValue:temp_selectedmonth forKey:@"ex_month"];
                
                
              //  [dictParam setValue:strdistance forKey:PARAM_DISTANCE];
                
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_SAVE_CARD_INFO withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     
                     NSLog(@"sevices Response ---> %@",response);
                     if (response)
                     {
                         if([[response valueForKey:@"success"]boolValue])
                         {
                             
                             NSString *strLog=[NSString stringWithFormat:@"%@",NSLocalizedString(@"Carte Détails Saved", nil)];
                             
                             
                             [APPDELEGATE showToastMessage:strLog];
                             NSString *cc_type = [NSString stringWithFormat:@"%@",self.txt_cc_type];
                             PaiementVC *PV = [self.storyboard instantiateViewControllerWithIdentifier:@"PaiementVC"];
                             PV.CardType = cc_type;
                             [self.navigationController pushViewController:PV animated:YES];
                         }
                         else
                         {
                             
                             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                             [alert show];
                         }
                     }
                     [APPDELEGATE hideLoadingView];
                 }];
            }
            else
            {
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    [APPDELEGATE hideHUDLoadingView];
}




- (IBAction)camera_clicked:(id)sender
{
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:scanViewController animated:YES completion:nil];
}
@end
