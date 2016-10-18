//
//  AppDelegate.m
//  Ruchiz
//
//  Created by ganesh on 4/27/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleMaps/GoogleMaps.h>
#import "FacebookUtility.h"
#import "Constants.h"
#import "PayPalMobile.h"
#import "MFSideMenuContainerViewController.h"
#import <Stripe.h>
@import GoogleMaps;


@interface AppDelegate ()
{
    MFSideMenuContainerViewController *container;
}
@end

@implementation AppDelegate

@synthesize window,navigationController;

#pragma mark -
#pragma mark - UIApplication Delegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
   //[GMSServices provideAPIKey:@"AIzaSyDwTcU4CgAYzwRluvTXWJXztlCEZcCu5L0"];
    [application setStatusBarHidden:YES];

    [GMSServices provideAPIKey:Google_Map_Key];
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
//    if (StripePublishableKey) {
//        [Stripe setDefaultPublishableKey:StripePublishableKey];
//    }
    // Right, that is the point
    CLLocationCoordinate2D coordinate = [self getLocation];
    
    [window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    
    MFSideMenuContainerViewController *container = (MFSideMenuContainerViewController *)self.window.rootViewController;
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    container = (MFSideMenuContainerViewController *)self.window.rootViewController;
    UINavigationController *navigationController = [storyboard instantiateViewControllerWithIdentifier:@"navigationController"];
    UIViewController *leftSideMenuViewController = [storyboard instantiateViewControllerWithIdentifier:@"leftSideMenuViewController"];
    
    [container setLeftMenuViewController:leftSideMenuViewController];
    [container setCenterViewController:navigationController];
    
//    ViewController *view = (ViewController *)self.window.inputViewController;
//    view = (ViewController *)self.window.inputViewController;
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
//    {
//        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge) categories:nil]];
//        [[UIApplication sharedApplication] registerForRemoteNotifications];
//    }else {
//        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
//         (UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert)];
//    }
//    
//    if ([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]) {
//        
//        [self application:[UIApplication sharedApplication] didReceiveRemoteNotification:[launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]];
//    }
    if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
    {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge
                                                                                             |UIRemoteNotificationTypeSound
                                                                                             |UIRemoteNotificationTypeAlert) categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
    else
    {
        //register to receive notifications
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeSound;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:myTypes];
    }
   [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    
    /*
     UIImage *navBarBackgroundImage = [UIImage imageNamed:@"navigation_bg.png"];
     [[UINavigationBar appearance] setBackgroundImage:navBarBackgroundImage forBarMetrics:UIBarMetricsDefault];*/
    
#warning "Enter your credentials"
    //[PayPalMobile initializeWithClientIdsForEnvironments:@{  PayPalEnvironmentSandbox : @"AcIgmKQa_K6Mg00Lv7sJB-g4tWKYTmanUXRDFddbXjXl5_TA6JA4dwHUqLjcGYpX7nx0A49IJt8Wb2bt"}];
    [PayPalMobile initializeWithClientIdsForEnvironments:@{
                                                           PayPalEnvironmentProduction : @"access_token$sandbox$yx839rd8d29mrtwm$51c4005876cf995efc30a472dd20e972",
                                                           PayPalEnvironmentSandbox : @"AcIgmKQa_K6Mg00Lv7sJB-g4tWKYTmanUXRDFddbXjXl5_TA6JA4dwHUqLjcGYpX7nx0A49IJt8Wb2bt"
                                                           }];
    
// [[STPPaymentConfiguration sharedConfiguration] setPublishableKey:@"pk_test_6pRNASCoBOKtIshFeQd4XMUh"];
// [[STPPaymentConfiguration sharedConfiguration] setAppleMerchantIdentifier:@"your apple merchant identifier"];
    if (StripePublishableKey) {
        [Stripe setDefaultPublishableKey:StripePublishableKey];
    }

    return YES;
}
-(CLLocationCoordinate2D) getLocation
{
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)];
    [locationManager requestWhenInUseAuthorization];
    [locationManager requestAlwaysAuthorization];
    [locationManager startUpdatingLocation];
    CLLocation *location = [locationManager location];
    CLLocationCoordinate2D coordinate = [location coordinate];
    
    return coordinate;
}


#pragma mark -
#pragma mark - Push Notification Methods

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    //register to receive notifications
    [application registerForRemoteNotifications];
}
//For interactive notification only
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    //handle the actions
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
-(void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
    NSString* strdeviceToken = [[NSString alloc]init];
    strdeviceToken=[self stringWithDeviceToken:deviceToken];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:strdeviceToken forKey:PREF_DEVICE_TOKEN];
    
    [prefs synchronize];
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Token " message:strdeviceToken delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
    //[alert show];
    NSLog(@"My token is: %@",strdeviceToken);
}
- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    NSLog(@"Failed to get token, error: %@", error);
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setObject:@"121212121212121212" forKey:PREF_DEVICE_TOKEN];
    [prefs synchronize];
}
+(AppDelegate *)sharedAppDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
    NSMutableDictionary *msg=[aps valueForKey:@"title"];
