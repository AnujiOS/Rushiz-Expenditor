//
//  OrderStatusTableViewCell.m
//  Ruchiz
//
//  Created by mac on 7/8/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "OrderStatusTableViewCell.h"
#import "CommandPageViewController.h"

@implementation OrderStatusTableViewCell

@synthesize navigation;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)btn_suivre:(id)sender
{
    
    
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    CommandPageViewController *vc = [sb instantiateViewControllerWithIdentifier:@"CommandPageViewController"];
//    navigation = [[UINavigationController alloc] initWithRootViewController:vc];
//    self.window.rootViewController = navigation;
//    [self.window makeKeyAndVisible];
}
@end
