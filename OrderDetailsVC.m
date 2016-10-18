//
//  OrderDetailsVC.m
//  Ruchiz
//
//  Created by mac on 8/29/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "OrderDetailsVC.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import "SlideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import <CoreLocation/CoreLocation.h>
#import <GoogleMaps/GoogleMaps.h>
#import <QuartzCore/QuartzCore.h>
#import "OrderStatusVC.h"

@import GoogleMaps;
@interface OrderDetailsVC ()<MFMailComposeViewControllerDelegate>
{
    NSMutableArray *Order_view;
    NSMutableArray *delivery_position;
    NSString *phone_num;
    NSArray *phone_number;
    GMSMapView *mapView_;
    NSMutableArray *arr_source_lat;
    NSMutableArray *arr_source_log;
    NSMutableArray *arr_desti_lat;
    NSMutableArray *arr_desti_log;
    NSString *tap_s_lati;
    NSString *tap_s_longi;
    NSString *tap_s_lati0;
    NSString *tap_s_longi0;
    NSString *place_name;
    CLLocation* loaction;
    CLLocationCoordinate2D delivary_loc;
    CLLocationCoordinate2D destination_loc;
    GMSPolyline *polyline;
    CLLocation *locationOrigin;
    CLLocation *locationDesti;
    BOOL flag;
    NSTimer *timer_order;
}

@end

@implementation OrderDetailsVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    timer_order = [NSTimer scheduledTimerWithTimeInterval:5.0f target:self selector:@selector(deliveryboy_status) userInfo:nil repeats:YES];

    
    delivery_position = [[NSMutableArray alloc]init];
    Order_view = [[NSMutableArray alloc]init];
    phone_number = [[NSArray alloc]init];
    CLLocationCoordinate2D coordinate = [self getLocation];
    strForCurLatitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    strForCurLongitude= [NSString stringWithFormat:@"%f", coordinate.longitude];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[strForCurLatitude doubleValue]longitude:[strForCurLongitude doubleValue] zoom:15];
    mapView_ = [GMSMapView mapWithFrame:CGRectMake(0, 0, self.main_View.frame.size.width, self.main_View.frame.size.height) camera:camera];

    mapView_.delegate=self;
    [self.main_View addSubview:mapView_];
    [self.main_View addSubview:_customView];
    [self owner_pack_order_details];
    [self deliveryboy_status];
    

}
-(void)viewDidDisappear:(BOOL)animated {
    [timer_order invalidate];
}

//-(void)viewDidDisappear:(BOOL)animated
//{
//    [self viewDidDisappear:YES];
//    if(timer)
//    {
//        [timer invalidate];
//        timer = nil;
//    }
//    
//}
//- (void)viewWillDisappear:(BOOL)animated {
//    //BEFORE DOING SO CHECK THAT TIMER MUST NOT BE ALREADY INVALIDATED
//    //Always nil your timer after invalidating so that
//    //it does not cause crash due to duplicate invalidate
//    if(timer)
//    {
//        [timer invalidate];
//        timer = nil;
//    }
//}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark - Location Delegate

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

-(void)display_details
{
    //[self.Image_deliveryBoy sd_setImageWithURL:[NSURL URLWithString:[Order_view valueForKey:@"delivery_photo"]]];
    NSString *image_url = [NSString stringWithFormat:@"%@",[[Order_view objectAtIndex:0]valueForKey:@"delivery_photo"]];
    
    NSURL *url = [NSURL URLWithString:image_url];
    
    [self.Image_deliveryBoy sd_setImageWithURL:url];
    
    [self.customView addSubview:self.Image_deliveryBoy];
    
    
    phone_number = [[Order_view objectAtIndex:0] valueForKey:@"delivery_phone"];
    phone_num = [NSString stringWithFormat:@"tel:%@",phone_number];
    
//    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
//    
//    UIImage *tmpImage = [[UIImage alloc] initWithData:data];
//    
//    self.Image_deliveryBoy.image = tmpImage;
    
    self.Name_DeliveryBoy.text = [NSString stringWithFormat:@"%@ %@",[[Order_view objectAtIndex:0]valueForKey:@"delivery_first_name"],[[Order_view  objectAtIndex:0]valueForKey:@"delivery_last_name"]];
}

