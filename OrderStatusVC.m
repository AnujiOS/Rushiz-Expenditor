//
//  OrderStatusVC.m
//  Ruchiz
//
//  Created by mac on 7/8/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "OrderStatusVC.h"
#import "OrderStatusTableViewCell.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "OrderDetailsVC.h"
#import "RecapitulatifVC.h"
@import GoogleMaps;
typedef void(^addressCompletion)(NSString *);
@interface OrderStatusVC ()
{
    NSMutableArray *order_collection;
    HMSegmentedControl *segmentedControl;
    int index;
    CLLocation* sourceloaction;
    CLLocation *destinationloaction;
    NSString *place_name;
}

@end

@implementation OrderStatusVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    index = 1;
    order_collection = [[NSMutableArray alloc]init];
    [self owner_waitorder];
    self.tableView.backgroundColor = [UIColor clearColor];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    //////////////////////////
   // segmentedControl = [[HMSegmentedControl alloc] initWithSectionImages:@[[UIImage imageNamed:@"cours_segment"], [UIImage imageNamed:@"attente_segment"], [UIImage imageNamed:@"livre_segment"]] sectionSelectedImages:@[[UIImage imageNamed:@"cours_segment"], [UIImage imageNamed:@"attente_segment"], [UIImage imageNamed:@"livre_segment"]]];
    //segmentedControl.frame = CGRectMake(0, 45, viewWidth, 50);
    //segmentedControl.selectionIndicatorHeight = 4.0f;
    //segmentedControl.backgroundColor = [UIColor clearColor];
    //segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    //segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleTextWidthStripe;
    //[segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    
    
    ///////////////////////////
    segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"En cours", @"En attente", @"Livré"]];
    //[segmentedControl setSectionSelectedImages:[NSArray arrayWithObjects:@"right_arrow.png",@"right_arrow.png",@"bg-1.png", nil]];
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl.frame = CGRectMake(0, 45, viewWidth, 50);
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.75];
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl.selectionIndicatorColor=[UIColor colorWithRed:225.0/255.0 green:205.0/255.0 blue:106.0/255.0 alpha:1.0];
    //segmentedControl.selectionIndicatorColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"indicator_img_1.png"]];
   
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = [UIColor colorWithRed:225.0/255.0 green:205.0/255.0 blue:106.0/255.0 alpha:1.0];
    segmentedControl.verticalDividerWidth = 2.0f;
    [segmentedControl setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:225.0/255.0 green:205.0/255.0 blue:106.0/255.0 alpha:1.0]}];;//[UIColor blueColor]}];
        return attString;
        
    }];
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segmentedControl];
        UISwipeGestureRecognizer *leftswipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeRecognizer:)];
    leftswipe.delegate = self;
    leftswipe.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *rightswipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(SwipeRecognizer:)];
    rightswipe.delegate = self;
    rightswipe.direction = UISwipeGestureRecognizerDirectionRight;
    [segmentedControl setSelectedSegmentIndex:index];
    
    [self.tableView addGestureRecognizer: leftswipe];
    [self.tableView addGestureRecognizer: rightswipe];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl
{
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", (long)segmentedControl.selectedSegmentIndex);
    index = (long)segmentedControl.selectedSegmentIndex;
    [segmentedControl setSelectedSegmentIndex:index];
    if (segmentedControl.selectedSegmentIndex == 0)
    {
        segmentedControl.selectedSegmentIndex = 0;
        index = 0;
        [self owner_accept_wait_order];
        
    }
    else if(segmentedControl.selectedSegmentIndex == 1)
    {
        segmentedControl.selectedSegmentIndex = 1;
        index = 1;
        [self owner_waitorder];
        
    }
    else if(segmentedControl.selectedSegmentIndex == 2)
    {
        segmentedControl.selectedSegmentIndex = 2;
        index = 2;
        [self owner_completeorder];
        
    }
        [self.tableView reloadData];

}

- (void)uisegmentedControlChangedValue:(UISegmentedControl *)segmentedControl
{
    NSLog(@"Selected index %ld", (long)segmentedControl.selectedSegmentIndex);
}

