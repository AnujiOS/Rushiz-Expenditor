//
//  PaiementVC.m
//  Ruchiz
//
//  Created by mac on 9/7/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "PaiementVC.h"
#import "AjouterPaymentVC.h"
#import "CommandPageViewController.h"
#import "MFSideMenu.h"
#import "PaiementTVCell.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "PaymentViewControllerVC.h"
#import <Stripe.h>
#import "OrderStatusVC.h"
@protocol STPBackendCharging;

typedef NS_ENUM(NSInteger, STPBackendChargeResult) {
    STPBackendChargeResultSuccess,
    STPBackendChargeResultFailure,
    
};

typedef void (^STPTokenSubmissionHandler)(STPBackendChargeResult status, NSError *error);

@protocol STPBackendCharging <NSObject>

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion;

@end

@interface PaiementVC ()<UITableViewDelegate,UITableViewDataSource,STPBackendCharging>
{
    NSMutableArray *card_info;
    NSDictionary *pack_id;
    NSString *card_id;
     NSString *token_id;
    NSData *data;
    NSString *newString;
    NSString *promo_id;
    NSString *promocode;
    NSString *promo_value;
}
@property (weak, nonatomic) UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) STPCardParams* stripePayment;
@property (nonatomic, weak) id<STPBackendCharging> backendCharger;
@end

@implementation PaiementVC

- (void)viewDidLoad {
    [super viewDidLoad];
    card_info = [[NSMutableArray alloc]init];
    pack_id = [[NSDictionary alloc]init];
    
    self.backendCharger = self;
    NSLog(@"%@",self.amount);
   //self.str_amount = [NSString stringWithFormat:@"%@",self.amount];
    NSLog(@"%@",self.str_amount);
    [self service];
    
    
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.hidesWhenStopped = YES;
    self.activityIndicator = activityIndicator;
    [self.view addSubview:activityIndicator];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)aBtnPaymentClicked:(UIButton *)sender
{
    AjouterPaymentVC *APV = [self.storyboard instantiateViewControllerWithIdentifier:@"AjouterPaymentVC"];
    APV.CardType = [NSString stringWithFormat:@"%@",_CardType];
    [self.navigationController pushViewController:APV animated:YES];

}

