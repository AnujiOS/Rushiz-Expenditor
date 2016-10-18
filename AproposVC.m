//
//  AproposVC.m
//  Ruchiz
//
//  Created by mac on 9/5/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "AproposVC.h"
#import "CommandPageViewController.h"
#import "ReglagesVC.h"
#import "AproposSubVC.h"

@interface AproposVC ()

@end

@implementation AproposVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"aBtnGooglePlayClicked"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"aBtnFacebookClicked"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"aBtnConfidentialiteClicked"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"aBtnGeneralesClicked"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
   
}



- (IBAction)aBtn_backClicked:(id)sender
{
    ReglagesVC *RV = [self.storyboard instantiateViewControllerWithIdentifier:@"ReglagesVC"];
    [self.navigationController pushViewController:RV animated:NO];
}

- (IBAction)aBtnGooglePlayClicked:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aBtnGooglePlayClicked"];
    AproposSubVC *RV = [self.storyboard instantiateViewControllerWithIdentifier:@"AproposSubVC"];
    RV.flag = @"AproposVC";
    [self.navigationController pushViewController:RV animated:NO];

}

- (IBAction)aBtnFacebookClicked:(UIButton *)sender
{
   [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aBtnFacebookClicked"];
   AproposSubVC *RV = [self.storyboard instantiateViewControllerWithIdentifier:@"AproposSubVC"];
    RV.flag = @"AproposVC";
   [self.navigationController pushViewController:RV animated:NO];
}

- (IBAction)aBtnConfidentialiteClicked:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aBtnConfidentialiteClicked"];
    AproposSubVC *RV = [self.storyboard instantiateViewControllerWithIdentifier:@"AproposSubVC"];
    RV.flag = @"AproposVC";
    [self.navigationController pushViewController:RV animated:NO];
}

- (IBAction)aBtnGeneralesClicked:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aBtnGeneralesClicked"];
    AproposSubVC *RV = [self.storyboard instantiateViewControllerWithIdentifier:@"AproposSubVC"];
    RV.flag = @"AproposVC";
    [self.navigationController pushViewController:RV animated:NO];
}

@end
