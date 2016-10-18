//
//  RegistrationPageViewController.m
//  Ruchiz
//
//  Created by ganesh on 4/29/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "RegistrationPageViewController.h"
#import "RegistrationUserViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "CommandPageViewController.h"
#import "WebServiceViewController.h"
#import "FacebookUtility.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "UtilityClass.h"
#import "SliderPagesViewController.h"
#import "SlideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"


@interface RegistrationPageViewController ()
{
    NSString *Fbid;
    NSString *Firstname;
    NSString *stremail;
    NSString *strForSocialId,*strForRegistrationType,*strForEmail;
    NSString *strImageData,*strForToken,*strForID;
    AppDelegate *appDelegate;
}
@end

@implementation RegistrationPageViewController

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self SetLocalization];
    appDelegate=[AppDelegate sharedAppDelegate];
    [self.navigation_bar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigation_bar.shadowImage = [UIImage new];
    self.navigation_bar.translucent = YES;
}
-(void)viewWillAppear:(BOOL)animated
{
    [[FacebookUtility sharedObject] logOutFromFacebook];
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)SetLocalization
{
//    self.lblEmailInfo.text=NSLocalizedString(@"INFO_EMAIL", nil);
//    self.txtFirstName.placeholder=NSLocalizedString(@"FIRST NAME*", nil);
//    self.txtLastName.placeholder=NSLocalizedString(@"LAST NAME*", nil);
//    self.txtEmail.placeholder=NSLocalizedString(@"EMAIL*", nil);
//    self.txtPassword.placeholder=NSLocalizedString(@"PASSWORD*", nil);
//    self.txtNumber.placeholder=NSLocalizedString(@"NUMBER*", nil);
//    // [self.btnTerm setTitle:NSLocalizedString(@"I agree to the terms and conditions", nil) forState:UIControlStateNormal];
//    [self.btnRegister setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
//    [self.btnCancel setTitle:NSLocalizedString(@"CANCEL", nil) forState:UIControlStateNormal];
//    [self.btnDone setTitle:NSLocalizedString(@"Done", nil) forState:UIControlStateNormal];
//    //  self.lblSelectCountry.text=NSLocalizedString(@"Select Country", nil);
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)mobile_registration:(id)sender {
    RegistrationUserViewController *log = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationUserViewController"];
    log.flag=@"Manual";
    [self.navigationController pushViewController:log animated:YES];
}

- (IBAction)fb_registration:(id)sender {
    [FBSDKAccessToken setCurrentAccessToken:nil];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        NSString *domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0) {
            [storage deleteCookie:cookie];
        }
    }
    RegistrationUserViewController *log = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationUserViewController"];
    log.flag=@"Facebook";
    [self.navigationController pushViewController:log animated:YES];
//    strForRegistrationType=@"facebook";
//        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SocialFBClicked"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SocialDBClicked"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
//    
//    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
//    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"picture,first_name,last_name,email,name",@"fields",nil];
//    
//    [loginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_photos"] handler:^(FBSDKLoginManagerLoginResult *response, NSError *error)
//     
//     {
//         
//         [[[FBSDKGraphRequest alloc]
//           initWithGraphPath:@"me"
//           parameters:params
//           HTTPMethod:@"GET"]
//          startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id response, NSError *error) {
//              if (!error) {
//                  [APPDELEGATE hideLoadingView];
//                  appDelegate = [UIApplication sharedApplication].delegate;
//                  NSLog(@"Result: %@", response);
//                  strForSocialId=[response valueForKey:@"id"];
//                  Firstname = [response valueForKey:@"name"];
//                  strForEmail = [response valueForKey:@"email"];
//                  strForSocialId = [response valueForKey:@"id"];
//                 //[self FBwithlogn];
//                  
//                  
//                  
//              }
//              else{
//                  
//              }
//          }];
//         
//         
//     }];
//
//   

