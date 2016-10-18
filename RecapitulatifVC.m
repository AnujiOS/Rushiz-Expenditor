//
//  RecapitulatifVC.m
//  Ruchiz
//
//  Created by mac on 9/22/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "RecapitulatifVC.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import "SlideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "NotationVC.h"

@interface RecapitulatifVC ()
{
    NSDictionary *pack_details;
    NSString * total_euro;
    NSString *service_name;
    NSString *order_qty;
    NSString *order_date;
}
@end

@implementation RecapitulatifVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self owner_pack_order_details];
    pack_details = [[NSDictionary alloc]init];
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
                [dictParam setObject:pack_id forKey:@"o_id"];
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_GET_ORDER_BILL withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     
                     NSLog(@"Validation Response ---> %@",response);
                     if (response)
                     {
                         if([response valueForKey:@"success"])
                         {
                             NSLog(@"Response :::::: %@",response);
                            
                             pack_details  = [response valueForKey:@"result"];
                             total_euro = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"total_euro"]];
                             service_name = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"services_name"]];
                             order_qty = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"order_qty"]];
                             order_date = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"order_date"]];
                             
                             self.lbl_totalPrize.text = [NSString stringWithFormat:@"%@ %@",total_euro,@"\u20ac"];
                             self.lbl_serviceName.text = service_name;
                             self.lbl_numProduct.text = order_qty;
                             self.lbl_Date.text = order_date;
                             
                             NSString *delivey_boy_image = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"owner_image"]];
                             NSString *f_name = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"f_name"]];
                             NSString *l_name = [NSString stringWithFormat:@"%@",[pack_details valueForKey:@"l_name"]];
                             
                             NSString *delivey_boy_name = [NSString stringWithFormat:@"%@ %@",f_name,l_name];
                             
                             
                             NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                             [pref setObject:delivey_boy_image forKey:PREF_DELIVERYBOY_IMAGE];
                             [pref setObject:delivey_boy_name forKey:PREF_DELIVERYBOY_NAME];
                             
                             [pref synchronize];

                             
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


- (IBAction)Btn_noter_votre_coursier:(id)sender {
    NotationVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"NotationVC"];
    [self.navigationController pushViewController:vc animated:NO];

   
}
@end
