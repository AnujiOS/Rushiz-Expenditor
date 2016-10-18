//
//  ProfileVCViewController.m
//  Ruchiz
//
//  Created by ganesh on 6/15/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "ProfileVCViewController.h"
#import "AppDelegate.h"
#import "Constants.h"
#import "UtilityClass.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import "CommandPageViewController.h"
@import CoreImage;


@interface ProfileVCViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,UIImagePickerControllerDelegate,UIScrollViewDelegate>
{
    NSDictionary *view_cart;
    UITapGestureRecognizer *tapRecognizer;
    NSString *userImageURL;
    UIImage *image ;
}

@end

@implementation ProfileVCViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self profile_view];
    self.first_name.enabled = NO;
    self.last_name.enabled = NO;
    self.email_id.enabled=NO;
    self.phone_number.enabled = NO;
    self.user_address.enabled = NO;
    //Keyboard stuff
    tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    tapRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapRecognizer];
    self.scroll_view.delegate = self;
    self.scroll_view.contentSize = CGSizeMake(320,650);
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}
- (void)handleSingleTap:(UITapGestureRecognizer *) sender
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)profile_view
{
    [APPDELEGATE showHUDLoadingView:@"Loading"];
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
                 
                 NSLog(@"View_profile Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         view_cart = [[NSDictionary alloc]init];
                         view_cart = [response valueForKey:@"result"];
                         NSString *first_name = [view_cart valueForKey:@"first_name"];
                         NSString *last_name = [view_cart valueForKey:@"last_name"];
                         NSString *phone_number = [view_cart valueForKey:@"phone"];
                         NSString *email_id = [view_cart valueForKey:@"email"];
                         NSString *user_address = [view_cart valueForKey:@"address"];
                         
                        
                         [self.profile_img sd_setImageWithURL:[NSURL URLWithString:[view_cart valueForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"no_img-2"]];
                         [self.profile_bg_img sd_setImageWithURL:[NSURL URLWithString:[view_cart valueForKey:@"picture"]] placeholderImage:[UIImage imageNamed:@"no_img-2"]];
                         self.profile_bg_img.image = [self squareImageWithImage:self.profile_img.image scaledToSize:CGSizeMake(229, 229)];
                         userImageURL = [NSString stringWithFormat:@"%@",[view_cart valueForKey:@"picture"]];
                         self.profile_img.layer.cornerRadius = self.profile_img.frame.size.width / 2;
                         self.profile_img.clipsToBounds = YES;
                         self.profile_img.layer.borderWidth = 1.0f;
                         self.profile_img.layer.borderColor = [UIColor whiteColor].CGColor;
                         self.first_name.text = first_name;
                         self.last_name.text = last_name;
                         self.phone_number.text = phone_number;
                         self.email_id.text = email_id;
                         self.user_address.text = user_address;
                         self.Profile_user_name.text = [NSString stringWithFormat:@"%@ %@",self.first_name.text,self.last_name.text];
                        self.profile_bg_img.image = [self blurredImageWithImage:self.profile_bg_img.image];
                         
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
    
    [APPDELEGATE hideHUDLoadingView];
}

//- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage
//{
//    
//    //  Create our blurred image
//    CIContext *context = [CIContext contextWithOptions:nil];
//    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
//    
//    //  Setting up Gaussian Blur
//    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
//    [filter setValue:inputImage forKey:kCIInputImageKey];
//    [filter setValue:[NSNumber numberWithFloat:10.0f] forKey:@"inputRadius"];
////    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:kCIInputRadiusKey];
//    CIImage *result = [filter valueForKey:kCIOutputImageKey];
//    //[filter setValue:@(radius) forKey:kCIInputRadiusKey];
//    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
//     *  up exactly to the bounds of our original image */
//    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
//    
//    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
//    return retVal;
//}
- (UIImage *)blurredImageWithImage:(UIImage *)sourceImage{
    
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    //  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     //up exactly to the bounds of our original image /*
     CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
     
     UIImage *retVal = [UIImage imageWithCGImage:cgImage];
     return retVal;
     }



//// SQURE IMAGES
- (UIImage *)squareImageWithImage:(UIImage *)image scaledToSize:(CGSize)newSize
{
    double ratio;
    double delta;
    CGPoint offset;
    
    //make a new square size, that is the resized imaged width
    CGSize sz = CGSizeMake(newSize.width, newSize.width);
    
    //figure out if the picture is landscape or portrait, then
    //calculate scale factor and offset
    if (image.size.width > image.size.height)
    {
        ratio = newSize.width / image.size.width;
        delta = (ratio*image.size.width - ratio*image.size.height);
        offset = CGPointMake(delta/2, 0);
    } else
    {
        ratio = newSize.width / image.size.height;
        delta = (ratio*image.size.height - ratio*image.size.width);
        offset = CGPointMake(0, delta/2);
    }
    
    //make the final clipping rect based on the calculated values
    CGRect clipRect = CGRectMake(-offset.x, -offset.y,
                                 (ratio * image.size.width) + delta,
                                 (ratio * image.size.height) + delta);
    
    
    //start a new context, with scale factor 0.0 so retina displays get
    //high quality image
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
    {
        UIGraphicsBeginImageContextWithOptions(sz, YES, 0.0);
    } else
    {
        UIGraphicsBeginImageContext(sz);
    }
    UIRectClip(clipRect);
    [image drawInRect:clipRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    
    NSData *imageData = UIImageJPEGRepresentation(image, 0.5);;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsPath = [paths objectAtIndex:0]; //Get the docs directory
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"image.png"]; //Add the file name
    [imageData writeToFile:filePath atomically:NO]; //Write the file
    
    [[NSUserDefaults standardUserDefaults] setObject:filePath forKey:@"UserProfilePicPath"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    self.profile_img.contentMode=UIViewContentModeScaleAspectFill;
    [self.profile_img setClipsToBounds:YES];
    [self.profile_img.layer setMasksToBounds:YES];
    self.profile_img.layer.borderWidth=2.0;
    [self.profile_img.layer setCornerRadius:self.profile_img.frame.size.width/2];
    [self.profile_img.layer setCornerRadius:self.profile_img.frame.size.width/2];
    self.profile_img.layer.borderColor=[UIColor whiteColor].CGColor;
    [self.profile_img setImage:image];
    [self.profile_bg_img setImage:image];
    self.profile_bg_img.transform = CGAffineTransformMakeRotation(M_PI_2);
    self.profile_bg_img.contentMode = UIViewContentModeScaleToFill;//UIViewContentModeScaleAspectFill;
    
    self.profile_bg_img.image = [self blurredImageWithImage:image];
    [self dismissModalViewControllerAnimated:YES];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"LoginClicked"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self  user_DATA_UPDATE];
    
}

- (IBAction)back_btn:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
    //CommandPageViewController *payment = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
    [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen];
    //[self.navigationController pushViewController:payment animated:NO];
}

- (IBAction)camera_image:(id)sender
{
    UIActionSheet *actionSheet;
    
    NSString *strCancel =@"Annuler";
    NSString *strotherTitle1 =@"Prendre une nouvelle photo";
    NSString *strotherTitle2 =@"Sélectionner dans ma galerie";
    
    actionSheet = [[UIActionSheet alloc] initWithTitle: nil
                                              delegate: self
                                     cancelButtonTitle: [strCancel uppercaseString]
                                destructiveButtonTitle: nil
                                     otherButtonTitles: [strotherTitle1 uppercaseString],[strotherTitle2 uppercaseString], nil];
    
    [actionSheet showInView:self.view];

    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
    
    switch (buttonIndex) {
        case 0:
            [self takeNewPhotoFromCamera];
            
            break;
        case 1:
            [self choosePhotoFromExistingImages];
            
            break;
            
        default:
            break;
    }
}

- (void)takeNewPhotoFromCamera
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypeCamera;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];
        controller.delegate = self;
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}

