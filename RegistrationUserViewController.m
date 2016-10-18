//
//  RegistrationUserViewController.m
//  Ruchiz
//
//  Created by ganesh on 4/29/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "RegistrationUserViewController.h"
#import "RegistrationPageViewController.h"
#import "WebServiceViewController.h"
#import "CommandPageViewController.h"
#import "FacebookUtility.h"
#import "AppDelegate.h"
#import "AFNHelper.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <AVFoundation/AVBase.h>
#import <AVFoundation/AVFoundation.h>
#import "UtilityClass.h"
#import "Constants.h"
#import "UIView+Utils.h"
#import "RegistrationPageViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "ViewController.h"
#define kOFFSET_FOR_KEYBOARD 140.0
@interface RegistrationUserViewController ()<UITextFieldDelegate,UISearchBarDelegate>
{
    int i;
    int owner_type;
    int is_rest;
    NSString *type;
    NSString *rest;
    AppDelegate *appDelegate;
    NSString *strImageData,*strForRegistrationType,*strForSocialId,*strForToken,*strForID,*Firstname,*Lastname,*strForEmail,*strUserPhoto,*userImageURL;
    UIImage *selectedImage_particular;
    UIImage *unselectedImage_particular;
    UIImage *selectedImage_enterprise;
    UIImage *unselectedImage_enterprise;
    UIImage *checkedBox;
    UIImage *uncheckedBox;
    UIImage *yourimg;
}
@end

@implementation RegistrationUserViewController
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
- (void)viewDidLoad {
    [super viewDidLoad];
    
    ////////////////////
    selectedImage_particular = [UIImage imageNamed:@"selected_parti.png"];
    unselectedImage_particular = [UIImage imageNamed:@"parti.png"];
    selectedImage_enterprise = [UIImage imageNamed:@"selected_enter.png"];
    unselectedImage_enterprise = [UIImage imageNamed:@"enter.png"];
    checkedBox = [UIImage imageNamed:@"checked_img.png"];
    uncheckedBox = [UIImage imageNamed:@"uncheck_img.png"];
    
    self.Btn_checkBox.hidden = YES;
    self.checkBox_text.hidden = YES;
    is_rest = 0;
    rest = [NSString stringWithFormat:@"%d",is_rest];
    i = 0;
    type = [NSString stringWithFormat:@"%d",i ];
    ///////////////////
    
    strForRegistrationType=@"manual";
    [self.navigation_bar setBackgroundImage:[UIImage new]
                              forBarMetrics:UIBarMetricsDefault];
    self.navigation_bar.shadowImage = [UIImage new];
    self.navigation_bar.translucent = YES;
    [self.txt_email setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txt_mobile setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txt_password setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.txt_confirm_passd setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.first_name setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.last_name setValue:[UIColor grayColor] forKeyPath:@"_placeholderLabel.textColor"];
    [self.first_name setReturnKeyType:UIReturnKeyNext];
    [self.last_name setReturnKeyType:UIReturnKeyNext];
    [self.txt_email setReturnKeyType:UIReturnKeyNext];
    [self.txt_mobile setReturnKeyType:UIReturnKeyNext];
    [self.txt_password setReturnKeyType:UIReturnKeyNext];
    [self.txt_confirm_passd setReturnKeyType:UIReturnKeyGo];
    
    [self.first_name addTarget:self action:@selector(text_first:) forControlEvents:UIControlEventEditingDidEndOnExit ];
    [self.last_name addTarget:self action:@selector(text_last:) forControlEvents:UIControlEventEditingDidEndOnExit ];
    [self.txt_email addTarget:self action:@selector(text_email:) forControlEvents:UIControlEventEditingDidEndOnExit ];
    [self.txt_mobile addTarget:self action:@selector(text_mobile:) forControlEvents:UIControlEventEditingDidEndOnExit ];
    [self.txt_password addTarget:self action:@selector(text_password:) forControlEvents:UIControlEventEditingDidEndOnExit ];
    [self.txt_confirm_passd addTarget:self action:@selector(text_conf_password:) forControlEvents:UIControlEventEditingDidEndOnExit ];
        UITapGestureRecognizer *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTapGesture:)];
    singleTapGestureRecognizer.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTapGestureRecognizer];
    
    if ([_flag isEqualToString:@"Facebook"] ) {
        self.first_name.hidden =YES;
        self.last_name.hidden = YES;
        self.txt_password.hidden = YES;
        self.txt_email.hidden= YES;
        self.txt_mobile.enabled = NO;
        self.email_line.hidden = YES;
        self.paswd_line.hidden = YES;
        self.confrim_pass_line.hidden = YES;
        self.txt_confirm_passd.hidden = YES;
        self.first_name_line.hidden = YES;
        self.last_name_line.hidden = YES;
         [self fblogin];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please Enter Mobile Number" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//        [alert show];
//        _txt_mobile.text =@"";
//        _txt_password.text = @"************";
        
        
    }
    else if([_flag isEqualToString:@"Manual"]){
        self.first_name.hidden = NO;
        self.last_name.hidden = NO;
        self.txt_password.hidden = NO;
        self.txt_email.hidden= NO;
        self.txt_mobile.enabled = YES;
        self.email_line.hidden = NO;
        self.paswd_line.hidden = NO;
        self.first_name_line.hidden = NO;
        self.last_name_line.hidden = NO;
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"S'il vous plaît Entrez le numéro d'enregistrement mobile" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//        [alert show];
    }
    
    
}
-(void)viewWillAppear:(BOOL)animated
{
   // [[FacebookUtility sharedObject] logOutFromFacebook];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];

}
- (void)viewDidAppear:(BOOL)animated
{
    //[self.btnNav_Register setTitle:NSLocalizedString(@"Register", nil) forState:UIControlStateNormal];
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];

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
    self.scrollview.frame = CGRectMake(self.scrollview.frame.origin.x,
                                   self.scrollview.frame.origin.y,
                                   self.scrollview.frame.size.width,
                                   self.scrollview.frame.size.height - 215 + 50);   //resize
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    //keyboard will hide
    self.scrollview.frame = CGRectMake(self.scrollview.frame.origin.x,
                                   self.scrollview.frame.origin.y,
                                   self.scrollview.frame.size.width,
                                   self.scrollview.frame.size.height + 215 - 50); //resize
    
    
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




