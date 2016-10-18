//
//  AproposSubVC.m
//  Ruchiz
//
//  Created by mac on 9/7/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "AproposSubVC.h"
#import "AproposVC.h"
#import "AideVC.h"

@interface AproposSubVC ()

{
    NSString *Aide;
    NSString *Apropos;
}
@end

@implementation AproposSubVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    Aide = @"Aide";
    Apropos = @"AproposVC";
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"aBtnGooglePlayClicked"])
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]] ;
        [self.aWebView loadRequest: request];

    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"aBtnFacebookClicked"])
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]] ;
        [self.aWebView loadRequest: request];

    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"aBtnConfidentialiteClicked"])
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]] ;
        [self.aWebView loadRequest: request];
        
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"aBtnGeneralesClicked"])
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]] ;
        [self.aWebView loadRequest: request];
        
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"aBtnCompteClicked"])
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://yahoo.com"]] ;
        [self.aWebView loadRequest: request];
        
    }
    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"aBtnPaiementClicked"])
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://yahoo.com"]] ;
        [self.aWebView loadRequest: request];
        
    }

    else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"aBtnCommentClicked"])
    {
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://yahoo.com"]] ;
        [self.aWebView loadRequest: request];
        
    }
    
 }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)aBtnBackClicked:(id)sender
{
    if ([self.flag isEqualToString:@"Aide"]) {
        AideVC *AV = [self.storyboard instantiateViewControllerWithIdentifier:@"AideVC"];
        [self.navigationController pushViewController:AV animated:NO];
        
    }
    else if ([self.flag isEqualToString:@"AproposVC"]){
        AproposVC *AV = [self.storyboard instantiateViewControllerWithIdentifier:@"AproposVC"];
        [self.navigationController pushViewController:AV animated:NO];
    }

}
@end
