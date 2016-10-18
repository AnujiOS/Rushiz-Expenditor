//
//  ReglagesVC.m
//  Ruchiz
//
//  Created by mac on 9/5/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "ReglagesVC.h"
#import "CommandPageViewController.h"
#import "AproposVC.h"
#import "MFSideMenu.h"

@interface ReglagesVC ()
{
    UIImage *unselectedImage;
    UIImage *selectedImage;
}
@end

@implementation ReglagesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    unselectedImage = [UIImage imageNamed:@"notifi_unchecked.png"];
    selectedImage = [UIImage imageNamed:@"notifi_checked.png"];
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

- (IBAction)aBtnAutoriser_Clicked:(UIButton *)sender
{
   
    if ([sender isSelected]) {
        [sender setImage:unselectedImage forState:UIControlStateNormal];
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
        [sender setSelected:NO];
    } else
    {
        
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [sender setImage:selectedImage forState:UIControlStateSelected];
        [sender setSelected:YES];
    }
}

- (IBAction)aBtnSon_Clicked:(UIButton *)sender
{
    if ([sender isSelected]) {
        [sender setImage:unselectedImage forState:UIControlStateNormal];
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [sender setSelected:NO];
    } else {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];

        
        [sender setImage:selectedImage forState:UIControlStateSelected];
        [sender setSelected:YES];
    }

}

- (IBAction)aBtnDissocier_Clicked:(UIButton *)sender {
}

- (IBAction)aBtnApropos_Clicked:(UIButton *)sender
{
    AproposVC *payment = [self.storyboard instantiateViewControllerWithIdentifier:@"AproposVC"];
    [self.navigationController pushViewController:payment animated:NO];

}
@end