-(void)SetLocalization
{
    
    self.txt_mobile.placeholder=NSLocalizedString(@"MOBILE*", nil);
    self.txt_password.placeholder=NSLocalizedString(@"PASSWORD*", nil);
   
    
}
-(BOOL)text_first:(id)sender
{
    [self.first_name resignFirstResponder];
    [self.last_name becomeFirstResponder];
    return YES;
}
-(BOOL)text_last:(id)sender
{
    [self.last_name resignFirstResponder];
    [self.txt_email becomeFirstResponder];
    return YES;
}
-(BOOL)text_email:(id)sender
{
    [self.txt_email resignFirstResponder];
    [self.txt_mobile becomeFirstResponder];
    return YES;
}
-(BOOL)text_mobile:(id)sender
{
    if ([_flag isEqualToString:@"Facebook"] )
    {
        [self.txt_mobile resignFirstResponder];
        [self acc_creation:sender];
    }
    else{
    [self.txt_mobile resignFirstResponder];
    [self.txt_password becomeFirstResponder];
    }
    return YES;
}

-(BOOL)text_password:(id)sender{
    [self.txt_password resignFirstResponder];
    [self.txt_confirm_passd becomeFirstResponder];
       return YES;
    }
-(BOOL)text_conf_password:(id)sender{
    [self acc_creation:sender];
    return NO;
}
#pragma mark -
#pragma mark - Memory Mgmt
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}