- (void) SwipeRecognizer:(UISwipeGestureRecognizer *)sender
{
    if ( sender.direction == UISwipeGestureRecognizerDirectionLeft )
    {
        if (index < 2)
        {
            NSLog(@" *** SWIPE LEFT ***");
            index++;
            [sender setEnabled:YES ];
            if (index == 0)
            {
                [segmentedControl setSelectedSegmentIndex:index];
                [self owner_accept_wait_order];
                [self.tableView reloadData];
            }
            else if (index == 1)
            {
                [segmentedControl setSelectedSegmentIndex:index];
                [self owner_waitorder];
                [self.tableView reloadData];
                
            }
            else if(index==2)
            {
                index = 2;
                [segmentedControl setSelectedSegmentIndex:index];
             [self owner_completeorder];
                [self.tableView reloadData];
            }
            [sender setEnabled:YES];
        }
    }
    if ( sender.direction == UISwipeGestureRecognizerDirectionRight )
    {
        if (index > 0)
        {
            NSLog(@" *** SWIPE RIGHT ***");
            index--;
            [sender setEnabled:YES ];
            if (index ==1)
            {
               [segmentedControl setSelectedSegmentIndex:index];
                [self owner_waitorder];
                [self.tableView reloadData];
            }
            else if (index ==2)
            {
                [segmentedControl setSelectedSegmentIndex:index];
                [self owner_completeorder];
                [self.tableView reloadData];
            }
            else if(index<=0)
            {
                index = 0;
                [segmentedControl setSelectedSegmentIndex:index];
                [self owner_accept_wait_order];
                [self.tableView reloadData];
            }
            [sender setEnabled:YES];
        }
    }
}


-(void)owner_accept_wait_order
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
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:strUserID forKey:@"id"];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_OWNER_ACCEPT_WAIT_ORDER withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Validation Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         NSLog(@"Response :::::: %@",response);
                         order_collection = [response valueForKey:@"result"];
                         [self.tableView reloadData];
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
-(void)owner_waitorder

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
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:strUserID forKey:@"id"];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_OWNER_WAITORDER withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Validation Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         NSLog(@"Response :::::: %@",response);
                         order_collection = [response valueForKey:@"result"];
                         [self.tableView reloadData];

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
-(void)owner_completeorder
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
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:strUserID forKey:@"id"];
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_OWNER_COMPLETE_ORDER withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Validation Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         NSLog(@"Response :::::: %@",response);
                         order_collection = [response valueForKey:@"result"];
                         [self.tableView reloadData];
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


