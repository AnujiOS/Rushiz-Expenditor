//
//  SliderPagesViewController.m
//  Ruchiz
//
//  Created by ganesh on 4/28/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "SliderPagesViewController.h"
#import "LoginPageViewController.h"
#import "RegistrationPageViewController.h"
#import "SlideMenuViewController.h"
#import "MFSideMenuContainerViewController.h"
#import "MFSideMenu.h"

@interface SliderPagesViewController ()
{
    NSArray *images;
    int pageNo;
    int pageNumber;
    NSMutableArray *imagessliderarr;
}

@end

@implementation SliderPagesViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    pageNo = 0;
    aTimer = [NSTimer scheduledTimerWithTimeInterval:4.0 target:self selector:@selector(aBtnLoginClicked1:) userInfo:nil repeats:YES];
    _page_control.currentPage = 0;
//    images = [[NSArray alloc] initWithObjects:[UIImage imageNamed:@"slider1.png"],[UIImage imageNamed:@"slider_2.png"],[UIImage imageNamed:@"slider3.png" ],[UIImage imageNamed:@"slider4.png" ],[UIImage imageNamed:@"slider5.png" ], [UIImage imageNamed:@"slider6.png" ],[UIImage imageNamed:@"slider7.png" ],nil];
   [_sider_image setUserInteractionEnabled:YES];
//    NSLog(@"Image name %@",images);
//    _page_control.currentPage = 0;
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
    [_sider_image addGestureRecognizer:swipeLeft];
  
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipe:)];
    swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
    [_sider_image addGestureRecognizer:swipeRight];
    
//    imagessliderarr = [[NSMutableArray alloc] init];
//    for (int i = 0; i < images.count; i++) {
//            [imagessliderarr addObject:[images objectAtIndex:i]];
//           }
//
//    _sider_image.animationImages =imagessliderarr;
//    _sider_image.animationDuration = 10.0;
   
    //self.page_control.currentPage = _sider_image.animationRepeatCount;
   
       // [_sider_image startAnimating];
  
//    if (_sider_image.isAnimating == YES) {
//        self.page_control.currentPage = self.page_control.currentPage+1;
//    }

}

- (IBAction)aBtnLoginClicked1:(id)sender
{
    pagecount++;
    
    if (pagecount==7)
    {
        [_sider_image stopAnimating];
        [aTimer invalidate];
        aTimer=nil;
    }
    else
    {
        _page_control.currentPage = pagecount;
       images = [[NSArray alloc] initWithObjects:@"slider1.png",@"slider_2.png",@"slider3.png",@"slider4.png",@"slider5.png",@"slider6.png",@"slider7.png",nil];
        NSString *strimagename =[NSString stringWithFormat:@"%@",[images objectAtIndex:pagecount]];
        self.sider_image.image =[UIImage imageNamed:strimagename];
    }
    //[aSliderImageView stopAnimating];
    //[self AnimationMethod];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    _page_control.currentPage = 0;
    _sider_image.image =[UIImage imageNamed:@"slider1.png"];

    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [self.menuContainerViewController setPanMode:MFSideMenuPanModeNone];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)timer
{
    
}

- (void)swipe:(UISwipeGestureRecognizer *)swipeRecogniser
{
    if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionLeft)
    {
        self.page_control.currentPage +=1;
        if(self.page_control.currentPage == 0)
        {
            _sider_image.image = [UIImage imageNamed:@"slider1.png"];
        }
        else if(self.page_control.currentPage == 1)
        {
            _sider_image.image = [UIImage imageNamed:@"slider_2.png"];
        }
        else if(self.page_control.currentPage == 2)
        {
            _sider_image.image = [UIImage imageNamed:@"slider3.png"];
        }
        else if(self.page_control.currentPage == 3)
        {
            _sider_image.image = [UIImage imageNamed:@"slider4.png"];
        }
        else if(self.page_control.currentPage == 4)
        {
            _sider_image.image = [UIImage imageNamed:@"slider5.png"];
        }
        else if(self.page_control.currentPage == 5)
        {
            _sider_image.image = [UIImage imageNamed:@"slider6.png"];
        }
        else if(self.page_control.currentPage == 6)
        {
            _sider_image.image = [UIImage imageNamed:@"slider7.png"];
        }
       
    }
    else if ([swipeRecogniser direction] == UISwipeGestureRecognizerDirectionRight)
    {
        self.page_control.currentPage -=1;
        if(self.page_control.currentPage == 0)
        {
            _sider_image.image = [UIImage imageNamed:@"slider1.png"];
        }
        else if(self.page_control.currentPage == 1)
        {
            _sider_image.image = [UIImage imageNamed:@"slider_2.png"];
        }
        else if(self.page_control.currentPage == 2)
        {
            _sider_image.image = [UIImage imageNamed:@"slider3.png"];
        }
        else if(self.page_control.currentPage == 3)
        {
            _sider_image.image = [UIImage imageNamed:@"slider4.png"];
        }
        else if(self.page_control.currentPage == 4)
        {
            _sider_image.image = [UIImage imageNamed:@"slider5.png"];
        }
        else if(self.page_control.currentPage == 5)
        {
            _sider_image.image = [UIImage imageNamed:@"slider6.png"];
        }
        else if(self.page_control.currentPage == 6)
        {
            _sider_image.image = [UIImage imageNamed:@"slider7.png"];
        }
        
        
    }
   
    
}

- (IBAction)page_control:(id)sender
{
    
}
- (IBAction)new_account:(id)sender
{
    
    RegistrationPageViewController *rc = [self.storyboard instantiateViewControllerWithIdentifier:@"RegistrationPageViewController"];
    [self.navigationController pushViewController:rc animated:YES];
    
}
- (IBAction)start_connection:(id)sender
{
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"LoginStatus"];
    
    LoginPageViewController *log = [self.storyboard instantiateViewControllerWithIdentifier:@"LoginPageViewController"];
    [self.navigationController pushViewController:log animated:YES];

}
@end
