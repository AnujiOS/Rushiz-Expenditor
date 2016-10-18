//
//  AideVC.m
//  Ruchiz
//
//  Created by mac on 9/5/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "AideVC.h"
#import "CommandPageViewController.h"
#import "AproposSubVC.h"
#import "MFSideMenu.h"

@interface AideVC ()
{
    NSString *str;
}
@end

@implementation AideVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"aBtnCompteClicked"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"aBtnPaiementClicked"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"aBtnCommentClicked"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)aBtn_backClicked:(id)sender
{
    CommandPageViewController *payment = [self.storyboard instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
      [self.menuContainerViewController setMenuState:MFSideMenuStateLeftMenuOpen];
    [self.navigationController pushViewController:payment animated:NO];
}

- (IBAction)aBtnCompteClicked:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aBtnCompteClicked"];
    AproposSubVC *ASV = [self.storyboard instantiateViewControllerWithIdentifier:@"AproposSubVC"];
    ASV.flag = @"Aide";
    [self.navigationController pushViewController:ASV animated:NO];

}

- (IBAction)aBtnPaiementClicked:(id)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aBtnPaiementClicked"];
    AproposSubVC *ASV = [self.storyboard instantiateViewControllerWithIdentifier:@"AproposSubVC"];
    ASV.flag = @"Aide";
    [self.navigationController pushViewController:ASV animated:NO];

}

- (IBAction)aBtnCommentClicked:(UIButton *)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"aBtnCommentClicked"];
    AproposSubVC *ASV = [self.storyboard instantiateViewControllerWithIdentifier:@"AproposSubVC"];
    ASV.flag = @"Aide";
    [self.navigationController pushViewController:ASV animated:NO];

}
@end
