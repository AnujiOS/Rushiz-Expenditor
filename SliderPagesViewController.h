//
//  SliderPagesViewController.h
//  Ruchiz
//
//  Created by ganesh on 4/28/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SliderPagesViewController : UIViewController
{
    int pagecount;
    NSTimer *aTimer;
}
@property (weak, nonatomic) IBOutlet UIImageView *sider_image;
@property (weak, nonatomic) IBOutlet UIPageControl *page_control;
- (IBAction)page_control:(id)sender;

- (IBAction)new_account:(id)sender;


@property (weak, nonatomic) IBOutlet UIButton *newaccount;
@property (weak, nonatomic) IBOutlet UIButton *connection;
- (IBAction)start_connection:(id)sender;

@end