//    strForRegistrationType=@"facebook";
//    
//    
//    if (![[FacebookUtility sharedObject]isLogin])
//    {
//        [[FacebookUtility sharedObject]loginInFacebook:^(BOOL success, NSError *error)
//         {
//             [APPDELEGATE hideLoadingView];
//             if (success)
//             {
//                // self.txtPassword.userInteractionEnabled=NO;
//                 NSLog(@"Success");
//                 appDelegate = [UIApplication sharedApplication].delegate;
//                 [appDelegate userLoggedIn];
//                 [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
//                     if (response) {
//                         NSLog(@"FB Response ->%@",response);
//                         strForSocialId=[response valueForKey:@"id"];
//                        // self.txtEmail.text=[response valueForKey:@"email"];
//                         NSArray *arr=[[response valueForKey:@"name"] componentsSeparatedByString:@" "];
//                         //self.txtFirstName.text=[arr objectAtIndex:0];
//                         //self.txtLastName.text=[arr objectAtIndex:1];
//                         
//                         //[self.imgProPic downloadFromURL:[response valueForKey:@"link"] withPlaceholder:nil];
//                         NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [response objectForKey:@"id"]];
//                         //[self.imgProPic downloadFromURL:userImageURL withPlaceholder:nil];
//                         //isPicAdded=YES;
//                     }
//                 }];
//             }
//         }];
//    }
//    else{
//        NSLog(@"User Login Click");
//        appDelegate = [UIApplication sharedApplication].delegate;
//        [[FacebookUtility sharedObject]fetchMeWithFBCompletionBlock:^(id response, NSError *error) {
//            [APPDELEGATE hideLoadingView];
//            if (response) {
//                NSLog(@"FB Response ->%@ ",response);
//                strForSocialId=[response valueForKey:@"id"];
//                
//                //self.txtEmail.text=[response valueForKey:@"email"];
//                NSArray *arr=[[response valueForKey:@"name"] componentsSeparatedByString:@" "];
//                //self.txtFirstName.text=[arr objectAtIndex:0];
//                //self.txtLastName.text=[arr objectAtIndex:1];
//                
//                //[self.imgProPic downloadFromURL:[response valueForKey:@"link"] withPlaceholder:nil];
//                NSString *userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [response objectForKey:@"id"]];
//                //[self.imgProPic downloadFromURL:userImageURL withPlaceholder:nil];
//                //isPicAdded=YES;
//            }
//        }];
//        //[appDelegate userLoggedIn];
//       
//    }
//[self onClickLogin:nil];
      }