-(void)choosePhotoFromExistingImages
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *controller = [[UIImagePickerController alloc] init];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.allowsEditing = NO;
        controller.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType: UIImagePickerControllerSourceTypePhotoLibrary];
        controller.delegate = self;
        controller.navigationItem.leftBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"Annuler" style:(UIBarButtonItemStylePlain) target:self action:@selector(cancel:)];
        
        [self.navigationController presentViewController: controller animated: YES completion: nil];
    }
}


- (IBAction)first_name_update:(id)sender
{
    self.first_name.enabled = YES;
    //becomeFirstResponder
    [self.first_name becomeFirstResponder];
    [self.last_name resignFirstResponder];
     [self.user_address resignFirstResponder];
}

- (IBAction)last_name_update:(id)sender
{
    self.last_name.enabled= YES;
    [self.first_name resignFirstResponder];
    [self.last_name becomeFirstResponder];
    [self.user_address resignFirstResponder];
}

- (IBAction)address_update:(id)sender
{
    self.user_address.enabled = YES;
    [self.first_name resignFirstResponder];
    [self.last_name resignFirstResponder];
    [self.user_address becomeFirstResponder];
}

- (IBAction)save:(id)sender
{
    [self user_DATA_UPDATE ];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return YES;
}

// It is important for you to hide the keyboard
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.first_name resignFirstResponder];
    return YES;
}