#pragma mark -
#pragma mark - TextField Delegate
-(void)handleSingleTapGesture:(UITapGestureRecognizer *)tapGestureRecognizer;
{
    [self.txt_mobile resignFirstResponder];
    [self.txt_password resignFirstResponder];
    [self.view endEditing:YES];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
    [self.txt_mobile resignFirstResponder];
    [self.txt_password resignFirstResponder];
   
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)particulier:(id)sender {
    
    is_rest = 0;
    rest = [NSString stringWithFormat:@"%d",is_rest];
    i = 0;
   type = [NSString stringWithFormat:@"%d",i ];
//    if ([sender isSelected]) {
//        
//        [sender setImage:selectedImage_particular forState:UIControlStateNormal];
//        [sender setSelected:NO];
//    }
//    else
//    {
//        [sender setImage:unselectedImage_particular forState:UIControlStateSelected];
//        
//                       [sender setSelected:YES];
//        
//    }
    [sender setImage:selectedImage_particular forState:UIControlStateNormal];
    [self.Btn_enterprise setImage:unselectedImage_enterprise forState:UIControlStateNormal];
    self.Btn_checkBox.hidden = YES;
    self.checkBox_text.hidden = YES;
}

- (IBAction)enterprice:(id)sender {
    is_rest = 0;
    rest = [NSString stringWithFormat:@"%d",is_rest];
    i = 1;
    type = [NSString stringWithFormat:@"%d",i ];
//    if ([sender isSelected]) {
//        
//        [sender setImage:selectedImage_enterprise forState:UIControlStateNormal];
//        [sender setSelected:NO];
//    }
//    else
//    {
//        [sender setImage:unselectedImage_enterprise forState:UIControlStateSelected];
//        
//        [sender setSelected:YES];
//        
//    }
    [sender setImage:selectedImage_enterprise forState:UIControlStateNormal];
    [self.Btn_particular setImage:unselectedImage_particular forState:UIControlStateNormal];
    self.Btn_checkBox.hidden = NO;
    self.checkBox_text.hidden = NO;
}

