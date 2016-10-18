//
//  HistoriqueVC.m
//  Ruchiz
//
//  Created by mac on 9/5/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "HistoriqueVC.h"
#import "CommandPageViewController.h"
#import "MFSideMenu.h"

@interface HistoriqueVC ()

@end

@implementation HistoriqueVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
@end