//    dictBillInfo=[msg valueForKey:@"bill"];
//    is_walker_started=[[msg valueForKey:@"is_walker_started"] intValue];
//    is_walker_arrived=[[msg valueForKey:@"is_walker_arrived"] intValue];
//    is_started=[[msg valueForKey:@"is_walk_started"] intValue];
//    is_completed=[[msg valueForKey:@"is_completed"] intValue];
//    is_dog_rated=[[msg valueForKey:@"is_walker_rated"] intValue];
    if (dictBillInfo!=nil)
    {
//        if (vcProvider)
//        {
//            [vcProvider.timerForTimeAndDistance invalidate];
//            vcProvider.timerForCheckReqStatuss=nil;
//            [vcProvider checkDriverStatus];
//        }
//        else
//        {
//            
//        }
        
    }
    
    //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    //[alert show];
    
}
-(void)handleRemoteNitification:(UIApplication *)application userInfo:(NSDictionary *)userInfo
{
    NSMutableDictionary *aps=[userInfo valueForKey:@"aps"];
    
    NSMutableDictionary *msg=[aps valueForKey:@"message"];
    dictBillInfo=[msg valueForKey:@"bill"];
    is_walker_started=[[msg valueForKey:@"is_walker_started"] intValue];
    is_walker_arrived=[[msg valueForKey:@"is_walker_arrived"] intValue];
    is_started=[[msg valueForKey:@"is_walk_started"] intValue];
    is_completed=[[msg valueForKey:@"is_completed"] intValue];
    is_dog_rated=[[msg valueForKey:@"is_walker_rated"] intValue];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@",msg] message:nil delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:@"cancel", nil];
    [alert show];
//    if (vcProvider)
//    {
//        [vcProvider checkDriverStatus];
//    }
}
- (NSString*)stringWithDeviceToken:(NSData*)deviceToken
{
    const char* data = [deviceToken bytes];
    NSMutableString* token = [NSMutableString string];
    
    for (int i = 0; i < [deviceToken length]; i++)
    {
        [token appendFormat:@"%02.2hhX", data[i]];
    }
    return [token copy] ;
}
-(void) showHUDLoadingView:(NSString *)strTitle
{
    if (HUD==nil) {
        HUD = [[MBProgressHUD alloc] initWithView:self.window];
        [self.window addSubview:HUD];
    }
    
    //HUD.delegate = self;
    //HUD.labelText = [strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    HUD.detailsLabelText=[strTitle isEqualToString:@""] ? @"Loading...":strTitle;
    [HUD show:YES];
}

-(void) hideHUDLoadingView
{
    //[HUD removeFromSuperview];
    [HUD hide:YES];
}

-(void)showToastMessage:(NSString *)message
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.window
                                              animated:YES];
    
    // Configure for text only and offset down
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = message;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.0];
}
#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}
#pragma mark -
#pragma mark - Directory Path Methods

- (NSString *)applicationCacheDirectoryString
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cacheDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return cacheDirectory;
}
- (BOOL)connected
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [reachability currentReachabilityStatus];
    return networkStatus != NotReachable;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}


- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    BOOL handled = [[FBSDKApplicationDelegate sharedInstance] application:application
                                                                  openURL:url
                                                        sourceApplication:sourceApplication
                                                               annotation:annotation
                    ];
    // Add any custom logic here.
    return handled;
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
     [FBSDKAppEvents activateApp];
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
//- (NSString *)applicationCacheDirectoryString
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//    NSString *cacheDirectory = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
//    return cacheDirectory;
//}
#pragma mark -
#pragma mark - Loading View

-(void)showLoadingWithTitle:(NSString *)title
{
    if (viewLoading==nil) {
        viewLoading=[[UIView alloc]initWithFrame:self.window.bounds];
        viewLoading.backgroundColor=[UIColor whiteColor];
        viewLoading.alpha=0.6f;
        UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake((viewLoading.frame.size.width-88)/2, ((viewLoading.frame.size.height-30)/2)-30, 88, 30)];
        img.backgroundColor=[UIColor clearColor];
        
        img.animationImages=[NSArray arrayWithObjects:[UIImage imageNamed:@"loading_1.png"],[UIImage imageNamed:@"loading_2.png"],[UIImage imageNamed:@"loading_3.png"], nil];
        img.animationDuration = 1.0f;
        img.animationRepeatCount = 0;
        [img startAnimating];
        [viewLoading addSubview:img];
        
        UITextView *txt=[[UITextView alloc]initWithFrame:CGRectMake((viewLoading.frame.size.width-250)/2, ((viewLoading.frame.size.height-60)/2)+20, 250, 60)];
        txt.textAlignment=NSTextAlignmentCenter;
        txt.backgroundColor=[UIColor clearColor];
        txt.text=[title uppercaseString];
        txt.font=[UIFont systemFontOfSize:16];
        txt.userInteractionEnabled=FALSE;
        txt.scrollEnabled=FALSE;
        //txt.textColor=[UberStyleGuide colorDefault];
        [viewLoading addSubview:txt];
    }
    
    [self.window addSubview:viewLoading];
    [self.window bringSubviewToFront:viewLoading];
}

-(void)hideLoadingView
{
    if (viewLoading) {
        [viewLoading removeFromSuperview];
        viewLoading=nil;
    }
}


@end
