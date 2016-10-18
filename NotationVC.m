//
//  NotationVC.m
//  Ruchiz
//
//  Created by mac on 9/26/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "NotationVC.h"
#import "UtilityClass.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "CommandPageViewController.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import "UIImageView+WebCache.h"

@interface NotationVC ()<UIGestureRecognizerDelegate>
{
    BOOL internet;
     NSString *user_id,*user_token,*o_id,*strForCurLongitude,*deliveryboy_name;
    NSString *deliveryboy_image;
    UITapGestureRecognizer *tapRecognizer;
    NSString *rate;
}

@end

@implementation NotationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    internet = [APPDELEGATE connected];
//    NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
//    user_id=[pref objectForKey:PREF_USER_ID];
//    user_token=[pref objectForKey:PREF_USER_TOKEN];
//    o_id = [pref objectForKey:PREF_O_ID];
//    expenditor_image = [pref objectForKey:PREF_OWNER_IMAGE];
//    expender_name = [pref objectForKey:PREF_OWNER_NAME];
    
    self.rateView.notSelectedImage = [UIImage imageNamed:@"StarEmpty.png"];
    self.rateView.halfSelectedImage = [UIImage imageNamed:@"star_feedback_half.png"];
    self.rateView.fullSelectedImage = [UIImage imageNamed:@"StarFull.png"];
    self.rateView.rating = 0;
    self.rateView.editable = YES;
    self.rateView.maxRating = 5;
    self.rateView.delegate = self;
    if ([[AppDelegate sharedAppDelegate]connected]){
     NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
    
    deliveryboy_image = [pref objectForKey:PREF_DELIVERYBOY_IMAGE];
        deliveryboy_name = [pref objectForKey:PREF_DELIVERYBOY_NAME];
        
    }
    
   // self.Img_Deliveryboy_image.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:deliveryboy_image]]];
   [self.Img_Deliveryboy_image sd_setImageWithURL:[NSURL URLWithString:deliveryboy_image] placeholderImage:nil];

    self.Lbl_DeliveryBoy_name.text = [NSString stringWithFormat:@"%@",deliveryboy_name];
    self.Img_Deliveryboy_image.layer.cornerRadius = self.Img_Deliveryboy_image.frame.size.height/2;
    self.Img_Deliveryboy_image.layer.masksToBounds = YES;
    self.Img_Deliveryboy_image.layer.borderWidth = 0;

    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapAnywhere:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
}
- (void)didTapAnywhere:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
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
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating
{
     rate = [NSString stringWithFormat:@"%.0f", rating];
    
}

- (IBAction)Btn_Validate:(id)sender
{
    if (![rate isEqualToString:@"0.00"]) {
        [self owner_pack_order_details];

    }
    
    
   
}
-(void)owner_pack_order_details
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
                NSString *pack_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"pack_id"];
                NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                [dictParam setValue:strUserToken forKey:@"token"];
                [dictParam setValue:strUserID forKey:@"id"];
                [dictParam setObject:pack_id forKey:@"request_id"];
                [dictParam setObject:self.TextView_commentaires.text forKey:@"comment"];
                [dictParam setObject:rate forKey:@"rating"];
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_RATING withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     
                     NSLog(@"Validation Response ---> %@",response);
                     if (response)
                     {
                         if([response valueForKey:@"success"])
                         {
                             NSLog(@"Response :::::: %@",response);
                             
                             CommandPageViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
                             [self.navigationController pushViewController:vc animated:NO];
                             
//                             pack_details  = [response valueForKey:@"result"];
//                             total_euro = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"total_euro"]];
//                             service_name = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"services_name"]];
//                             order_qty = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"order_qty"]];
//                             order_date = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"order_date"]];
//                             
//                             self.lbl_totalPrize.text = [NSString stringWithFormat:@"%@ %@",total_euro,@"\u20ac"];
//                             self.lbl_serviceName.text = service_name;
//                             self.lbl_numProduct.text = order_qty;
//                             self.lbl_Date.text = order_date;
//                             
//                             NSString *delivey_boy_image = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"owner_image"]];
//                             NSString *f_name = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"f_name"]];
//                             NSString *l_name = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"l_name"]];
//                             
//                             NSString *delivey_boy_name = [NSString stringWithFormat:@"%@ %@",f_name,l_name];
//                             
//                             
//                             NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
//                             [pref setObject:delivey_boy_image forKey:PREF_DELIVERYBOY_IMAGE];
//                             [pref setObject:delivey_boy_name forKey:PREF_DELIVERYBOY_NAME];
//                             
//                             [pref synchronize];
                             
                             
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
    
}


- (IBAction)Btn_Backmenu:(id)sender {
}
@end
