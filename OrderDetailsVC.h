//
//  OrderDetailsVC.h
//  Ruchiz
//
//  Created by mac on 8/29/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>
@import GoogleMaps;
typedef void(^addressCompletion)(NSString *);
@interface OrderDetailsVC : UIViewController<MFMessageComposeViewControllerDelegate,CLLocationManagerDelegate,GMSMapViewDelegate>
{
    CLLocationManager *locationManager;
     CLLocation *currentLocation;
}
@property (weak, nonatomic) IBOutlet UIImageView *Image_deliveryBoy;
@property (weak, nonatomic) IBOutlet UILabel *Name_DeliveryBoy;
- (IBAction)Btn_DeliveryCallClicked:(id)sender;
- (IBAction)Btn_DeliveryMsgClicked:(id)sender;
- (IBAction)Btn_Cancle:(id)sender;
- (IBAction)menu_btnClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *customView;
@property (weak, nonatomic) IBOutlet UIView *main_View;
- (IBAction)Btn_mail:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *location_address;
- (IBAction)Btn_BackAction:(id)sender;

@end