#pragma  marl --> UITableview Datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [order_collection count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
   return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString*CellIndentifier=@"Cell";
    OrderStatusTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIndentifier];
    if(!cell){
        cell=[[OrderStatusTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIndentifier];
    }
    if (segmentedControl.selectedSegmentIndex == 0 || index == 0)
    {
        if (index == 0)
        {
            self.tableView.alpha = 1.0;
            cell.opaque = 1.0;
            cell.userInteractionEnabled = YES;
            segmentedControl.selectedSegmentIndex = index;
            NSString* formattedNumber = [NSString stringWithFormat:@"%@",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"total_km"]];
             NSString* owner = [NSString stringWithFormat:@"%@",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"walker_name"]];
            double distance = [formattedNumber doubleValue];
            cell.owner_name.hidden= NO;
            cell.lbl_time1.hidden = YES;
            cell.lbl_Distance1.hidden = YES;
            cell.star_Image.hidden = NO;
            cell.lbl_Distance.hidden = NO;
            cell.lbl_time.hidden = NO;
            cell.owner_name.text = owner;
            cell.lbl_Distance.text = [NSString stringWithFormat:@"Distance:%.02f Km",distance];
            cell.lbl_time.text = [NSString stringWithFormat:@"Temps estimatif:%@ min",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"total_min"]];
            [cell.order_img sd_setImageWithURL:[NSURL URLWithString:[[order_collection objectAtIndex:indexPath.section ] valueForKey:@"transport_img"]] placeholderImage:[UIImage imageNamed:@""]];
            NSArray *d_logi = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"d_longitude"];
            NSArray *d_lati = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"d_latitude"];
            NSArray *s_logi = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"s_longitude"];
            NSArray *s_lati = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"s_latitude" ];
            
            NSString *d_log = [NSString stringWithFormat:@"%@",d_logi];
            NSString *d_lat = [NSString stringWithFormat:@"%@",d_lati];
            NSString *s_log = [NSString stringWithFormat:@"%@",s_logi];
            NSString *s_lat = [NSString stringWithFormat:@"%@",s_lati];
            double de_log = [d_log doubleValue];
            double de_lat = [d_lat doubleValue];
            
            double so_log = [s_log doubleValue];
            double so_lat = [s_lat doubleValue];
            
            sourceloaction = [[CLLocation alloc] initWithLatitude:de_lat longitude:de_log];
            
            [self getAddressFromLocation:sourceloaction complationBlock:^(NSString * address) {
                if(address) {
                    place_name = address;
                    
                    cell.lbl_Source_name.text = [NSString stringWithFormat:@"%@",place_name];
                }
            }];
            
            destinationloaction = [[CLLocation alloc] initWithLatitude:so_lat longitude:so_log];
            
            [self getAddressFromLocation:destinationloaction complationBlock:^(NSString * address) {
                if(address) {
                    place_name = address;
                    cell.lbl_Destination_name.text = [NSString stringWithFormat:@"%@",place_name];

                }
            }];
            NSString *order_count = [NSString stringWithFormat:@"%@",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"order_count"]];
            
            if ([order_count isEqualToString:@"1"])
            {
                cell.Image_orderstatus.image = [UIImage imageNamed:@"rings_ndot_img.png"];
                
            }
            else{
                cell.Image_orderstatus.image = [UIImage imageNamed:@"rings_img.png"];
            }
        }
    }
    else if(segmentedControl.selectedSegmentIndex == 1 || index == 1)
        {
            if (index == 1)
            {
                
                self.tableView.alpha = 0.5;
                cell.alpha = 0.5;
                cell.userInteractionEnabled = NO;
                segmentedControl.selectedSegmentIndex = index;
                NSString* formattedNumber = [NSString stringWithFormat:@"%@",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"total_km"]];
                double distance = [formattedNumber doubleValue];
                cell.owner_name.hidden= YES;
                cell.lbl_time.hidden = YES;
                cell.lbl_Distance.hidden = YES;
                cell.star_Image.hidden = YES;
                cell.lbl_time1.hidden = NO;
                cell.lbl_Distance1.hidden = NO;
                cell.lbl_Distance1.text = [NSString stringWithFormat:@"Distance:%.02f Km",distance];
                cell.lbl_time1.text = [NSString stringWithFormat:@"Temps estimatif:%@ min",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"total_min"]];
                [cell.order_img sd_setImageWithURL:[NSURL URLWithString:[[order_collection objectAtIndex:indexPath.section ] valueForKey:@"transport_img"]] placeholderImage:[UIImage imageNamed:@""]];
                NSArray *d_logi = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"d_longitude"];
                NSArray *d_lati = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"d_latitude"];
                NSArray *s_logi = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"s_longitude"];
                NSArray *s_lati = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"s_latitude" ];
                
                NSString *d_log = [NSString stringWithFormat:@"%@",d_logi];
                NSString *d_lat = [NSString stringWithFormat:@"%@",d_lati];
                NSString *s_log = [NSString stringWithFormat:@"%@",s_logi];
                NSString *s_lat = [NSString stringWithFormat:@"%@",s_lati];
                double de_log = [d_log doubleValue];
                double de_lat = [d_lat doubleValue];
                
                double so_log = [s_log doubleValue];
                double so_lat = [s_lat doubleValue];
                
                sourceloaction = [[CLLocation alloc] initWithLatitude:de_lat longitude:de_log];
                
                [self getAddressFromLocation:sourceloaction complationBlock:^(NSString * address) {
                    if(address) {
                        place_name = address;
                        
                        cell.lbl_Source_name.text = [NSString stringWithFormat:@"%@",place_name];
                    }
                }];
                
                destinationloaction = [[CLLocation alloc] initWithLatitude:so_lat longitude:so_log];
                
                [self getAddressFromLocation:destinationloaction complationBlock:^(NSString * address) {
                    if(address) {
                        place_name = address;
                        cell.lbl_Destination_name.text = [NSString stringWithFormat:@"%@",place_name];
                        
                    }
                }];
                NSString *order_count = [NSString stringWithFormat:@"%@",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"order_count"]];
                
                if ([order_count isEqualToString:@"1"])
                {
                    cell.Image_orderstatus.image = [UIImage imageNamed:@"rings_ndot_img.png"];
                    
                }
                else{
                    cell.Image_orderstatus.image = [UIImage imageNamed:@"rings_img.png"];
                }

            }
    }
    else if (segmentedControl.selectedSegmentIndex == 2 || index == 2)
    {
        if (index == 2)
        {
            self.tableView.alpha = 1.0;
            cell.opaque = 1.0;
            cell.userInteractionEnabled = YES;
            segmentedControl.selectedSegmentIndex = index;
            NSString* formattedNumber = [NSString stringWithFormat:@"%@",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"total_km"]];
             NSString* owner = [NSString stringWithFormat:@"%@",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"walker_name"]];
            double distance = [formattedNumber doubleValue];
            cell.owner_name.hidden= NO;
            cell.lbl_time1.hidden = YES;
            cell.lbl_Distance1.hidden = YES;
            cell.star_Image.hidden = NO;
            cell.lbl_Distance.hidden = NO;
            cell.lbl_time.hidden = NO;
            cell.owner_name.text = owner;
            cell.lbl_Distance.text = [NSString stringWithFormat:@"Distance:%.02f Km",distance];
            cell.lbl_time.text = [NSString stringWithFormat:@"Temps estimatif:%@ min",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"total_min"]];
            [cell.order_img sd_setImageWithURL:[NSURL URLWithString:[[order_collection objectAtIndex:indexPath.section ] valueForKey:@"transport_img"]] placeholderImage:[UIImage imageNamed:@""]];
            NSArray *d_logi = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"d_longitude"];
            NSArray *d_lati = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"d_latitude"];
            NSArray *s_logi = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"s_longitude"];
            NSArray *s_lati = [[order_collection objectAtIndex:indexPath.section]valueForKey:@"s_latitude" ];
            
            NSString *d_log = [NSString stringWithFormat:@"%@",d_logi];
            NSString *d_lat = [NSString stringWithFormat:@"%@",d_lati];
            NSString *s_log = [NSString stringWithFormat:@"%@",s_logi];
            NSString *s_lat = [NSString stringWithFormat:@"%@",s_lati];
            double de_log = [d_log doubleValue];
            double de_lat = [d_lat doubleValue];
            
            double so_log = [s_log doubleValue];
            double so_lat = [s_lat doubleValue];
            
            sourceloaction = [[CLLocation alloc] initWithLatitude:de_lat longitude:de_log];
            
            [self getAddressFromLocation:sourceloaction complationBlock:^(NSString * address) {
                if(address) {
                    place_name = address;
                    
                    cell.lbl_Source_name.text = [NSString stringWithFormat:@"%@",place_name];
                }
            }];
            
            destinationloaction = [[CLLocation alloc] initWithLatitude:so_lat longitude:so_log];
            
            [self getAddressFromLocation:destinationloaction complationBlock:^(NSString * address) {
                if(address) {
                    place_name = address;
                    cell.lbl_Destination_name.text = [NSString stringWithFormat:@"%@",place_name];
                    
                }
            }];
            NSString *order_count = [NSString stringWithFormat:@"%@",[[order_collection objectAtIndex:indexPath.section]valueForKey:@"order_count"]];
            
            if ([order_count isEqualToString:@"1"])
            {
                cell.Image_orderstatus.image = [UIImage imageNamed:@"rings_ndot_img.png"];
                
            }
            else{
                cell.Image_orderstatus.image = [UIImage imageNamed:@"rings_img.png"];
            }

        }

    }
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *pack_id = [NSString stringWithFormat:@"%@",[[order_collection objectAtIndex:indexPath.section] valueForKey:@"id"]];
    
    [[NSUserDefaults standardUserDefaults]setObject:pack_id forKey:@"pack_id"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    if (segmentedControl.selectedSegmentIndex == 0 || index == 0)
    {
        if (index == 0)
        {
            OrderDetailsVC *odv = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderDetailsVC"];
            [self.navigationController pushViewController:odv animated:YES];
            

        }
    }
    if (segmentedControl.selectedSegmentIndex == 2 || index == 2) {
        if (index == 2)
        {
          
            RecapitulatifVC *RVC = [self.storyboard instantiateViewControllerWithIdentifier:@"RecapitulatifVC"];
            [self.navigationController pushViewController:RVC animated:YES];
           
        }
    }
    
    
    
}

- (IBAction)menu_btn:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];

}
@end
