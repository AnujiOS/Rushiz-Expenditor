//
//  CommandPageViewController.m
//  Ruchiz
//
//  Created by ganesh on 4/30/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "CommandPageViewController.h"
#import "ViewController.h"
#import "SlideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"

@interface CommandPageViewController ()

@end

@implementation CommandPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"lattt"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"loggg"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Order"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"longitude_deprt"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"latitude_deprt"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"destination_longitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"destination_latitude"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"transport_id"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"condition_value"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
}

- (IBAction)command:(id)sender
{
    ViewController *log = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:log animated:YES];
}

- (IBAction)menu_btn:(id)sender
{
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}
@end