-(IBAction)onClickLogin:(id)sender
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        //        if(self.txtEmail.text.length>0)
        //        {
        //[[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOGIN", nil)];
        
        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
        NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
        
        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
        [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
        [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
        if([strForRegistrationType isEqualToString:@"manual"])
            [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
        // else
        //     [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
        
        [dictParam setValue:strForRegistrationType forKey:PARAM_LOGIN_BY];
        
        if([strForRegistrationType isEqualToString:@"facebook"])
            [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
        //            else if ([strLoginType isEqualToString:@"google"])
        //                [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
        //            else
        //                [dictParam setValue:self.txtPsw.text forKey:PARAM_PASSWORD];
        
        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
        [afn getDataFromPath:FILE_LOGIN withParamData:dictParam withBlock:^(id response, NSError *error)
         {
             [[AppDelegate sharedAppDelegate]hideLoadingView];
             
             NSLog(@"Login Response ---> %@",response);
             if (response)
             {
                 if([[response valueForKey:@"success"]boolValue])
                 {
                     NSString *strLog=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"LOGIN_SUCCESS", nil),[response valueForKey:@"first_name"]];
                     
                     [APPDELEGATE showToastMessage:strLog];
                     
                     
                     NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                     [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                     [pref setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                     [pref setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
                     [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                     [pref setBool:YES forKey:PREF_IS_LOGIN];
                     [pref synchronize];
                     
                     [self performSegueWithIdentifier:SEGUE_SUCCESS_LOGIN sender:self];
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
        //           if(self.txtEmail.text.length==0)
        //           {
        //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        //                [alert show];
        //            }
        //            else
        //            {
        //                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_PASSWORD", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        //                [alert show];
        //            }
        //        }
    }
    //    else
    //    {
    //        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
    //        [alert show];
    //    }
}

-(void)FBwithlogn
{
    //[self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
//    NSString *type = @"ios";
//    
////    NSString *token = [[NSUserDefaults standardUserDefaults]
////                       stringForKey:@"Device_token"];
////    if (token == nil) {
////        token = @"b3449d06af52599f0ae61039f48f13a26b23376a25617dc208129856992fd70c";
////    }
//    
//    NSMutableDictionary *dictResultSignIn=[[NSMutableDictionary alloc]init];
//    NSMutableDictionary *dicSubmit = [[NSMutableDictionary alloc]init];
//    [WebServiceViewController wsVC].strURL =@"http://cbdemo.in/rushiz/api.php";
//    //http://cbdemo.in/turbo_food/api.php?method=view_category_menu&r_id=1&c_id=1
//    [WebServiceViewController wsVC].strCallHttpMethod = @"POST";
//    [WebServiceViewController wsVC].strMethodName = @"login_fb";
//    
//    [dicSubmit setObject:Fbid forKey:@"fb_id"];
//    [dicSubmit setObject:stremail forKey:@"email"];
//    [dicSubmit setObject:Firstname forKey:@"name"];
//    [dicSubmit setObject:@"9409460116" forKey:@"mobile"];
//    [dicSubmit setObject:type forKey:@"type"];
//    
//    NSLog(@"DicSubmit = %@",dicSubmit);
//    
//    dictResultSignIn = [[WebServiceViewController wsVC] sendRequestWithParameter:dicSubmit];
//    
//    if (dictResultSignIn != Nil || dictResultSignIn != NULL) {
//        NSLog(@"dictResultSubmit = %@",dictResultSignIn);
//        
//        if ([[dictResultSignIn objectForKey:@"status"]integerValue] == 0)
//        {
//           // dict =[dictResultSignIn objectForKey:@"message"];
//            
//            
//            
//            NSMutableDictionary *user = [[NSMutableDictionary alloc]init];
//            user = [dictResultSignIn objectForKey:@"user"];
//            
//            NSMutableDictionary *u_id = [[NSMutableDictionary alloc]init];
//            u_id = [user objectForKey:@"id"];
//            
//            [[NSUserDefaults standardUserDefaults]setObject:u_id forKey:@"u_id"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            NSString *email = [user objectForKey:@"email" ];
//            
//            [[NSUserDefaults standardUserDefaults]setObject:email forKey:@"email"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//           // [[NSUserDefaults standardUserDefaults] setObject:dict forKey:@"userLogedinData"];
//           // [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            [[NSUserDefaults standardUserDefaults] synchronize];
//            
//            CommandPageViewController *VC2 = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
//            
//            [self.navigationController pushViewController:VC2 animated:YES];
//            
//            
//            
//            
//        }
//        else if ( [[dictResultSignIn objectForKey:@"status"]integerValue] == 1)
//        {
//            
//            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Message"
//            //                                                           message:@"Mauvais Nom d'utilisateur ou mot de passe" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
//            //            [alert show];
//        }
//        
//        
//    }
//    else
//    {
//        
//    }
    //[self.delegate FBwithlogn:self];
    
//    if([[AppDelegate sharedAppDelegate]connected]){
//        [[UtilityClass sharedObject]isValidEmailAddress:strForEmail];
//        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
//        NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
//        
//        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
//        [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
//        [dictParam setValue:Firstname forKey:PARAM_FIRST_NAME];
//        [dictParam setValue:Firstname forKey:PARAM_LAST_NAME];
//        [dictParam setValue:@"" forKey:PARAM_PHONE];//strnumber
//        [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
//        [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
//        [dictParam setValue:@"" forKey:PARAM_BIO];
//        [dictParam setValue:@"" forKey:PARAM_ADDRESS];
//        [dictParam setValue:@"" forKey:PARAM_STATE];
//        [dictParam setValue:@"" forKey:PARAM_COUNTRY];
//        [dictParam setValue:@"" forKey:PARAM_ZIPCODE];
//        [dictParam setValue:strForRegistrationType forKey:PARAM_LOGIN_BY];
//        
//        if([strForRegistrationType isEqualToString:@"facebook"])
//            [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
//        else if ([strForRegistrationType isEqualToString:@"google"])
//            [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
//        else
//            [dictParam setValue:strForSocialId forKey:PARAM_PASSWORD];
//    
//        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
//        [afn getDataFromPath:FILE_REGISTER withParamData:dictParam withBlock:^(id response, NSError *error) {
//            [[AppDelegate sharedAppDelegate]hideLoadingView];
//            if (response)
//            {
//                if([[response valueForKey:@"success"] boolValue])
//                {
//                    [APPDELEGATE showToastMessage:NSLocalizedString(@"REGISTER_SUCCESS", nil)];
//                    strForID=[response valueForKey:@"id"];
//                    strForToken=[response valueForKey:@"token"];
//                    [pref setObject:response forKey:PREF_LOGIN_OBJECT];
//                    
//                    [pref setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
//                    [pref setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
//                    [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
//                    [pref setBool:YES forKey:PREF_IS_LOGIN];
//                    [pref synchronize];
//                  //  [self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
//                    
//                }
//                else
//                {
//                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//                    [alert show];
//                }
//                
//            }
//            NSLog(@"REGISTER RESPONSE --> %@",response);
//        }];
//    }
}

- (IBAction)back_btn:(id)sender {
//    SliderPagesViewController *back = [self.storyboard instantiateViewControllerWithIdentifier:@"SliderPagesViewController"];
//    [self.navigationController pushViewController:back animated:YES];
     [self.navigationController popViewControllerAnimated:YES];
}
@end
