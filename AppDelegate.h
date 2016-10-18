//
//  AppDelegate.h
//  Ruchiz
//
//  Created by ganesh on 4/27/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Reachability.h"
#import "MFSideMenu.h"
@class MBProgressHUD;
@import GoogleMaps;

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *HUD;
    UIView *viewLoading;
     UINavigationController *navigationController;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
}
+(AppDelegate *)sharedAppDelegate;

@property (strong, nonatomic) UIWindow *window;
@property(strong,nonatomic)UINavigationController *navigationController;

-(void) showHUDLoadingView:(NSString *)strTitle;
-(void) hideHUDLoadingView;
-(void)showToastMessage:(NSString *)message;

-(void)showLoadingWithTitle:(NSString *)title;
-(void)hideLoadingView;
-(id)setBoldFontDiscriptor:(id)objc;

- (void)userLoggedIn;
- (NSString *)applicationCacheDirectoryString;
- (BOOL)connected;


@end

