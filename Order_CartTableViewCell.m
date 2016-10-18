//
//  Order_CartTableViewCell.m
//  Ruchiz
//
//  Created by ganesh on 6/8/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "Order_CartTableViewCell.h"
#import "InfosutileVC.h"

@implementation Order_CartTableViewCell
@synthesize navigation;
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)aBtn_packinfo:(id)sender
{
//    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    InfosutileVC *vc = [sb instantiateViewControllerWithIdentifier:@"InfosutileVC"];
//    navigation = [[UINavigationController alloc] initWithRootViewController:vc];
//    self.window.rootViewController = navigation;
//    [self.window makeKeyAndVisible];
}
@end
