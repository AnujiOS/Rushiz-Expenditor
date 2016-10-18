//
//  LoginPageViewController.h
//  Ruchiz
//
//  Created by ganesh on 4/28/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseVC.h"
#import "Reachability.h"

@interface LoginPageViewController : UIViewController<UITextFieldDelegate,UIGestureRecognizerDelegate,UIScrollViewDelegate>
- (IBAction)connexion:(id)sender;
- (IBAction)forget_passwd:(id)sender;
- (IBAction)fb_login:(id)sender;
@property NetworkStatus internetConnectionStatus;
@property (weak, nonatomic) IBOutlet UITextField *txt_mobile;
@property (weak, nonatomic) IBOutlet UITextField *txt_passwd;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationbar;
- (IBAction)back_btn:(id)sender;


@end
