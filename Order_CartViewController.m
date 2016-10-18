//
//  Order_CartViewController.m
//  Ruchiz
//
//  Created by ganesh on 6/6/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "Order_CartViewController.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "Order_CartTableViewCell.h"
#import <PayPalConfiguration.h>
#import "CommandPageViewController.h"
#import "SlideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "PaymentViewControllerVC.h"
#import "FZAccordionTableView.h"
#import "AccordionHeaderView.h"
#import "ViewController.h"
#import "InfosutileVC.h"

static NSString *const kTableViewCellReuseIdentifier = @"Cell";
@interface Order_CartViewController ()
{
    NSMutableArray *listorder;
    NSMutableArray *cart_contains;
    NSMutableArray *Expandlist;
    double TotalCount;
    NSString *cart_id;
    NSString *total_euro;
    NSString *cart_type;
    NSString *last_four;
    NSString *trans_id;
    NSString *te;
    NSMutableDictionary *saveddataDictionary;
    AccordionHeaderView *object_num;
    NSInteger addition;
    NSString *strTotal1;
    NSString *t_speed;
    NSString *condition;
    NSString *condition_value;
    BOOL check;
    NSMutableArray *data_arry;
    NSMutableArray *data;
    NSMutableArray *data_temp;
    NSArray *total;
}
@property (weak, nonatomic) IBOutlet FZAccordionTableView *tableView;
@end

@implementation Order_CartViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    check = YES;
    data_temp = [[NSMutableArray alloc]init];
    data = [[NSMutableArray alloc] init];
    data_arry = [[NSMutableArray alloc]init];
    object_num = [[AccordionHeaderView alloc] init];
    addition = 1;
    self.tableView.allowMultipleSectionsOpen = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"AccordionHeaderView" bundle:nil] forHeaderFooterViewReuseIdentifier:kAccordionHeaderViewReuseIdentifier];
  
    saveddataDictionary = [[NSMutableDictionary alloc]init];
    Expandlist = [[NSMutableArray alloc]init];
    cart_contains = [[NSMutableArray alloc]init];
    [self cart];
    _tableView.backgroundColor=[UIColor clearColor];
    self.table_view_bg.backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"search_layout_bg.png"]];;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Order"];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

#pragma  marl --> UITableview Datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%ld",(long)section);
    NSDictionary *d = [[cart_contains objectAtIndex:section]valueForKey:@"list_order"];
        [Expandlist addObject:d];

    if ([Expandlist containsObject:d]) {
         return d.count;
    }
    else
       
    return 0;

    
   }
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    NSString *sectionName;
    for (int s = 0; s< cart_contains.count; s++) {
        if (section == s) {
            
            sectionName = [NSString stringWithFormat:@"%d",s];
            object_num.number_qty.text = [NSString stringWithFormat:@"%d",s];
        }

    }
       return sectionName;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSString *str = [NSString stringWithFormat:@"%d",addition];
