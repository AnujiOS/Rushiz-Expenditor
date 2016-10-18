//
//  SlideMenuViewController.m
//  Ruchiz
//
//  Created by ganesh on 6/14/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "SlideMenuViewController.h"
#import "ProfileVCViewController.h"
#import "MFSideMenu.h"
#import "MFSideMenuContainerViewController.h"
#import "CommandPageViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UtilityClass.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import "HistoriqueVC.h"
#import "AjouterPaymentVC.h"
#import "ParrainageVC.h"
#import "ReglagesVC.h"
#import "AideVC.h"
#import "LoginPageViewController.h"
#import "PaiementVC.h"
@interface SlideMenuViewController ()
{
    NSDictionary *view_cart;
    NSString *userImageURL;
}
@end

@implementation SlideMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSTimer *atimer =[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(viewWillAppear:) userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self image];
}
-(void)viewDidAppear:(BOOL)animated
{
  
}

- (IBAction)profil:(id)sender {
    ProfileVCViewController *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"ProfileVCViewController"];
    [self.navigationController pushViewController:pv animated:YES];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controller = [NSArray arrayWithObject:pv];
    navigationController.viewControllers=controller;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];

}

- (IBAction)vos_factures:(id)sender
{
    HistoriqueVC *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"HistoriqueVC"];
    [self.navigationController pushViewController:pv animated:YES];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controller = [NSArray arrayWithObject:pv];
    navigationController.viewControllers=controller;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    
}

- (IBAction)moyens_de_paiements:(id)sender//AjouterPaymentVC
{
    PaiementVC *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"PaiementVC"];
    [self.navigationController pushViewController:pv animated:YES];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controller = [NSArray arrayWithObject:pv];
    navigationController.viewControllers=controller;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)notification:(id)sender
{
    
}

- (IBAction)offers:(id)sender//ParrainageVC
{
    ParrainageVC *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"ParrainageVC"];
    [self.navigationController pushViewController:pv animated:YES];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controller = [NSArray arrayWithObject:pv];
    navigationController.viewControllers=controller;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)reglages:(id)sender//ReglagesVC
{
    ReglagesVC *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"ReglagesVC"];
    [self.navigationController pushViewController:pv animated:YES];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controller = [NSArray arrayWithObject:pv];
    navigationController.viewControllers=controller;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)centre_daide:(id)sender//AideVC
{
    AideVC *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"AideVC"];
    [self.navigationController pushViewController:pv animated:YES];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controller = [NSArray arrayWithObject:pv];
    navigationController.viewControllers=controller;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
}

- (IBAction)exit:(id)sender
{
    
//    CommandPageViewController *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
//    [self.navigationController pushViewController:pv animated:YES];
//    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
//    NSArray *controller = [NSArray arrayWithObject:pv];
//    navigationController.viewControllers=controller;
//    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Déconnection" message:@"Etes vous sure de vouloir vous déconnecter ?"                                                delegate:self cancelButtonTitle:@"NON" otherButtonTitles: @"OUI", nil];
    alert.tag = 100;
    [alert show];
    
}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    
    // Is this my Alert View?
    if (alertView.tag == 100)
    {
        
        
        
        if (buttonIndex == 0) {// 1st Other Button
            
            
            
        }
        else if (buttonIndex == 1) {// 2nd Other Button
            
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoginStatus"];
                LoginPageViewController *pv = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPageViewController"];
                [self.navigationController pushViewController:pv animated:YES];
                UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
                NSArray *controller = [NSArray arrayWithObject:pv];
                navigationController.viewControllers=controller;
                [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
        }
        
    }
    else {
        //No
        // Other Alert View
        
    }
    
}

- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage{
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    // [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:kCIInputRadiusKey];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    //[filter setValue:@(radius) forKey:kCIInputRadiusKey];
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    return retVal;
}

-(void)image{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if ([[AppDelegate sharedAppDelegate]connected])
        {

            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *picture =[pref objectForKey:PREF_IMAGES];
            if (picture == nil)
            {
                [self profile_view];
            }
            else
            {
                [self.profile_pic sd_setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"no_img-2"]];
                [self.profile_bg_pic sd_setImageWithURL:[NSURL URLWithString:picture] placeholderImage:[UIImage imageNamed:@"no_img-2"]];
                userImageURL = [NSString stringWithFormat:@"%@",picture];
                self.profile_pic.layer.cornerRadius = self.profile_pic.frame.size.width / 2;
                self.profile_pic.clipsToBounds = YES;
                self.profile_pic.layer.borderWidth = 1.0f;
                self.profile_pic.layer.borderColor = [UIColor whiteColor].CGColor;
                 self.user_name.text = [NSString stringWithFormat:@"%@ %@",[view_cart valueForKey:@"first_name"],[view_cart valueForKey:@"last_name"]];
                self.profile_bg_pic.image = [self blurredImageWithImage:self.profile_bg_pic.image];

            }
        }
    }
}
-(void)profile_view
{
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
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_PROFILE_VIEW withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         view_cart = [[NSDictionary alloc]init];
                         view_cart = [response valueForKey:@"result"];
                         [self.profile_pic sd_setImageWithURL:[NSURL URLWithString:[view_cart valueForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"no_img-2"]];
                         [self.profile_bg_pic sd_setImageWithURL:[NSURL URLWithString:[view_cart valueForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"no_img-2"]];
                         self.user_name.text = [NSString stringWithFormat:@"%@ %@",[view_cart valueForKey:@"first_name"],[view_cart valueForKey:@"last_name"]];
                         userImageURL = [NSString stringWithFormat:@"%@",[view_cart valueForKey:@"picture"]];
                         self.profile_pic.layer.cornerRadius = self.profile_pic.frame.size.width / 2;
                         self.profile_pic.clipsToBounds = YES;
                         self.profile_pic.layer.borderWidth = 1.0f;
                         self.profile_pic.layer.borderColor = [UIColor whiteColor].CGColor;
                         self.profile_bg_pic.image = [self blurredImageWithImage:self.profile_bg_pic.image];
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

@end