-(void)owner_pack_order_details
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
                NSString *pack_id = [[NSUserDefaults standardUserDefaults]valueForKey:@"pack_id"];
                NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                [dictParam setValue:strUserToken forKey:@"token"];
                [dictParam setValue:strUserID forKey:@"id"];
                [dictParam setObject:pack_id forKey:@"pack_id"];
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_OWNER_PACK_ORDER_DETAILS withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     [[AppDelegate sharedAppDelegate]hideLoadingView];
                     
                     NSLog(@"Validation Response ---> %@",response);
                     if (response)
                     {
                         if([response valueForKey:@"success"])
                         {
                             NSLog(@"Response :::::: %@",response);
                             Order_view = [response valueForKey:@"result"];
                             
                             [self display_details];
                             [self orderdetails];
                             
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
            else
            {
                
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    
}


- (IBAction)Btn_DeliveryCallClicked:(id)sender
{
   
    NSURL *phoneNumber = [[NSURL alloc] initWithString:phone_num];
    [[UIApplication sharedApplication] openURL: phoneNumber];
}

- (IBAction)Btn_DeliveryMsgClicked:(id)sender
{
    if ([MFMessageComposeViewController canSendText])
        // The device can send email.
    {
        [self displaySMSComposerSheet];
    }

}
- (void)displaySMSComposerSheet
{
    MFMessageComposeViewController *picker = [[MFMessageComposeViewController alloc] init];
    picker.messageComposeDelegate = self;
    // You can specify one or more preconfigured recipients.  The user has
    // the option to remove or add recipients from the message composer view
    // controller.
    //picker.recipients = phone_number;
    picker.recipients = [NSArray arrayWithObjects:phone_number, nil];
    
    // You can specify the initial message text that will appear in the message
    // composer view controller.
    //picker.body = @"Hello from California!";
    
    [self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - Delegate Methods

// -------------------------------------------------------------------------------
//	messageComposeViewController:didFinishWithResult:
//  Dismisses the message composition interface when users tap Cancel or Send.
//  Proceeds to update the feedback message field with the result of the
//  operation.
// -------------------------------------------------------------------------------
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result
{
    
    // Notifies users about errors associated with the interface
    switch (result)
    {
        case MessageComposeResultCancelled:
            
            break;
        case MessageComposeResultSent:
            
            break;
        case MessageComposeResultFailed:
            
            break;
        default:
            
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)Btn_Cancle:(id)sender
{
    
}

//- (IBAction)menu_btnClicked:(id)sender
//{
//    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
//}


-(void)orderdetails
{
    arr_source_lat = [[NSMutableArray alloc]init];
    arr_source_log = [[NSMutableArray alloc]init];
    arr_desti_lat = [[NSMutableArray alloc]init];
    arr_desti_log = [[NSMutableArray alloc]init];

    
    if (Order_view.count >0) {
        for (int i = 0 ; i<Order_view.count; i++) {
            tap_s_lati =[NSString stringWithFormat:@"%@",[[Order_view objectAtIndex:i] valueForKey:@"s_lati"]];
            tap_s_longi =[NSString stringWithFormat:@"%@",[[Order_view objectAtIndex:i] valueForKey:@"s_longi"]];
            
            NSString *tap_d_lati =[NSString stringWithFormat:@"%@",[[Order_view objectAtIndex:i]valueForKey:@"d_lati"]];
            NSString *tap_d_longi =[NSString stringWithFormat:@"%@",[[Order_view objectAtIndex:i]valueForKey:@"d_longi"]];
            
            
            [arr_source_lat addObject:tap_s_lati];
            [arr_source_log addObject:tap_s_longi];

            [arr_desti_lat addObject:tap_d_lati];
            [arr_desti_log addObject:tap_d_longi];

            destination_loc = CLLocationCoordinate2DMake([tap_d_lati doubleValue], [tap_d_longi doubleValue]);

        }
    }
    
    GMSMarker *depart = [[GMSMarker alloc] init];
    depart.position = CLLocationCoordinate2DMake([[arr_source_lat objectAtIndex:0 ]doubleValue],[[arr_source_log objectAtIndex:0 ]doubleValue]);
    depart.appearAnimation = kGMSMarkerAnimationPop;
    depart.icon = [UIImage imageNamed:@"depart"];
    depart.map = mapView_;
    
    for (int x=0; x<arr_desti_lat.count; x++)
    {
        GMSMarker *destination = [[GMSMarker alloc] init];
        destination.position = CLLocationCoordinate2DMake([[arr_desti_lat objectAtIndex:x ]doubleValue],[[arr_desti_log objectAtIndex:x ]doubleValue]);
        destination.appearAnimation = kGMSMarkerAnimationPop;
        destination.icon = [UIImage imageNamed:@"destination"];
        destination.map = mapView_;
    }
    self.main_View = mapView_;
}

-(void)deliveryboy_status
{
    if([APPDELEGATE connected])
    {
        //[APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
        
        if([[AppDelegate sharedAppDelegate]connected])
        {
            if ([[AppDelegate sharedAppDelegate]connected])
            {
                NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
                NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
                NSString *strUserID = [pref objectForKey:PREF_USER_ID];
                NSString *packid = [[NSUserDefaults standardUserDefaults]valueForKey:@"pack_id"];
                NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
                [dictParam setValue:strUserToken forKey:@"token"];
                [dictParam setValue:strUserID forKey:@"owner_id"];
                [dictParam setObject:packid forKey:@"o_id"];
                
                AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
                [afn getDataFromPath:FILE_GET_PROVIDER_CURRENT_LOCATION withParamData:dictParam withBlock:^(id response, NSError *error)
                 {
                     //[[AppDelegate sharedAppDelegate]hideLoadingView];
                     
                     NSLog(@"Validation Response ---> %@",response);
                     if (response)
                     {
                         if([response valueForKey:@"success"])
                         {
                             NSLog(@"Response :::::: %@",response);
                             
                             delivery_position = [response valueForKey:@"result"];
                             
                             NSString *curr_del_lati = [NSString stringWithFormat:@"%@",[[delivery_position objectAtIndex:0] valueForKey:@"latitude"]];
                             NSString *curr_del_longi = [NSString stringWithFormat:@"%@",[[delivery_position objectAtIndex:0]valueForKey:@"longitude"]];
                            
                             delivary_loc = CLLocationCoordinate2DMake([curr_del_lati doubleValue],[curr_del_longi doubleValue]);
                             loaction = [[CLLocation alloc] initWithLatitude:[curr_del_lati doubleValue] longitude:[curr_del_longi doubleValue]];
                             [self getAddressFromLocation:loaction complationBlock:^(NSString * address) {
                                 if(address) {
                                     _location_address.text = [NSString stringWithFormat:@"%@",address];
                                     //place_name = address;
                                    
                                     
                                 }
                             }];
                             
                             GMSMarker *destination = [[GMSMarker alloc] init];
                             destination.position = CLLocationCoordinate2DMake([curr_del_lati doubleValue],[curr_del_longi doubleValue]);                             //destination.appearAnimation = kGMSMarkerAnimationPop;
                             destination.icon = [UIImage imageNamed:@"car"];
                             destination.map = mapView_;
                             
                             if (flag == NO)
                             {
                                 locationOrigin = [[CLLocation alloc] initWithLatitude:[curr_del_lati doubleValue] longitude:[curr_del_longi doubleValue]];
//                                 tap_s_lati0 =[NSString stringWithFormat:@"%@",[[Order_view objectAtIndex:0] valueForKey:@"s_lati"]];
//                                 tap_s_longi0 =[NSString stringWithFormat:@"%@",[[Order_view objectAtIndex:0] valueForKey:@"s_longi"]];
                                 
                                 locationDesti = [[CLLocation alloc] initWithLatitude:[[arr_source_lat objectAtIndex:0]doubleValue] longitude:[[arr_source_log objectAtIndex:0]doubleValue]];
                             }
                             
                             for (int p = 0; p < arr_desti_log.count; p++)
                             {
                                 if (flag == YES)
                                 {
                                     locationOrigin = [[CLLocation alloc] initWithLatitude:[[arr_source_lat objectAtIndex:p]doubleValue] longitude:[[arr_source_log objectAtIndex:p]doubleValue] ];
                                     locationDesti = [[CLLocation alloc] initWithLatitude:[[arr_desti_lat objectAtIndex:p]doubleValue] longitude:[[arr_desti_log objectAtIndex:p]doubleValue] ];

                                 }
                                 
//                                 locationDesti = [[CLLocation alloc] initWithLatitude:y longitude:x];
                                 flag = YES;
                                 [self drawRoute:locationOrigin :locationDesti];
                             }
                             
                             
                             
                             
                             
                             
                             
                             
                             
//                             GMSMutablePath *path = [GMSMutablePath path];
//                             
//                             [path addCoordinate:CLLocationCoordinate2DMake([curr_del_lati doubleValue], [curr_del_longi doubleValue])];
//                             [path addCoordinate:CLLocationCoordinate2DMake([tap_s_lati doubleValue], [tap_s_longi doubleValue])];
//                             for (int z=0; z<arr_desti_lat.count; z++)
//                             {
//                                 
//                                 NSString *lat_str = [NSString stringWithFormat:@"%@",[arr_desti_lat objectAtIndex:z]];
//                                 NSString *log_str = [NSString stringWithFormat:@"%@",[arr_desti_log objectAtIndex:z]];
//                                 //double lat = [lat_str doubleValue];
//                                 //double log = [log_str doubleValue];
//                                 [path addCoordinate:CLLocationCoordinate2DMake([lat_str doubleValue], [log_str doubleValue])];
//                                 
//                             }
//                             GMSPolyline *polygon = [GMSPolyline polylineWithPath:path];
//                             polygon.map = mapView_;
//                             polygon.strokeColor = [UIColor blackColor];
//                             polygon.strokeWidth = 7.0f;
//                             polygon.geodesic = YES;
                             
                
                             
                         }
                         else
                         {
                             UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                             [alert show];
                         }
                     }
                     //[APPDELEGATE hideLoadingView];
                     
                 }];
            }
            else
            {
                
            }
        }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    
}





- (IBAction)Btn_mail:(id)sender
{
    UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, self.view.opaque, 0.0);
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0 ); //you can use PNG too
    [imageData writeToFile:@"image1.png" atomically:YES];
    
    [self emailImageWithImageData:imageData];
}
- (void)emailImageWithImageData:(NSData *)data
{
    MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
    mail.mailComposeDelegate = self;
    
    // Set the subject of email
    [mail setSubject:@"Picture from my iPhone!"];
    
    // Add email addresses
    // Notice three sections: "to" "cc" and "bcc"
    //[mail setToRecipients:[NSArray arrayWithObjects:@"emailaddress1@domainName.com", @"emailaddress2@domainName.com", nil]];
    //[mail setCcRecipients:[NSArray arrayWithObject:@"emailaddress3@domainName.com"]];
    //[mail setBccRecipients:[NSArray arrayWithObject:@"emailaddress4@domainName.com"]];
    
    //    Fill out the email body text
    NSString *emailBody = @"Livraison image Statut actuel , check it out.";
    
    // This is not an HTML formatted email
    [mail setMessageBody:emailBody isHTML:NO];
    
    // Attach image data to the email
    // 'CameraImage.png' is the file name that will be attached to the email
    [mail addAttachmentData:data mimeType:@"image/png" fileName:@"image1.png"];
    
    // Show email view
    //[self presentModalViewController:picker animated:YES];
    [self presentViewController:mail animated:YES completion:NULL];
    //if you have a navigation controller: use that to present, else the user will not
    //be able to tap the send/cancel buttons
    //[self.navigationController presentModalViewController:picker animated:YES];
    
    
    // Release picker
   // [picker release];
}
- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error
{
    // Called once the email is sent
    // Remove the email view controller
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void)getAddressFromLocation:(CLLocation *)location complationBlock:(addressCompletion)completionBlock
{
    __block CLPlacemark* placemark;
    __block NSString *address = nil;
    
    CLGeocoder* geocoder = [CLGeocoder new];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (error == nil && [placemarks count] > 0)
         {
             placemark = [placemarks lastObject];
             address = [NSString stringWithFormat:@"%@, %@ %@", placemark.name, placemark.postalCode, placemark.locality];
             completionBlock(address);
         }
     }];
}


- (void)drawRoute:(CLLocation *)myOrigin :(CLLocation *)myDestination
{
   
        
    [self fetchPolylineWithOrigin:myOrigin destination:myDestination completionHandler:^(GMSPolyline *polyline1)
     {
         if(polyline)
             polyline.strokeWidth = 3;
         polyline.strokeColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];
         polyline.geodesic =YES;
         polyline.map = mapView_;
//         
//         if (polyline2) {
//             polyline2.strokeWidth = 3;
//             polyline2.strokeColor = [UIColor colorWithRed:0.0/255.0 green:174.0/255.0 blue:239.0/255.0 alpha:1.0];
//             polyline2.geodesic =YES;
//             polyline2.map = big_map;
//         }
//         
//         self.ok_btn.enabled = YES;
         
     }];
    
}
//- (void)focusMapToShowAllMarkers_smallmaps
//{
//    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:delivary_loc coordinate:destination_loc];
//    [mapView_ animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:35.0f]];
//}

- (void)fetchPolylineWithOrigin:(CLLocation *)origin destination:(CLLocation *)destination completionHandler:(void (^)(GMSPolyline *))completionHandler
{
    //[self performSelector:@selector(focusMapToShowAllMarkers_smallmaps)withObject:nil];
    
    
    
    NSString *originString = [NSString stringWithFormat:@"%f,%f", origin.coordinate.latitude, origin.coordinate.longitude];
    NSString *destinationString = [NSString stringWithFormat:@"%f,%f", destination.coordinate.latitude, destination.coordinate.longitude];
    NSString *directionsAPI = @"https://maps.googleapis.com/maps/api/directions/json?";
    NSString *directionsUrlString = [NSString stringWithFormat:@"%@&origin=%@&destination=%@&mode=driving", directionsAPI, originString, destinationString];
    NSURL *directionsUrl = [NSURL URLWithString:directionsUrlString];
    NSURLSessionDataTask *fetchDirectionsTask = [[NSURLSession sharedSession] dataTaskWithURL:directionsUrl completionHandler:
                                                 ^(NSData *data, NSURLResponse *response, NSError *error)
                                                 {
                                                     NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
                                                     if(error)
                                                     {
                                                         if(completionHandler)
                                                             completionHandler(nil);
                                                         return;
                                                     }
                                                     
                                                     NSArray *routesArray = [json objectForKey:@"routes"];
                                                     
                                                    // polyline.map = nil;
                                                    // polyline2.map = nil;
                                                     
                                                     if ([routesArray count] > 0)
                                                     {
                                                         
                                                         NSDictionary *routeDict = [routesArray objectAtIndex:0];
                                                         NSDictionary *routeOverviewPolyline = [routeDict objectForKey:@"overview_polyline"];
                                                         NSString *points = [routeOverviewPolyline objectForKey:@"points"];
                                                         NSString *point = [routeOverviewPolyline objectForKey:@"points"];
                                                         //NSArray *legs = [[NSArray alloc]init];
                                                         //legs = [[routesArray objectAtIndex:0]valueForKey:@"legs"];
                                                         //NSDictionary *distance1 = [[NSDictionary alloc]init];
                                                         //distance1 = [[legs objectAtIndex:0 ]valueForKey:@"distance"];
                                                         
                                                         
                                                        // Full_string = [distance1 valueForKey:@"text"];
                                                         //strdistance = [Full_string stringByReplacingOccurrencesOfString:@" km" withString:@""];
                                                         
                                                         GMSPath *path = [GMSPath pathFromEncodedPath:points];
                                                         //GMSPath *path1 = [GMSPath pathFromEncodedPath:point];
                                                         polyline = [GMSPolyline polylineWithPath:path];
                                                         
                                                         //polyline2 = [GMSPolyline polylineWithPath:path1];
                                                         //[self performSelector:@selector(focusMapToShowAllMarkers_bigmaps)withObject:nil];
                                                         //deprt_latitude = [NSString stringWithFormat:@"%f",j];
                                                         //deprt_longitude = [NSString stringWithFormat:@"%f",i];
                                                         //destination_latitude = [NSString stringWithFormat:@"%f",y];
                                                        // destination_longitude = [NSString stringWithFormat:@"%f",x];
                                                         //[[NSUserDefaults standardUserDefaults] setObject:Full_string forKey:@"Kilo-meter"];
                                                         //[[NSUserDefaults standardUserDefaults] setObject:deprt_latitude forKey:@"deprt_latitude"];
                                                         //[[NSUserDefaults standardUserDefaults] setObject:deprt_longitude forKey:@"deprt_longitude"];
                                                         //[[NSUserDefaults standardUserDefaults] setObject:destination_latitude forKey:@"destination_latitude"];
                                                         //[[NSUserDefaults standardUserDefaults] setObject:destination_longitude forKey:@"destination_longitude"];
                                                         //[[NSUserDefaults standardUserDefaults] synchronize];
                                                         
                                                         //[self.ok_btn setImage:[UIImage imageNamed:@"enable_ok_btn.png"] forState:UIControlStateNormal];
                                                         //self.ok_btn.showsTouchWhenHighlighted = YES;
                                                         
                                                         
                                                         
                                                     }
                                                     
                                                     if(completionHandler)
                                                         completionHandler(polyline);
                                                    // if (completionHandler)
                                                        // completionHandler(polyline2);
                                                     
                                                 }];
    [fetchDirectionsTask resume];
    
    
}

- (IBAction)Btn_BackAction:(id)sender
{
    OrderStatusVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderStatusVC"];
    [self.navigationController pushViewController:vc animated:YES];
}
@end