#pragma mark -
#pragma mark - UIButton Action
- (IBAction)acc_creation:(id)sender {
   
    if ([_flag isEqualToString:@"Facebook"]) {
       // [self fblogin];
       
        if ([self.txt_mobile.text  isEqual: @""]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alerte"
                                                           message:@"S'il vous plaît entrer le numéro de téléphone portable."
                                                          delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        else if (![self.txt_mobile.text  isEqual: @""])
        {
             [self FBwithlogn];
        }
        
       
    }
    
    else if ([_flag isEqualToString:@"Manual"]){
        
            
            NSString*txtUserPass = [NSString stringWithFormat:@"%@",self.txt_password.text];
            NSString*txtUserConfirmPass = [NSString stringWithFormat:@"%@",self.txt_confirm_passd.text];
            
            if ([txtUserPass isEqualToString:txtUserConfirmPass])
            {
                //[self userinformation];
                [self FBwithlogn];
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Alerte"
                                                               message:@"Votre mots de passes diffèrent"
                                                              delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                //[self.txt_password.text becomeFirstResponder];
                
                
            }
            
            
        }

    
    }


-(void)fblogin{
    strForRegistrationType=@"facebook";
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"SocialFBClicked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"SocialDBClicked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    loginManager.loginBehavior=FBSDKLoginBehaviorWeb;
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"picture,first_name,last_name,email,name",@"fields",nil];
    
    [loginManager logInWithReadPermissions:@[@"public_profile", @"email", @"user_friends",@"user_photos"] handler:^(FBSDKLoginManagerLoginResult *response, NSError *error)
     
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
//                  Firstname = [response valueForKey:@"first_name"];
//                  Lastname = [response valueForKey:@"last_name"];
//                  strForEmail = [response valueForKey:@"email"];
//                  strForSocialId = [response valueForKey:@"id"];
//                  userImageURL = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=large", [response objectForKey:@"id"]];
//                  strUserPhoto = [[[response valueForKey:@"picture"]valueForKey:@"data"]valueForKey:@"url"];
//                  
//                  //[self FBwithlogn];
//                  
//                                    self.txt_mobile.enabled = YES;
//                  
//              }
//              else{
//                  UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"S'il vous plaît Entrez le numéro d'enregistrement mobile" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
//                  [alert show];
//
//              }
//          }];
         
         
     }];
    

}
//-(void)FBwithlogn{
//    
//    if([[AppDelegate sharedAppDelegate]connected]){
//        [[UtilityClass sharedObject]isValidEmailAddress:strForEmail];
//        NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
//        NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
//        
//        NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
//        
//        NSString *First_name = [NSString stringWithFormat:@"%@",self.first_name.text];
//        NSString *Last_name = [NSString stringWithFormat:@"%@",self.last_name.text];
//        
//        if ([_flag isEqualToString:@"Facebook"]) {
//            [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
//            [dictParam setValue:Firstname forKey:PARAM_FIRST_NAME];
//            [dictParam setValue:Lastname forKey:PARAM_LAST_NAME];
//            [dictParam setObject:userImageURL forKey:PARAM_PICTURE];
//            self.txt_email.text = strForEmail;
//        }
//        else if([_flag isEqualToString:@"Manual"]){
//            strForEmail = [NSString stringWithFormat:@"%@",self.txt_email.text];
//            [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
//            [dictParam setValue:First_name forKey:PARAM_FIRST_NAME];
//            [dictParam setValue:Last_name forKey:PARAM_LAST_NAME];
//            
//
//        }
////        [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
////        [dictParam setValue:Firstname forKey:PARAM_FIRST_NAME];
////        [dictParam setValue:Lastname forKey:PARAM_LAST_NAME];
//        NSString *Mobile_number = [NSString stringWithFormat:@"%@",self.txt_mobile.text];
//        NSString *strForPassword = [NSString stringWithFormat:@"%@",self.txt_password.text];
//        [dictParam setValue:Mobile_number forKey:PARAM_PHONE];//strnumber
//        [dictParam setValue:type forKey:@"owner_type"];
//        [dictParam setValue:rest forKey:@"is_rest"];
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
//            [dictParam setValue:strForPassword forKey:PARAM_PASSWORD];
//        UIImage *yourimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]]];
//        AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
//        [afn getDataFromPath:FILE_REGISTER withParamDataImage:dictParam andImage:yourimg withBlock:^(id response, NSError *error) {
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
//                    CommandPageViewController *log = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
//                    [self.navigationController pushViewController:log animated:YES];
//                    
//                    //  [self performSegueWithIdentifier:SEGUE_TO_APPLY_REFERRAL_CODE sender:self];
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
//            
//        }];
//    }
//}
-(void)FBwithlogn{
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
        [APPDELEGATE showHUDLoadingView:@"Loading..."];
        if([[AppDelegate sharedAppDelegate]connected])
        {
            //if(self.txt_mobile.text.length>0)
            if ([[AppDelegate sharedAppDelegate]connected])
            {
                [[UtilityClass sharedObject]isValidEmailAddress:strForEmail];
                NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
                
                NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                
                NSString *First_name = [NSString stringWithFormat:@"%@",self.first_name.text];
                NSString *Last_name = [NSString stringWithFormat:@"%@",self.last_name.text];
                NSString *Mobile_number = [NSString stringWithFormat:@"%@",self.txt_mobile.text];
                NSString *strForPassword = [NSString stringWithFormat:@"%@",self.txt_password.text];
                if ([_flag isEqualToString:@"Facebook"]) {
                    [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
                    [dictParam setValue:Firstname forKey:PARAM_FIRST_NAME];
                    [dictParam setValue:Lastname forKey:PARAM_LAST_NAME];
                    [dictParam setObject:userImageURL forKey:PARAM_PICTURE];
                    self.txt_email.text = strForEmail;
                    yourimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]]];
                    [dictParam setValue:yourimg forKey:PARAM_PICTURE];
                }
                else if([_flag isEqualToString:@"Manual"]){
                    strForEmail = [NSString stringWithFormat:@"%@",self.txt_email.text];
                    [dictParam setValue:strForEmail forKey:PARAM_EMAIL];
                    [dictParam setValue:First_name forKey:PARAM_FIRST_NAME];
                    [dictParam setValue:Last_name forKey:PARAM_LAST_NAME];
                    
                    [dictParam setValue:@"" forKey:PARAM_PICTURE];
                }
                
                [dictParam setValue:Mobile_number forKey:PARAM_PHONE];//strnumber
                [dictParam setValue:type forKey:@"owner_type"];
                [dictParam setValue:rest forKey:@"is_rest"];
                [dictParam setValue:strDeviceId forKey:PARAM_DEVICE_TOKEN];
                [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
                [dictParam setValue:@"" forKey:PARAM_BIO];
                [dictParam setValue:@"" forKey:PARAM_ADDRESS];
                [dictParam setValue:@"" forKey:PARAM_STATE];
                [dictParam setValue:@"" forKey:PARAM_COUNTRY];
                [dictParam setValue:@"" forKey:PARAM_ZIPCODE];
                [dictParam setValue:strForRegistrationType forKey:PARAM_LOGIN_BY];
                
                if([strForRegistrationType isEqualToString:@"facebook"])
                    [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
                else if ([strForRegistrationType isEqualToString:@"google"])
                    [dictParam setValue:strForSocialId forKey:PARAM_SOCIAL_UNIQUE_ID];
                else
                    [dictParam setValue:strForPassword forKey:PARAM_PASSWORD];
//                yourimg = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:userImageURL]]];
                
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                if (yourimg != nil)
                {
                    [afn getDataFromPath:FILE_REGISTER withParamDataImage:dictParam andImage:yourimg withBlock:^(id response, NSError *error)
                     {
                         [[AppDelegate sharedAppDelegate]hideLoadingView];
                         
                         NSLog(@"Validation Response ---> %@",response);
                         if (response)
                         {
                             if([[response valueForKey:@"success"]boolValue])
                             {
                                 [APPDELEGATE showToastMessage:NSLocalizedString(@"REGISTER_SUCCESS", nil)];
                                 strForID=[response valueForKey:@"id"];
                                 strForToken=[response valueForKey:@"token"];
                                 [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                                 
                                 [pref setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                                 [pref setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
                                 [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                                 [pref setBool:YES forKey:PREF_IS_LOGIN];
                                 [pref synchronize];
                                 CommandPageViewController *log = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
                                 [self.navigationController pushViewController:log animated:YES];
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
                else if (yourimg == nil)
                {
                    [afn getDataFromPath:FILE_REGISTER withParamData:dictParam withBlock:^(id response, NSError *error)
                     {
                         [[AppDelegate sharedAppDelegate]hideLoadingView];
                         
                         NSLog(@"Validation Response ---> %@",response);
                         if (response)
                         {
                             if([[response valueForKey:@"success"]boolValue])
                             {
                                 [APPDELEGATE showToastMessage:NSLocalizedString(@"REGISTER_SUCCESS", nil)];
                                 strForID=[response valueForKey:@"id"];
                                 strForToken=[response valueForKey:@"token"];
                                 [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                                 
                                 [pref setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                                 [pref setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
                                 [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                                 [pref setBool:YES forKey:PREF_IS_LOGIN];
                                 [pref synchronize];
                                 CommandPageViewController *log = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
                                 [self.navigationController pushViewController:log animated:YES];
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

- (IBAction)back_btn:(id)sender {
//    RegistrationPageViewController *back = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationPageViewController"];
//    [self.navigationController pushViewController:back animated:YES];
     [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)checkedBtn:(UIButton *)sender
{
    if ([sender isSelected]) {
        is_rest = 0;
        rest = [NSString stringWithFormat:@"%d",is_rest];
        [sender setImage:uncheckedBox forState:UIControlStateNormal];
        [sender setSelected:NO];
    }
    else
    {
        is_rest = 1;
        rest = [NSString stringWithFormat:@"%d",is_rest];
        [sender setImage:checkedBox
                forState:UIControlStateSelected];
        
        [sender setSelected:YES];
        
    }

}
@end
