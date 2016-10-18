//
//  AccordionHeaderView.m
//  FZAccordionTableViewExample
//
//  Created by Krisjanis Gaidis on 6/7/15.
//  Copyright (c) 2015 Fuzz Productions, LLC. All rights reserved.
//

#import "AccordionHeaderView.h"
#import "ViewController.h"
#import "AppDelegate.h"
#import "Order_CartViewController.h"
#import "FZAccordionTableView.h"
#import "faites_vos_choix.h"

@implementation AccordionHeaderView 
{
    NSString *Orderid;
    NSString *d_lat;
    NSString *d_log;
    NSString *valueToSave;
    NSString *total;
    NSString *max;
    NSString *condition_value;
    NSString *total_km;
    float highest_km;
    float used_km;
    NSString *condition;
    int i;
}
@synthesize navigation;

- (void)viewDidLoad
{
    
}
- (IBAction)aBtnOrderAdd:(id)sender {
    
//    Orderid = [[NSUserDefaults standardUserDefaults]stringForKey:@"Order"];
//    d_lat = [[NSUserDefaults standardUserDefaults]stringForKey:@"lattt"];
//    d_log = [[NSUserDefaults standardUserDefaults]stringForKey:@"loggg"];
    //self.flag = YES;
    valueToSave = @"button";
    [[NSUserDefaults standardUserDefaults] setObject:valueToSave forKey:@"click_btn"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    
    [self tappedHeaderView];
   
    
}
- (void)tappedHeaderView
{
    max = [[NSUserDefaults standardUserDefaults] valueForKey:@"max_pointOrder"];
    total = [[NSUserDefaults standardUserDefaults] valueForKey:@"total_pointOrder"];
    condition_value = [[NSUserDefaults standardUserDefaults] valueForKey:@"condition_value"];
    condition = [[NSUserDefaults standardUserDefaults]valueForKey:@"condition" ];
    total_km = [[NSUserDefaults standardUserDefaults] valueForKey:@"total_km"];
    
    highest_km = [condition_value floatValue];
    used_km = [total_km floatValue];
    
    if ([max isEqualToString:total])
    {
        NSLog(@"Cart is Full");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Panier plein" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        if ([condition isEqualToString:@"No required"]) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
            vc.flag=@"Sub_order";
            navigation = [[UINavigationController alloc] initWithRootViewController:vc];
            self.window.rootViewController = navigation;
            [self.window makeKeyAndVisible];
            
        }
        else{
            if (used_km < highest_km)
            {
                UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                ViewController *vc = [sb instantiateViewControllerWithIdentifier:@"ViewController"];
                vc.flag=@"Sub_order";
                navigation = [[UINavigationController alloc] initWithRootViewController:vc];
                self.window.rootViewController = navigation;
                [self.window makeKeyAndVisible];
                
            }
            else{
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Panier plein" delegate:self cancelButtonTitle:@"Cancle" otherButtonTitles:nil, nil];
                [alert show];
                
            }

            }
    }
}





@end
