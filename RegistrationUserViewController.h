//
//  RegistrationUserViewController.h
//  Ruchiz
//
//  Created by ganesh on 4/29/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RegistrationPageViewController.h"

@interface RegistrationUserViewController : UIViewController<UIScrollViewDelegate,UITextFieldDelegate,UIGestureRecognizerDelegate>
- (IBAction)particulier:(id)sender;
- (IBAction)enterprice:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *txt_mobile;
@property (weak, nonatomic) IBOutlet UITextField *txt_password;
- (IBAction)acc_creation:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *first_name;
@property (weak, nonatomic) IBOutlet UITextField *last_name;
@property (weak, nonatomic) IBOutlet UIImageView *last_name_line;
@property (weak, nonatomic) IBOutlet UIImageView *first_name_line;

@property(strong,nonatomic)NSString *flag;
@property (weak, nonatomic) IBOutlet UITextField *txt_email;
@property (weak, nonatomic) IBOutlet UITextField *txt_confirm_passd;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollview;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigation_bar;
- (IBAction)back_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *email_line;
@property (weak, nonatomic) IBOutlet UIImageView *phone_line;
@property (weak, nonatomic) IBOutlet UIImageView *paswd_line;
@property (weak, nonatomic) IBOutlet UIImageView *confrim_pass_line;
- (IBAction)checkedBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *checkBox_text;
@property (weak, nonatomic) IBOutlet UIButton *Btn_particular;
@property (weak, nonatomic) IBOutlet UIButton *Btn_enterprise;
@property (weak, nonatomic) IBOutlet UIButton *Btn_checkBox;

@end