- (IBAction)aBtnBackClicked:(UIButton *)sender
{
    //[self.navigationController popViewControllerAnimated:YES];
    PaymentViewControllerVC *CPV = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewControllerVC"];
//     [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen];
    [self.navigationController pushViewController:CPV animated:YES];

}
- (IBAction)BtnCancle:(id)sender
{
    [self delete_card];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [card_info count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*CellIndentifier=@"Cell";
    PaiementTVCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if(!cell){
        cell=[[PaiementTVCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    cell.backgroundColor = [UIColor lightGrayColor];
    NSString* formattedNumber = [NSString stringWithFormat:@"%@",[[card_info objectAtIndex:indexPath.section]valueForKey:@"card_num"]];
    
    newString = [formattedNumber substringFromIndex:[formattedNumber length] - 4];
    int distance = [newString intValue];
    cell.lblCard_num.text = [NSString stringWithFormat:@"... .... ..%d",distance];
    card_id = [[card_info objectAtIndex:indexPath.section] valueForKey:@"id"];
    if ([_CardType isEqualToString:@"Visa"]) {
       
        cell.ImgCard.image = [UIImage imageNamed:@"visa_card_img.png"];
    }
    else if ([_CardType isEqualToString:@"MasterCard"])
    {
        cell.ImgCard.image = [UIImage imageNamed:@"master_card_img.png"];

    }
    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
   // pack_id = [NSString stringWithFormat:@"%@",[[card_info objectAtIndex:indexPath.row] valueForKey:@"id"]];
    pack_id = [card_info objectAtIndex:indexPath.section];
    card_id = [[card_info objectAtIndex:indexPath.section] valueForKey:@"id"];
    [self payment];
    //[self order_confirm_strip];
}

-(void)payment
{
    NSString *cvc  = [NSString stringWithFormat:@"%@",[pack_id valueForKey:@"csv_num"]];
    NSString *card = [NSString stringWithFormat:@"%@",[pack_id valueForKey:@"card_num"]];
    NSString *month = [NSString stringWithFormat:@"%@",[pack_id valueForKey:@"ex_month"]];
    NSString *year = [NSString stringWithFormat:@"%@",[pack_id valueForKeyPath:@"ex_year"]];
    
    self.stripePayment = [[STPCardParams alloc] init];
    //self.stripeCard.name = self.nameTextField.text;
    self.stripePayment.number = card;
    self.stripePayment.cvc = cvc;
    self.stripePayment.expMonth = [month intValue];
    self.stripePayment.expYear = [year intValue];
    
    
    
    
    
    if (![Stripe defaultPublishableKey]) {
        NSError *error = [NSError errorWithDomain:StripeDomain
                                             code:STPInvalidRequestError
                                         userInfo:@{
                                                    NSLocalizedDescriptionKey: @"Please specify a Stripe Publishable Key in Constants.m"
                                                    }];
        //[self.delegate paymentViewController:self didFinish:error];
        return;
    }
    [self.activityIndicator startAnimating];
    [[STPAPIClient sharedClient] createTokenWithCard:self.stripePayment
                                          completion:^(STPToken *token, NSError *error) {
                                              [self.activityIndicator stopAnimating];
                                              if (error) {
                                                  NSLog(@"amout: %@",self.str_amount);
                                                 // [self.delegate paymentViewController:self didFinish:error];
                                              }
                                              [self.backendCharger createBackendChargeWithToken:token
                                                                                     completion:^(STPBackendChargeResult result, NSError *error) {
                                                                                         [self order_confirm_strip];
                                                                                         token_id= [NSString stringWithFormat:@"%@",token];
                                                                                         if (error) {
                                                                                             //[self.delegate paymentViewController:self didFinish:error];
                                                                                             NSLog(@"amout: %@",self.str_amount);
                                                                                             return;
                                                                                         }
                                                                                         //[self.delegate paymentViewController:self didFinish:nil];
                                                                                         NSLog(@"amout: %@",self.str_amount);
                                                                                         
//                                                                                         [self paymentSucceeded];
//                                                                                         OrderStatusVC *back = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderStatusVC"];
//                                                                                         [self.navigationController pushViewController:back animated:YES];
                                                                                     }];
                                          }];

}
-(void)service{
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
                [dictParam setValue:_CardType forKey:@"card_type"];
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_DISPLAY_CARD_INFO withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     
                     NSLog(@"sevices Response ---> %@",response);
                     if (response)
                         
                     {
                         if([[response valueForKey:@"success"]boolValue])
                         {
                             
                             card_info = [response valueForKey:@"result"];
                             [self.table_view reloadData];
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
-(void)delete_card{
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
                [dictParam setValue:card_id forKey:@"card_id"];
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_DELETE_CARD_INFO withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     
                     NSLog(@"sevices Response ---> %@",response);
                     if (response)
                         
                     {
                         if([[response valueForKey:@"success"]boolValue])
                         {
                             
                            // card_info = [response valueForKey:@"result"];
                             [self service];
                           //  [self.table_view reloadData];
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

#pragma mark - STPBackendCharging

- (void)createBackendChargeWithToken:(STPToken *)token completion:(STPTokenSubmissionHandler)completion
{
    if (!BackendChargeURLString)
    {
        NSError *error = [NSError errorWithDomain:StripeDomain code:STPInvalidRequestError userInfo:@
                          {
                          NSLocalizedDescriptionKey: [NSString stringWithFormat:@"Good news! Stripe turned your credit card into a token: %@ \nYou can follow the "@"instructions in the README to set up an example backend, or use this "@"token to manually create charges at dashboard.stripe.com .",token.tokenId]
                          }];
        completion(STPBackendChargeResultFailure, error);
        return;
    }
    
    // This passes the token off to our payment backend, which will then actually complete charging the card using your Stripe account's secret key
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config];
    NSString *urlString = [BackendChargeURLString stringByAppendingPathComponent:@"charge"];
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *postBody = [NSString stringWithFormat:@"stripeToken=%@&amount=%@", token.tokenId, self.str_amount];
    token_id = [NSString stringWithFormat:@"%@",token.tokenId];
    data = [postBody dataUsingEncoding:NSUTF8StringEncoding];
    NSString *newStr1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"Data %@",newStr1);
    NSDictionary *allDataDictionary=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"DATA: %@",allDataDictionary);
    
    [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
    NSURLSessionUploadTask *uploadTask = [session uploadTaskWithRequest:request fromData:data completionHandler:^(NSData *data, NSURLResponse *response, NSError *error)
                                          {
                                              NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
                                              if (!error && httpResponse.statusCode != 200)
                                              {
                                                  error = [NSError errorWithDomain:StripeDomain code:STPInvalidRequestError userInfo:@{NSLocalizedDescriptionKey: @"There was an error connecting to your payment backend."}];
                                              }
                                              if (error)
                                              {
                                                  completion(STPBackendChargeResultFailure, error);
                                              }
                                              else
                                              {
                                                  completion(STPBackendChargeResultSuccess, nil);
                                                  NSLog(@"Response : %@",response);
                                                  NSDictionary *allDataDictionary=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
                                                  NSLog(@"DATA: %@",allDataDictionary);
                                              }
                                              [APPDELEGATE hideLoadingView];
                                          }];
    
    [uploadTask resume];
}
-(void)order_confirm_strip
{
    if([APPDELEGATE connected])
    {
    if([[AppDelegate sharedAppDelegate]connected])
    {
        
        if ([[AppDelegate sharedAppDelegate]connected])
        {   //token_id =@"tok_18vmp8Al7wJmVZ9UPzel7bck";
            //NSString *promo = [NSString stringWithFormat:@"%f",promo_price];
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            //last_four = @"4242";
            //cart_type = @"VISA";
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:_CardType forKey:@"card_type"];
            [dictParam setValue:strUserID forKey:@"id"];
            [dictParam setValue:newString forKey:@"last_four"];
            [dictParam setValue:token_id forKey:@"trans_id"];
            //if (final_total == nil)
           // {
                [dictParam setValue:self.str_amount forKey:@"total_euro"];
           // }
            //else
           // {
           //     [dictParam setValue:final_total forKey:@"total_euro"];
           // }
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
                         [self paymentSucceeded];
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
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    
}
- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller didAuthorizePayment:(PKPayment *)payment completion:(void (^)(PKPaymentAuthorizationStatus))completion
{
    [[STPAPIClient sharedClient] createTokenWithPayment:payment
                                             completion:^(STPToken *token, NSError *error)
     {
         [self createBackendChargeWithToken:token completion:^(STPBackendChargeResult status, NSError *error)
          {
              if (status == STPBackendChargeResultSuccess)
              {
                  //self.applePaySucceeded = YES;
                  completion(PKPaymentAuthorizationStatusSuccess);
              }
              else
              {
                 // self.applePayError = error;
                  completion(PKPaymentAuthorizationStatusFailure);
              }
          }];
         
     }];
}
- (void)paymentSucceeded
{
    UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"Success" message:@"Payment successfully created!" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [controller addAction:action];
}




@end