-(void)user_DATA_UPDATE
{
    [APPDELEGATE showHUDLoadingView:@"Loading..."];
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if ([[AppDelegate sharedAppDelegate]connected])
        {
            
            NSData *dataImage = [[NSData alloc] init];
            dataImage = UIImagePNGRepresentation(image);
            NSString *stringImage = [dataImage base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:strUserID forKey:@"id"];
            
            [dictParam setValue:self.first_name.text forKey:@"first_name"];
            [dictParam setValue:self.last_name.text forKey:@"last_name"];
            [dictParam setValue:self.phone_number.text forKey:@"phone"];
            [dictParam setValue:image forKey:@"picture"];
            [dictParam setValue:self.email_id.text forKey:@"email"];
            [dictParam setValue:self.user_address.text forKey:@"address"];
            UIImage *imgUpload = [[UtilityClass sharedObject]scaleAndRotateImage:self.profile_img.image];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_PROFILE_UPDATE withParamDataImage:dictParam andImage:imgUpload  withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"View_profile_updated Response ---> %@",response);
                 if (response)
                 {
                     if([response objectForKey:@"success"])
                     {
                         [APPDELEGATE hideHUDLoadingView];
                         
                         NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                                                  [pref setObject:response forKey:PREF_LOGIN_OBJECT];
                                                  [pref setObject:[response valueForKey:@"token"] forKey:PREF_USER_TOKEN];
                                                  [pref setObject:[response valueForKey:@"id"] forKey:PREF_USER_ID];
                                                  [pref setObject:[response valueForKey:@"is_referee"] forKey:PREF_IS_REFEREE];
                                                  [pref setBool:YES forKey:PREF_IS_LOGIN];
                                                  [pref synchronize];
                          NSUserDefaults *transport = [NSUserDefaults standardUserDefaults];
                         [pref setObject:response forKey:PREF_TRANSPORT];
                         [pref setObject:[response valueForKey:@"picture"] forKey:PREF_IMAGES];
                         [pref setObject:[response valueForKey:@"euro"] forKey:PREF_EURO];
                         [pref setObject:[response valueForKey:@"disable"] forKey:PREF_DISABLE];
                         [pref setObject:[response valueForKey:@"total_minut_km"] forKey:PREF_TOTAL_MINUT_KM];
                         [pref setObject:[response valueForKey:@"transt_name"] forKey:PREF_TRANST_NAME];
                         [pref synchronize];

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