//    object_num.number_qty.text= str;
//    addition++;
    return [cart_contains count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 125.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kDefaultAccordionHeaderViewHeight;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [self tableView:tableView heightForRowAtIndexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section
{
    return [self tableView:tableView heightForHeaderInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
        Order_CartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kTableViewCellReuseIdentifier forIndexPath:indexPath];
    
        if(!cell){
            cell=[[Order_CartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTableViewCellReuseIdentifier];
        }
         NSString *selectedindexpath=[NSString stringWithFormat:@"%ld",(long)indexPath.section];
    
    cell.aBtn_packdetails.tag = indexPath.row;
    cell.ABtn_Orderedit.tag = indexPath.row;
   
    [cell.aBtn_packdetails addTarget:self action:@selector(myAction:) forControlEvents:UIControlEventTouchUpInside];
    
   

    
    NSString *order_id = [[cart_contains objectAtIndex:indexPath.section] valueForKey:@"id"];
    NSLog(@"%@",order_id);
    
    NSString *transport_id = [[cart_contains objectAtIndex:indexPath.section]valueForKey:@"t_id"];
    NSLog(@"%@",transport_id);
    NSArray *d_lat = [[[cart_contains objectAtIndex:indexPath.section]valueForKey:@"list_order" ] valueForKey:@"d_lati"];
    NSArray *d_log = [[[cart_contains objectAtIndex:indexPath.section]valueForKey:@"list_order" ] valueForKey:@"d_longi"];
    
    NSArray *max_point = [[cart_contains objectAtIndex:indexPath.section]valueForKey:@"max_point"];
    NSArray *total_point =[[cart_contains objectAtIndex:indexPath.section]valueForKey:@"total_point"];
    NSArray *total_km = [[cart_contains objectAtIndex:indexPath.section]valueForKey:@"total_km"];
    
    
    NSString *total_kilometer = [NSString stringWithFormat:@"%@",total_km];
    NSString *max_pointOrder = [NSString stringWithFormat:@"%@",max_point];
    NSString *total_pointOrder = [NSString stringWithFormat:@"%@",total_point];
    
    condition_value = [[cart_contains objectAtIndex:indexPath.section]valueForKey:@"condition_value"];
    NSLog(@"%@",condition_value);
    
    condition = [[cart_contains objectAtIndex:indexPath.section]valueForKey:@"condition"];
    NSLog(@"%@",condition);
    
    t_speed = [[cart_contains objectAtIndex:indexPath.section]valueForKey:@"t_speed"];
    NSLog(@"%@",t_speed);
    
    cell.aBtn_deletepack.tag = indexPath.row;
    if ([condition isEqualToString:@"Max minutes"])
    {
        float max_value = [condition_value floatValue];
        float t_speed_float = [t_speed floatValue];
        float min_per_km = 60/t_speed_float;
        condition_value = [NSString stringWithFormat:@"%f",max_value/min_per_km];
    }
    else if ([condition isEqualToString:@"Max kms"])
    {
        
    }
    
    //NSArray *temo_id = [[[cart_contains objectAtIndex:indexPath.section]valueForKey:@"list_order"]valueForKey:@"id" ];
    
    
    
    NSString *d_lati = [NSString stringWithFormat:@"%@",[d_lat lastObject]];
    NSString *d_lagi = [NSString stringWithFormat:@"%@",[d_log lastObject]];
    [[NSUserDefaults standardUserDefaults] setObject:total_kilometer forKey:@"total_km"];
    [[NSUserDefaults standardUserDefaults] setObject:condition forKey:@"condition"];
    [[NSUserDefaults standardUserDefaults] setObject:condition_value forKey:@"condition_value"];
    [[NSUserDefaults standardUserDefaults] setObject:max_pointOrder forKey:@"max_pointOrder"];
    [[NSUserDefaults standardUserDefaults] setObject:total_pointOrder forKey:@"total_pointOrder"];
    [[NSUserDefaults standardUserDefaults] setObject:order_id forKey:@"Order"];
    [[NSUserDefaults standardUserDefaults] setObject:d_lati forKey:@"lattt"];
    [[NSUserDefaults standardUserDefaults] setObject:d_lagi forKey:@"loggg"];
    [[NSUserDefaults standardUserDefaults]setObject:transport_id forKey:@"transport_id"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     data=[[cart_contains objectAtIndex:indexPath.section]valueForKey:@"list_order"];
   
         if ([[[cart_contains valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.section]]valueForKey:@"list_order"]valueForKey:[NSString stringWithFormat:@"%ld",(long)indexPath.row]])
         {
             NSString *tag = [NSString stringWithFormat:@"%ld",(long)cell.ABtn_Orderedit.tag];
             NSLog(@"%@",tag);
//             if (cell.ABtn_Orderedit.tag > 1) {
//                 cell.ABtn_Orderedit.hidden =YES;
//             }
//             else{
//                 cell.ABtn_Orderedit.hidden = NO;
//             }
             if (data.count >1) {
                 cell.ABtn_Orderedit.hidden =YES;
             }
             else{
                 cell.ABtn_Orderedit.hidden = NO;

             }
             NSLog(@"Sucess");
             
             [cell.article_img sd_setImageWithURL:[[data objectAtIndex:indexPath.row]valueForKey:@"slink_image"] placeholderImage:[UIImage imageNamed:@"yellow_search_img.png"]];
             NSString *estimate_time = [NSString stringWithFormat:@"%@ %@ %@",@"Temps estimé:",[[data objectAtIndex:indexPath.row]valueForKey:@"min"],@"Min"];
             cell.estimate_time.text = estimate_time;
             NSString *distance_km = [NSString stringWithFormat:@"%@ %@ %@",@"Distance:",[[data objectAtIndex:indexPath.row]valueForKey:@"total_km"],@"Km"];
             cell.distance.text = distance_km;
//             double distance = [distance_km doubleValue];
//             cell.distance.text = [NSString stringWithFormat:@"%.2f %@",distance,@"Km"];
             cell.article_type.text = [[data objectAtIndex:indexPath.row]valueForKey:@"services_name"];
             NSString *prize = [NSString stringWithFormat:@"%@",[[data objectAtIndex:indexPath.row] valueForKey:@"total_euro"]];
             double price = [prize doubleValue];
             cell.article_price.text = [NSString stringWithFormat:@"%.2f %@",price,@"\u20ac"];
             
             

         }
            _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
            self.tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    
//    UITableViewHeaderFooterView* header =[self.tableView headerViewForSection:indexPath.section];
//    NSLog(@"Header text = %@", header.textLabel.text);
//    object_num.number_qty.text = [NSString stringWithFormat:@"%@",header.textLabel.text];
            return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return [tableView dequeueReusableHeaderFooterViewWithIdentifier:kAccordionHeaderViewReuseIdentifier];
    
}

#pragma mark - <FZAccordionTableViewDelegate> -
- (void)tableView:(FZAccordionTableView *)tableView willOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header
{
    
}

- (void)tableView:(FZAccordionTableView *)tableView didOpenSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header
{
  
}

- (void)tableView:(FZAccordionTableView *)tableView willCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header
{
   
}

- (void)tableView:(FZAccordionTableView *)tableView didCloseSection:(NSInteger)section withHeader:(UITableViewHeaderFooterView *)header
{
   
}
//- (IBAction)pay_cmd:(id)sender;
-(IBAction)myAction:(UIButton *)sender
{
    
    
    //data_temp = [data mutableCopy];
    NSLog(@"%d",sender.tag);
    //NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    //cart_contains
    NSArray *temp_details = [[data objectAtIndex:sender.tag]valueForKey:@"details"];
    //NSArray *temp_details = [[[cart_contains valueForKey:[NSString stringWithFormat:@"%ld",(long)sender.tag]]valueForKey:@"list_order"]valueForKey:[NSString stringWithFormat:@"%ld",(long)selectedIndexPath.row]];
    NSString *tempo_details = [NSString stringWithFormat:@"%@",[temp_details description]];
    NSLog(@"%@",tempo_details);
    
    NSArray *temp_phone = [[data objectAtIndex:sender.tag]valueForKey:@"phone"];
    NSString *tempo_phone = [NSString stringWithFormat:@"%@",[temp_phone description]];
    NSLog(@"%@",tempo_details);
    
    NSArray *temo_id = [[data objectAtIndex:sender.tag]valueForKey:@"id"];
    NSString *temp_id = [NSString stringWithFormat:@"%@",[temo_id description]];
    NSLog(@"%@",temp_id);
    [[NSUserDefaults standardUserDefaults]setObject:temp_id forKey:@"tempo"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    [[NSUserDefaults standardUserDefaults] setObject:tempo_details forKey:@"tempo_details"];
    [[NSUserDefaults standardUserDefaults]setObject:tempo_phone forKey:@"tempo_phone"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    InfosutileVC *back = [self.storyboard instantiateViewControllerWithIdentifier:@"InfosutileVC"];
    [self.navigationController pushViewController:back animated:YES];
   
}

-(void)cart
{
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
            [afn getDataFromPath:FILE_VIEW_CART withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Validation Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         cart_contains = [[response valueForKey:@"result"] mutableCopy];
                         [_tableView reloadData];
                         for (int t=0; t<cart_contains.count; t++)
                         {
                             NSMutableArray *strTotal = [[NSMutableArray alloc ]init ];
                             strTotal = [[[cart_contains objectAtIndex:t]valueForKey:@"list_order" ] valueForKey:@"total_euro"];
                             for (int v=0; v<strTotal.count; v++) {
                                 strTotal1 = [NSString stringWithFormat:@"%@",[strTotal objectAtIndex:v]];
                                 TotalCount =TotalCount+[strTotal1 doubleValue];
                             }
                             
                         }
                         total_euro = [NSString stringWithFormat:@"%.2f %@",TotalCount,@"\u20ac"];
                         self.total_prize.text =total_euro;
                         [[NSUserDefaults standardUserDefaults] setObject:total_euro forKey:@"total_Amount"];
                         [[NSUserDefaults standardUserDefaults] synchronize];
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
-(void)order_confirm
{
    if([[AppDelegate sharedAppDelegate]connected])
    {
        if ([[AppDelegate sharedAppDelegate]connected])
        {
            
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:cart_type forKey:@"card_type"];
            [dictParam setValue:strUserID forKey:@"id"];
            [dictParam setValue:last_four forKey:@"last_four"];
            [dictParam setValue:trans_id forKey:@"trans_id"];
            [dictParam setValue:te forKey:@"total_euro"];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_PAYMENT_ORDER withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Validation Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         CommandPageViewController *back = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
                         [self.navigationController pushViewController:back animated:YES];

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)pay_cmd:(id)sender
{
    data_arry = [[NSMutableArray alloc]init];
    data_arry = [cart_contains mutableCopy];
    
    for (int i =0; i<data_arry.count; i++)
    {
       NSArray *details = [[[data_arry objectAtIndex:i] valueForKey:@"list_order"] valueForKey:@"details"];
       NSString *data = [NSString stringWithFormat:@"%@",[details objectAtIndex:0]];
     
       NSArray *phone = [[[data_arry objectAtIndex:i] valueForKey:@"list_order"] valueForKey:@"phone"];
       NSString *phone_num = [NSString stringWithFormat:@"%@",[phone objectAtIndex:0]];
     
        if ([data isEqualToString:@""] && [phone_num isEqualToString:@""])
        {
            check = false;
        }
        
    }
    if (check == TRUE) {
        PaymentViewControllerVC *back = [self.storyboard instantiateViewControllerWithIdentifier:@"PaymentViewControllerVC"];
        [self.navigationController pushViewController:back animated:YES];
    }
    else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:@"Please fill Package Details" delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
        [alert show];

    }
    
}

//- (IBAction)min_order:(id)sender
//{
//  //  UIButton *btn = (UIButton *)sender;
//    cart_id = [[data objectAtIndex:sender.tag] valueForKey:@"id"];
//    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_tableView];
//    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:touchPoint];
//    [data removeObjectAtIndex:indexPath.row];
//    [_tableView reloadData];
//    [self delete_order];
//    
//}

- (IBAction)min_order:(UIButton *)sender
{
    cart_id = [[data objectAtIndex:sender.tag] valueForKey:@"id"];
    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_tableView];
    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:touchPoint];
    //[data removeObjectAtIndex:indexPath.row];
    
    

    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"Etes-vous sûr que vous voulez supprimer?"
                                                   delegate:self
                                          cancelButtonTitle:@"Annuler"
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 100;
    
    [alert show];
    
    //  UIButton *btn = (UIButton *)sender;
//    cart_id = [[data objectAtIndex:sender.tag] valueForKey:@"id"];
//    CGPoint touchPoint = [sender convertPoint:CGPointZero toView:_tableView];
//    NSIndexPath *indexPath = [_tableView indexPathForRowAtPoint:touchPoint];
//    [data removeObjectAtIndex:indexPath.row];
//    [_tableView reloadData];
//    [self delete_order];
    

}
-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 100)
    {
         if (buttonIndex == 1)
         {
             [self delete_order];
             [_tableView reloadData];

         }
        else if (buttonIndex == 0)
        {
            
        }
    }
}

- (IBAction)add_order:(id)sender
{
    CommandPageViewController *back = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Order"];
    [self.navigationController pushViewController:back animated:NO];

}

- (IBAction)menu_btn:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];

}
-(void)delete_order
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
            [dictParam setValue:cart_id forKey:@"delete_id"];

            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_CART_DELETE withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Delete Order Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         TotalCount = 0.00;
                             cart_contains = [[response valueForKey:@"result"] mutableCopy];
                             
                             [_tableView reloadData];
                             for (int t=0; t<cart_contains.count; t++)
                             {
                               
                                  total = [[[cart_contains objectAtIndex:t]valueForKey:[NSString stringWithFormat:@"%@",@"list_order"]]valueForKey:[NSString stringWithFormat:@"%@",@"total_euro"]];
//                                 NSString *strTotal =[NSString stringWithFormat:@"%@",total];
//                                
//                                 TotalCount =TotalCount+[strTotal doubleValue];
                                 
                                 
                              }
                         for (int z = 0; z<total.count; z++)
                         {
                             NSString *strTotal =[NSString stringWithFormat:@"%@",[total objectAtIndex:z]];
                             
                             TotalCount =TotalCount+[strTotal doubleValue];
                             self.payment_cmd.enabled = YES;

                         }
                         
//                             NSString *strTotal =[NSString stringWithFormat:@"%@",total];
//                         
//                             TotalCount =TotalCount+[strTotal doubleValue];
                             total_euro = [NSString stringWithFormat:@"%.2f %@",TotalCount,@"\u20ac"];
                             self.total_prize.text =total_euro;
                         if (TotalCount == 0.00) {
                             
                             self.payment_cmd.enabled = NO;
                         }

                         [[NSUserDefaults standardUserDefaults] setObject:total_euro forKey:@"total_Amount"];
                         [[NSUserDefaults standardUserDefaults] synchronize];

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
@end
