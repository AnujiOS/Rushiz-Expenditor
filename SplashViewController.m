//
//  SplashViewController.m
//  Ruchiz
//
//  Created by ganesh on 6/10/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "SplashViewController.h"
#import "SliderPagesViewController.h"
#import "SlideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"
#import "UIImage+GIF.h"

@interface SplashViewController ()
{
    NSTimer *timer;
}
@end

@implementation SplashViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    timer = [NSTimer scheduledTimerWithTimeInterval:3
                                             target:self
                                           selector:@selector(countDown)
                                           userInfo:nil
                                            repeats:NO];
    _image_view.image= [UIImage sd_animatedGIFNamed:@"sp1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
-(void)countDown
{
    SliderPagesViewController *slide = [self.storyboard instantiateViewControllerWithIdentifier:@"SliderPagesViewController"];
    [self.navigationController pushViewController:slide animated:YES];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
}

@end
