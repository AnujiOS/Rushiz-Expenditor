//
//  ProfileVCViewController.h
//  Ruchiz
//
//  Created by ganesh on 6/15/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileVCViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *profile_bg_img;
@property (weak, nonatomic) IBOutlet UIImageView *profile_img;
@property (weak, nonatomic) IBOutlet UILabel *Profile_user_name;
@property (weak, nonatomic) IBOutlet UITextField *first_name;
@property (weak, nonatomic) IBOutlet UITextField *last_name;
@property (weak, nonatomic) IBOutlet UITextField *email_id;
@property (weak, nonatomic) IBOutlet UITextField *phone_number;
@property (weak, nonatomic) IBOutlet UITextField *user_address;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;

- (IBAction)back_btn:(id)sender;
- (IBAction)camera_image:(id)sender;
- (IBAction)first_name_update:(id)sender;
- (IBAction)last_name_update:(id)sender;
- (IBAction)address_update:(id)sender;
- (IBAction)save:(id)sender;

@end
