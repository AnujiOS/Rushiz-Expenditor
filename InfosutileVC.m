//
//  InfosutileVC.m
//  Ruchiz
//
//  Created by mac on 9/2/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "InfosutileVC.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "Order_CartViewController.h"
#define kOFFSET_FOR_KEYBOARD 80.0

@interface InfosutileVC ()<UITextFieldDelegate,UITextViewDelegate>
{
    NSString *details;
    NSString *phone_number;
}
@end

@implementation InfosutileVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.aTextfieldTelephone setValue:[UIColor lightGrayColor]
                    forKeyPath:@"_placeholderLabel.textColor"];
    self.aDetailtextfeild.delegate = self;
    self.aTextfieldTelephone.delegate = self;
    
    [self.aTextfieldTelephone setKeyboardType:UIKeyboardTypeNumberPad];
    details = [[NSUserDefaults standardUserDefaults ]stringForKey:@"tempo_details"];
    phone_number = [[NSUserDefaults standardUserDefaults]stringForKey:@"tempo_phone"];
    
    self.aDetailtextfeild.text = [NSString stringWithFormat:@"%@",details];
    self.aTextfieldTelephone.text = [NSString stringWithFormat:@"%@",phone_number];
    [self.aDetailtextfeild setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    //self.aDetailtextfeild.textColor = [UIColor lightGrayColor];
    self.aDetailtextfeild.delegate = self;
    if(self.aDetailtextfeild.text.length == 0)
    {
        self.aDetailtextfeild.textColor = [UIColor lightGrayColor];
        // self.aDetailtextfeild.textColor = [UIColor colorWithRed:225 green:215 blue:0 alpha:1.0];
        [self.aDetailtextfeild setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.aDetailtextfeild.text = @"Noter toute info utile pour le coursier N° batiment, étage, code d'accès immeuble, N° porte ou tout autre type de commentaire";
        [self.aDetailtextfeild resignFirstResponder];
    }

    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL) textViewShouldBeginEditing:(UITextView *)textView
{
    self.aDetailtextfeild.text = @"";
    
    self.aDetailtextfeild.textColor = [UIColor colorWithRed:242 green:213 blue:94 alpha:1.0];
    return YES;
}
-(void) textViewDidChange:(UITextView *)textView
{
    
    if(self.aDetailtextfeild.text.length == 0){
//        self.aDetailtextfeild.textColor = [UIColor lightGrayColor];
      // self.aDetailtextfeild.textColor = [UIColor colorWithRed:225 green:215 blue:0 alpha:1.0];
        [self.aDetailtextfeild setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
        self.aDetailtextfeild.text = @"Noter toute info utile pour le coursier N° batiment, étage, code d'accès immeuble, N° porte ou tout autre type de commentaire";
        [self.aDetailtextfeild resignFirstResponder];
    }
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
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
-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3]; // if you want to slide up the view
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        
            rect.origin.y -= kOFFSET_FOR_KEYBOARD;
            rect.size.height += kOFFSET_FOR_KEYBOARD;
        
        
        // 1. move the view's origin up so that the text field that will be hidden come above the keyboard
        // 2. increase the size of the view so that the area behind the keyboard is covered up.
        //rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        //rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
       
        //kOFFSET_FOR_KEY
            rect.origin.y += kOFFSET_FOR_KEYBOARD;
            rect.size.height -= kOFFSET_FOR_KEYBOARD;
   
        
        // revert back to the normal state.
       // rect.origin.y += kOFFSET_FOR_KEYBOARD;
       // rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}
-(void)textFieldDidBeginEditing:(UITextField *)sender
{
    if  (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
       //Keyboard becomes visible
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x,
                                        self.scrollView.frame.origin.y,
                                        self.scrollView.frame.size.width,
                                        self.scrollView.frame.size.height - 215 + 50);   //resize
    
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
//    //keyboard will hide
    self.scrollView.frame = CGRectMake(self.scrollView.frame.origin.x,
                                        self.scrollView.frame.origin.y,
                                        self.scrollView.frame.size.width,
                                        self.scrollView.frame.size.height + 215 - 50); //resize
    
    
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
- (IBAction)aBtn_OKClicked:(id)sender {
    [self package_details];
}

- (IBAction)aBtn_BackClicked:(id)sender
{
    Order_CartViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Order_CartViewController"];
    [self.navigationController pushViewController:controller animated:YES];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;

}
- (void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [[self view] endEditing:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard

-(void)package_details
{
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
        
        
        
        if([[AppDelegate sharedAppDelegate]connected])
        {
            if ([[AppDelegate sharedAppDelegate]connected])
            {
                NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
                NSString *strUserID = [pref objectForKey:PREF_USER_ID];
                NSString *temp_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"tempo"];
                NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                [dictParam setValue:strUserToken forKey:@"token"];
                [dictParam setValue:strUserID forKey:@"id"];
                [dictParam setValue:self.aDetailtextfeild.text forKey:@"details"];
                [dictParam setValue:self.aTextfieldTelephone.text forKey:@"phone"];
                [dictParam setValue:temp_id forKey:@"temp_id"];
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_SAVE_ORDER_INFO withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     
                     NSLog(@"Validation Response ---> %@",response);
                     if (response)
                     {
                         if([response valueForKey:@"success"])
                         {
                             NSLog(@"Response :::::: %@",response);
                             Order_CartViewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"Order_CartViewController"];
                             [self.navigationController pushViewController:controller animated:YES];
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
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    
}

- (IBAction)aTelephone_clicked:(id)sender
{
    
}
@end
