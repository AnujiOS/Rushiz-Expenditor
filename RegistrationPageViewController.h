//
//  RegistrationPageViewController.h
//  Ruchiz
//
//  Created by ganesh on 4/29/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RegistrationPageViewController;

@interface RegistrationPageViewController : UIViewController
- (IBAction)mobile_registration:(id)sender;
- (IBAction)fb_registration:(id)sender;

@property (weak, nonatomic) IBOutlet UINavigationBar *navigation_bar;
- (IBAction)back_btn:(id)sender;

@end
