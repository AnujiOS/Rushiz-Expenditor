//
//  LoginPageViewController.m
//  Ruchiz
//
//  Created by ganesh on 4/28/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "LoginPageViewController.h"
#import "ResetPasswdViewController.h"
#import "CommandPageViewController.h"
#import "FacebookUtility.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import "Constants.h"
#import "UtilityClass.h"
//#import <FacebookSDK/FacebookSDK.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "SliderPagesViewController.h"
#import "SlideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface LoginPageViewController ()<UITextFieldDelegate,UITextInputDelegate>
{
    NSString *strForSocialId,*strLoginType,*strForEmail,*strForPhone;
    AppDelegate *appDelegate;
}

@end

@implementation LoginPageViewController

#pragma mark -
#pragma mark - Init

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

#pragma mark -
#pragma mark - ViewLife Cycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.navigationbar setBackgroundImage:[UIImage new]
                             forBarMetrics:UIBarMetricsDefault];
    self.navigationbar.shadowImage = [UIImage new];
    self.navigationbar.translucent = YES;
    [self setLocalization];
    
    [self.txt_mobile setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txt_passwd setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txt_mobile setReturnKeyType:UIReturnKeyNext];
    [self.txt_passwd setReturnKeyType:UIReturnKeyGo];
    [self.txt_mobile  addTarget:self action:@selector(txt_mobile:) forControlEvents:UIControlEventEditingDidEndOnExit ];
    [self.txt_passwd addTarget:self action:@selector(txt_passwd:) forControlEvents:UIControlEventEditingDidEndOnExit ];
    strLoginType=@"manual";
    UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
}
-(void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
   //[[FacebookUtility sharedObject] logOutFromFacebook];
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)setLocalization
{
    self.txt_mobile.placeholder=NSLocalizedString(@"Mobile", nil);
    self.txt_passwd.placeholder=NSLocalizedString(@"Password", nil);
}

#pragma mark -
#pragma mark - TextField Delegate

-(BOOL)txt_mobile:(id)sender
{
    [self.txt_mobile resignFirstResponder];
    [self.txt_passwd becomeFirstResponder];
    return YES;
}
-(BOOL)txt_passwd:(id)sender
{
    [self connexion:sender];
    return NO;
}

-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
{
    [self.txt_mobile resignFirstResponder];
    [self.txt_passwd resignFirstResponder];
}
-(void)keyboardWillShow {
    // Animate the current view out of the way
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y > 0)
    {
        [self setViewMovedUp:YES];
        [self.view endEditing:YES];
    }
    
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    
    //Keyboard becomes visible
    self.scroll_view.frame = CGRectMake(self.scroll_view.frame.origin.x,
                                   self.scroll_view.frame.origin.y,
                                   self.scroll_view.frame.size.width,
                                   self.scroll_view.frame.size.height - 215 + 50);   //resize
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    //keyboard will hide
    self.scroll_view.frame = CGRectMake(self.scroll_view.frame.origin.x,
                                   self.scroll_view.frame.origin.y,
                                   self.scroll_view.frame.size.width,
                                   self.scroll_view.frame.size.height + 215 - 50); //resize
    
    
}
-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    NSInteger nextTag = textField.tag + 1;
    // Try to find next responder
    UIResponder* nextResponder = [textField.superview viewWithTag:nextTag];
    if (nextResponder) {
        // Found next responder, so set it.
        [nextResponder becomeFirstResponder];
    } else {
        // Not found, so remove keyboard.
        [textField resignFirstResponder];
    }
    return NO; // We do not want UITextField to insert line-breaks.
}
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        // revert back to the normal state.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}




- (IBAction)connexion:(id)sender
{
//if([[AppDelegate sharedAppDelegate]connected])
//{
//    //if(self.txt_mobile.text.length>0)
//    if ([[AppDelegate sharedAppDelegate]connected])
//    {
//     
//        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
//        NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
//        
//        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
//        [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
//        [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
//        if([strLoginType isEqualToString:@"manual"])
//            [dictParam setValue:self.txt_mobile.text forKey:PARAM_PHONE];
//        
//        [dictParam setValue:strLoginType forKey:PARAM_LOGIN_BY];
//        
//        if([strLoginType isEqualToString:@"facebook"])
//        {
//            [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
//        }
//        else if ([strLoginType isEqualToString:@"google"])
//        {
//            [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
//        }
//        else
//        {
//            [dictParam setValue:self.txt_passwd.text forKey:PARAM_PASSWORD];
//        }
//        
//        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
//        [afn getDataFromPath:FILE_LOGIN withParamData:dictParam withBlock:^(id response, NSError *error)
//         {
//             [[AppDelegate sharedAppDelegate]hideLoadingView];
//             
//             NSLog(@"Login Response ---> %@",response);
//             if (response)
//             {
//                 if([[response valueForKey:@"success"]boolValue])
//                 {
//                     NSString *strLog=[NSString stringWithFormat:@"%@ %@",NSLocalizedString(@"LOGIN_SUCCESS", nil),[response valueForKey:@"first_name"]];
//                     
//                     
//                     [APPDELEGATE showToastMessage:strLog];
//                     
//                     [APPDELEGATE hideHUDLoadingView];
//                     NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
//                     [pref setObject:response forKey:PREF_LOGIN_OBJECT];
//                     [pref setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
//                     [pref setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
//                     [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
//                     [pref setBool:YES forKey:PREF_IS_LOGIN];
//                     [pref synchronize];
//                     CommandPageViewController *log = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
//                     [self.navigationController pushViewController:log animated:YES];
//                 }
//                 else
//                 {
//                     
//                     
//                     UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//                     [alert show];
//                 }
//             }
//             
//         }];
//    }
//    else
//    {
//        if(self.txt_mobile.text.length==0)
//        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_EMAIL", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//            [alert show];
//        }
//        else
//        {
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:NSLocalizedString(@"PLEASE_PASSWORD", nil) delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    }
//}
//else
//{
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
//    [alert show];
//}
//
   

}

- (IBAction)forget_passwd:(id)sender
{
    ResetPasswdViewController *log = [self.storyboard instantiateViewControllerWithIdentifier:@"ResetPasswdViewController"];
    [self.navigationController pushViewController:log animated:YES];
    
}

- (IBAction)fb_login:(id)sender {
  //  [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOGIN", nil)];
    
    [FBSDKAccessToken setCurrentAccessToken:nil];
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *cookie in [storage cookies]) {
        NSString *domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:@"facebook"];
        if(domainRange.length > 0) {
            [storage deleteCookie:cookie];
        }
    }
    strLoginType=@"facebook";
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    loginManager.loginBehavior=FBSDKLoginBehaviorWeb;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"picture,first_name,last_name,email,name",@"fields",nil];
    
    [loginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] handler:^(FBSDKLoginManagerLoginResult *response, NSError *error)
     
     {
         
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
//                  strForEmail = [response valueForKey:@"email"];
//                  //NSString * loading = [NSString stringWithFormat:@"Loading"];
//                  [APPDELEGATE showHUDLoadingView:nil];
//                 [self connexion:nil];
//              }
//              else{
//                  
//              }
//          }];
//         
         
     }];
    
}

- (IBAction)back_btn:(id)sender {
//    SliderPagesViewController *back = [self.storyboard instantiateViewControllerWithIdentifier:@"SliderPagesViewController"];
//    [self.navigationController pushViewController:back animated:YES];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
