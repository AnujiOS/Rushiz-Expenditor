//
//  faites_vos_choix.m
//  Ruchiz
//
//  Created by ganesh on 5/31/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import "faites_vos_choix.h"
#import "faites_vos_choixCollectionViewCell.h"
#import "AppDelegate.h"
#import "UtilityClass.h"
#import "Constants.h"
#import "WebServiceViewController.h"
#import "UIImageView+WebCache.h"
#import "ASIHTTPRequest.h"
#import "AFNHelper.h"
#import <QuartzCore/QuartzCore.h>
#import "Order_CartViewController.h"
#import "ViewController.h"
#import "OrderStatusVC.h"


@interface faites_vos_choix ()<UICollectionViewDataSource,UICollectionViewDelegate,UIScrollViewDelegate>
{
    NSString *total_euro_count;
    NSArray *img;
    int i ;
    NSString *s_id;
    NSString *a_id;
    NSString *strTID;
    NSString *D_id;
    NSString *order_conti;
    NSString *total_euro;
    NSString *max_point;
    int point;
    int count;
    NSString *qty ;
    NSString *euro;
    NSMutableArray *tran;
    NSMutableArray *undisable;
    NSIndexPath *myInitialIndexPath;
    BOOL initialScrollDone;
    
    int art_ptn;
    NSString *article_point;
    
    NSString *traport_euro;
    double tast_basci;
    NSString *str;
    NSString *kilo_meter;
    NSString *pts;
    NSString *duplicate_pts;
    NSString*max_updated_point;
    NSMutableArray *transport_id;
    NSMutableArray *service_id;
    NSMutableArray *article_id;
    NSString *temp_pts;
    NSMutableArray *dimension_id;
}@end

@implementation faites_vos_choix

- (void)viewDidLoad {
    [super viewDidLoad];
    int point01 = 0;
    pts = [NSString stringWithFormat:@"%d",point01];
     self.bg_1.hidden = NO;
    /////////////////////////
    //self.bg_1.hidden = YES;
    self.bg_2.hidden = YES;
    self.bg_3.hidden = YES;
    self.bg_4.hidden = YES;
    
    /////////////////////////
    self.btn_1.hidden = NO;
    self.btn_2.hidden = YES;
    self.btn_3.hidden = YES;
    self.btn_4.hidden = YES;
    /////////////////////////
    i = 1;
    count = 1;
    order_conti = [NSString stringWithFormat:@"%d",count];
    self.order_contity.text = order_conti;
    self.scroll_view.contentSize = CGSizeMake(320,900);
    //////////////////
   self.min_count_txtfield.text = @"min";
    self.euro_count_txtfield.text = @"\u20ac";
    self.point_count_txtfield.text = @"pts";
    
    _collection_view.allowsSelection=YES;
    _collection_view.allowsMultipleSelection = YES;
    /////////////////
    
    self.scroll_view.delegate = self;
    [self.scroll_view addSubview:self.collection_view];
    [self.scroll_view addSubview:self.service_collectionview];
    [self.scroll_view addSubview:self.article_collectionview];
    [self.scroll_view addSubview:self.dimension_collectionview];
    if ([[AppDelegate sharedAppDelegate]connected]){
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
       tran = [[NSMutableArray alloc]init];
        tran = [pref objectForKey:PREF_TRANSPORT];
//        if (!initialScrollDone) {
//            initialScrollDone = YES;
//            
//            [self.collection_view scrollToItemAtIndexPath:myInitialIndexPath
//                                        atScrollPosition:UICollectionViewScrollPositionRight animated:NO];
//        }
        transport = [tran valueForKey:@"result"];
    transport_img = [pref objectForKey:PREF_IMAGES];
        transport_euro =[pref objectForKey:PREF_EURO];
        [pref synchronize];
        self.service_collectionview.hidden = YES;
        self.article_collectionview.hidden = YES;
        self.lbl_service.hidden = YES;
        self.lbl_article.hidden = YES;
        self.lbl_dimension.hidden = YES;
        self.order_contity.hidden = YES;
        self.min_btn.hidden = YES;
        self.plus_btn.hidden = YES;
        self.validate_commd.hidden = YES;
        self.definir.hidden = YES;
        self.qte.hidden = YES;
        self.option_view.hidden=YES;
        total_euro = [NSString stringWithFormat:@"%2@",_euro_count_txtfield.text];
        
        kilo_meter = [[NSUserDefaults standardUserDefaults]
                                stringForKey:@"Kilo-meter"];;
      
        self.point_count_txtfield.hidden = YES;
        self.km_count_txtfield.text = kilo_meter;
        transport_id = [[NSMutableArray alloc] init];
        article_id = [[NSMutableArray alloc] init];
        service_id = [[NSMutableArray alloc] init];
        dimension_id = [[NSMutableArray alloc]init];
        
       }
  }


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.view layoutIfNeeded];
   // [self.collection_view scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
}

#pragma mark - DataSource Delegate Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView

{
    return 1;
  
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    if(collectionView == self.collection_view)
       
    {
        
        NSLog(@"transport collection image count: %lu", (unsigned long)[transport count]);
        
        return [transport count];
        
    }
    
    else if(collectionView == self.service_collectionview)
    {
        NSLog(@"service_resposne collection image count: %lu", (unsigned long)[sevices_response count]);
      
        return [sevices_response count];
        
    }
    else if(collectionView == self.article_collectionview)
        
    {
        
        NSLog(@"article_resposne collection image count: %lu", (unsigned long)[article_resposne count]);
        
        return [article_resposne count];
        
    }
    else if(collectionView == self.dimension_collectionview)
        
    {
        
        NSLog(@"article_resposne collection image count: %lu", (unsigned long)[dimesion_response count]);
        
        return [dimesion_response count];
        
    }

    else
        
    {
       
//        NSLog(@"Bottom collection image count: %d", [self.bottomImages count]);
//        
//        return [self.bottomImages count];

        return YES;
    }
    
    

    }


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
      faites_vos_choixCollectionViewCell *Cell;
    //UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];

    if(collectionView == self.collection_view)
        
    {
        
        Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        NSString *t_id = [NSString stringWithFormat:@"%@",[[transport objectAtIndex:indexPath.row] valueForKey:@"id"]];
        NSString *tras_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"transport_id"];
       
        NSString *temp = [NSString stringWithFormat:@"%@",[[transport objectAtIndex:indexPath.row]valueForKey:@"id"]];
        NSLog(@"%@",[[transport objectAtIndex:indexPath.row]valueForKey:@"id"]);
        
        if ([strTID isEqualToString:temp])
        {
            [Cell setAlpha:1];

            
        }
        else if (strTID != nil)
        {
            if (![strTID isEqualToString:temp])
            {
              
               [Cell setAlpha:0.5];
            }
        }

        transport_id = [[transport objectAtIndex:indexPath.row] valueForKey:@"id"];;
        
        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"transport_id"] != nil) {
            if ([t_id intValue]==[tras_id intValue])
            {
                Cell.userInteractionEnabled = YES;
                [Cell setAlpha:1];
            }
            else{
                Cell.userInteractionEnabled = NO;
                 [Cell setAlpha:0.5];
                
               // Cell.opaque = 0.2;//disable_img
            }
             [Cell.collection_img sd_setImageWithURL:[[transport objectAtIndex:indexPath.row]valueForKey:@"link_image"] placeholderImage:[UIImage imageNamed:@"yellow_search_img.png"]];

        }
           [Cell.collection_img sd_setImageWithURL:[[transport objectAtIndex:indexPath.row]valueForKey:@"link_image"] placeholderImage:[UIImage imageNamed:@"yellow_search_img.png"]];
            
            Cell.collection_name.text= [[transport objectAtIndex:indexPath.row]objectForKey:@"transt_name"];
        
       
    }
    
    else if (collectionView == self.service_collectionview)
        
    {
         Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
       [Cell.service_collection_img sd_setImageWithURL:[[sevices_response objectAtIndex:indexPath.row]valueForKey:@"link_image"] placeholderImage:[UIImage imageNamed:@"yellow_search_img.png"]];
    Cell.service_name.text= [[sevices_response objectAtIndex:indexPath.row]objectForKey:@"type_name"];
    }
    
    else if (collectionView == self.article_collectionview)
        
    {
        Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        
        NSString *temp = [NSString stringWithFormat:@"%@",[[article_resposne objectAtIndex:indexPath.row]valueForKey:@"id"]];
        NSLog(@"%@",[[article_resposne objectAtIndex:indexPath.row]valueForKey:@"id"]);
        
        if ([a_id isEqualToString:temp])
        {
           [Cell setAlpha:1];
        }
        else if (a_id != nil)
        {
            if (![a_id isEqualToString:temp])
            {
                [Cell setAlpha:0.5];
            }
        }

        
        [Cell.article_img sd_setImageWithURL:[[article_resposne objectAtIndex:indexPath.row]valueForKey:@"linkimage"] placeholderImage:[UIImage imageNamed:@"yellow_search_img.png"]];
       
        Cell.article_name.text= [[article_resposne objectAtIndex:indexPath.row]objectForKey:@"article_name"];
        if ([article_resposne count]== 0) {
            self.lbl_article.hidden = YES;
            
        }
    }
    else if (collectionView == self.dimension_collectionview)
        
    {//D_id
        self.order_contity.text = @"1";
        count = 1;
        Cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
        NSString *temp = [NSString stringWithFormat:@"%@",[[dimesion_response objectAtIndex:indexPath.row]valueForKey:@"id"]];
        NSLog(@"%@",[[dimesion_response objectAtIndex:indexPath.row]valueForKey:@"id"]);

        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"transport_id"] != nil)
        {
           
           temp_pts = [[NSUserDefaults standardUserDefaults]stringForKey:@"temp_pts"];
           pts = [NSString stringWithFormat:@"%@",temp_pts];
           
            NSString *final_point = [NSString stringWithFormat:@"%@",[[dimesion_response objectAtIndex:indexPath.row]valueForKey:@"pts"]];
            NSString *total_point = [[NSUserDefaults standardUserDefaults]stringForKey:@"total_pointOrder"];
            NSString *maxi_point = [[NSUserDefaults standardUserDefaults]stringForKey:@"max_pointOrder"];
            int final = [final_point intValue];
            int total = [total_point intValue];
            int max = [maxi_point intValue];
            int tip = total + final;
            
            if ( tip > max ) {
                Cell.userInteractionEnabled = NO;
                [Cell setAlpha:0.5];
            }
            else{
                Cell.userInteractionEnabled = YES;
                [Cell setAlpha:1];
            }
        }

        if ([D_id isEqualToString:temp])
        {
            [Cell setAlpha:1];
        }
        else if (D_id != nil)
        {
            if (![D_id isEqualToString:temp])
            {
                 [Cell setAlpha:0.5];
            }
        }
        
        [Cell.dimension_img sd_setImageWithURL:[[dimesion_response objectAtIndex:indexPath.row]valueForKey:@"linkimage"] placeholderImage:[UIImage imageNamed:@"yellow_search_img.png"]];
        Cell.dimension_name.text= [[dimesion_response objectAtIndex:indexPath.row]objectForKey:@"d_name"];
        if ([dimesion_response count]== 0) {
            self.lbl_dimension.hidden = YES;
        }
    }

    else
        
    {
//        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hpCell" forIndexPath:indexPath];
//        cell.cellImage.image = [self.bottomImages objectAtIndex:indexPath.item];
//        cell.backgroundColor = [UIColor clearColor];
       
    }
    
    return Cell;
}

//- (UIEdgeInsets)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    return UIEdgeInsetsMake(0, 5, 0, 0); // top, left, bottom, right
//}
//
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
//    
//    return 15.0;
//}
////-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionView *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
////{
////    return 10; // This is the minimum inter item spacing, can be more
////}
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
//    return 0.0;
//}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    faites_vos_choixCollectionViewCell *Cell;
 
    UICollectionViewCell *datasetCell =[collectionView cellForItemAtIndexPath:indexPath];
    
      if (collectionView == self.collection_view) {
       
        [APPDELEGATE showHUDLoadingView:@"Loading"];
         
          
          NSString *selected_transport = [transport objectAtIndex:indexPath.row];
         
        NSLog(@"Transport %@",selected_transport);
        //self.min_count_txtfield.text
        // NSString *total_min = [[transport objectAtIndex:indexPath.row]valueForKey:@"total_minut_km"];
        NSString *total_min = [NSString stringWithFormat:@"%@ %@",[[transport objectAtIndex:indexPath.row]valueForKey:@"total_minut_km" ],@"min"];
        self.min_count_txtfield.text = total_min;
        
        //self.euro_count_txtfield.text = [[transport objectAtIndex:indexPath.row]valueForKey:@"euro"];
        
        
        euro = [NSString stringWithFormat:@"%@",[[transport objectAtIndex:indexPath.row]valueForKey:@"euro"]];
        strTID = [NSString stringWithFormat:@"%@",[[transport objectAtIndex:indexPath.row]valueForKey:@"id"]];
        if (strTID) {
            
        }
        double euro_count = [euro doubleValue];
        self.euro_count_txtfield.text = [NSString stringWithFormat:@"%.2f %@",euro_count,@"\u20ac"];
       // self.euro_count_txtfield.text = euro;
        
         max_point = [NSString stringWithFormat:@"%@",[[transport objectAtIndex:indexPath.row]valueForKey:@"max_point"]];
        total_euro = euro;
        self.service_collectionview.hidden = NO;
        self.lbl_service.hidden = NO;
          [self.collection_view reloadData];
        [self service];
        //        NSString *disable = [[transport objectAtIndex:indexPath.row] valueForKey:@"disable"];
        //        if ([disable isEqualToString:@"YES"]) {
        //          Cell.userInteractionEnabled = NO;
        //
        //        }
        //        else{
        //            Cell.userInteractionEnabled = YES;
        //        }
        //
        i++;
        
        //////////////////////////////
        traport_euro = [NSString stringWithFormat:@"%2@",self.euro_count_txtfield.text];
        tast_basci = [traport_euro doubleValue];// Basic Value of Euro
        ///////////////////////////////////////
        self.bg_1.hidden = YES;
        self.bg_2.hidden = NO;
        self.bg_3.hidden = YES;
        self.bg_4.hidden = YES;
        self.btn_1.hidden = NO;
        self.btn_2.hidden = NO;
        self.btn_3.hidden = YES;
        self.btn_4.hidden = YES;
        
    }
    if (collectionView == self.service_collectionview) {
        [APPDELEGATE showHUDLoadingView:@"Loading"];
        NSString *selected_service = [sevices_response objectAtIndex:indexPath.row];
        NSLog(@"Service %@",selected_service);
         s_id = [NSString stringWithFormat:@"%@",[[sevices_response objectAtIndex:indexPath.row]valueForKey:@"id" ]];
        NSLog(@"SERVICE_ID %@",s_id);
        self.article_collectionview.hidden = NO;
        self.lbl_article.hidden = NO;
        
        [self article];
        self.bg_1.hidden = YES;
        self.bg_2.hidden = YES;
        self.bg_3.hidden = NO;
        self.bg_4.hidden = YES;
        self.btn_1.hidden = NO;
        self.btn_2.hidden = NO;
        self.btn_3.hidden = NO;
        self.btn_4.hidden = YES;
           }
    if (collectionView == self.article_collectionview) {
        [APPDELEGATE showHUDLoadingView:@"Loading"];
        NSString *selected_service = [article_resposne objectAtIndex:indexPath.row];
        NSLog(@"Service %@",selected_service);
        NSString *pts1 = [NSString stringWithFormat:@"%@%@",[[article_resposne objectAtIndex:indexPath.row]valueForKey:@"pts" ],@"pts"];
        NSLog(@"Point %@",pts1);
        self.point_count_txtfield.text = pts1;
        
       // [self article];
        a_id = [NSString stringWithFormat:@"%@",[[article_resposne objectAtIndex:indexPath.row]valueForKey:@"id" ]];
        self.dimension_collectionview.hidden = NO;
        self.lbl_dimension.hidden = NO;
        [self dimension];
        
        self.bg_1.hidden = YES;
        self.bg_2.hidden = YES;
        self.bg_3.hidden = YES;
        self.bg_4.hidden = NO;
        self.btn_1.hidden = NO;
        self.btn_2.hidden = NO;
        self.btn_3.hidden = NO;
        self.btn_4.hidden = NO;
        /////////////////
        article_point = [NSString stringWithFormat:@"%@",self.point_count_txtfield.text];
        art_ptn = [article_point intValue];// Basic Value of Point
        ///////////////////
                self.order_contity.text = @"1";
                count = 1;
                if ([[NSUserDefaults standardUserDefaults]stringForKey:@"transport_id"] != nil) {
                    temp_pts = [[NSUserDefaults standardUserDefaults]stringForKey:@"temp_pts"];
                    pts = [NSString stringWithFormat:@"%@",temp_pts];
                }

        
            }
    if (collectionView == self.dimension_collectionview)
    {

        NSString *selected_service = [dimesion_response objectAtIndex:indexPath.row];
        NSLog(@"Service %@",selected_service);
        D_id = [NSString stringWithFormat:@"%@",[[dimesion_response objectAtIndex:indexPath.row]valueForKey:@"id" ]];
        NSLog(@"Point %@",D_id);
        //self.point_count_txtfield.text = pts;
        pts = [NSString stringWithFormat:@"%@",[[dimesion_response objectAtIndex:indexPath.row]valueForKey:@"pts"]];
        duplicate_pts = [NSString stringWithFormat:@"%@",pts];
        // [self article];
        // a_id = [NSString stringWithFormat:@"%@",[[article_resposne objectAtIndex:indexPath.row]valueForKey:@"id" ]];
        self.option_view.hidden=NO;
        self.order_contity.hidden = NO;
        self.min_btn.hidden = NO;
         self.plus_btn.hidden = NO;
        self.validate_commd.hidden = NO;
        self.definir.hidden = NO;
        self.qte.hidden = NO;
        self.bg_1.hidden = YES;
        self.bg_2.hidden = YES;
        self.bg_3.hidden = YES;
        self.bg_4.hidden = NO;
        [self.dimension_collectionview reloadData];
    }
    
    else
    {
        
    }
            }



-(void)service{
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
    if([[AppDelegate sharedAppDelegate]connected])
    {
         if ([[AppDelegate sharedAppDelegate]connected])
        {
            
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            NSString *strdistance = [pref objectForKey:PARAM_DISTANCE];
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:strUserID forKey:@"id"];
        
            [dictParam setValue:strdistance forKey:PARAM_DISTANCE];
            
            
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_SERVICE withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"sevices Response ---> %@",response);
                 if (response)
                 {
                     if([[response valueForKey:@"success"]boolValue])
                     {
                         
                        sevices_response = [[NSMutableArray alloc]init];
                         sevices_response = [response valueForKey:@"result"];
                         
                         NSLog(@"sevices_response %@",sevices_response);
                         [self.service_collectionview reloadData];
                         self.service_collectionview.hidden = NO;
                        
                         [self.collection_view reloadData];
                        
                        
                     }
                     else
                     {
                         
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }
                  [APPDELEGATE hideLoadingView];
             }];
        }
        else
        {
                    }
    }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    [APPDELEGATE hideHUDLoadingView];
}

    
-(void)article
{
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
    if([[AppDelegate sharedAppDelegate]connected])
    {
               if ([[AppDelegate sharedAppDelegate]connected])
        {
            
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:strUserID forKey:@"id"];
            [dictParam setValue:strTID forKey:@"t_id"];
            [dictParam setValue:s_id forKey:@"s_id"];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_ARTICLE withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Article Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         
                         article_resposne = [[NSMutableArray alloc]init];
                         article_resposne = [response valueForKey:@"result"];
                         NSLog(@"ARticle_Resposne %@",article_resposne);
                         [self.article_collectionview reloadData];
                        
                         [self.collection_view reloadData];
                        
                         [self.service_collectionview reloadData];

                     }
                     else
                     {
                  
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }
                 [APPDELEGATE hideLoadingView];
             }];
        }
        else
        {
        }
    }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    [APPDELEGATE hideHUDLoadingView];
}

-(void)dimension
{
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
    if([[AppDelegate sharedAppDelegate]connected])
    {
               if ([[AppDelegate sharedAppDelegate]connected])
        {
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:strUserID forKey:@"id"];
            [dictParam setValue:a_id forKey:@"a_id"];
            [dictParam setObject:strTID forKey:@"t_id"];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_DIMENSION withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Article Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         
                         dimesion_response = [[NSMutableArray alloc]init];
                         dimesion_response = [response valueForKey:@"result"];
                         NSLog(@"ARticle_Resposne %@",dimesion_response);
                         [self.dimension_collectionview reloadData];
                         [self.collection_view reloadData];
                         [self.article_collectionview reloadData];
                         [self.service_collectionview reloadData];
                     }
                     else
                     {
                       
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }
                  [APPDELEGATE hideLoadingView];
             }];
        }
        else
        {
        }
    }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    [APPDELEGATE hideHUDLoadingView];
}
-(void)temp_order{
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
    [APPDELEGATE showHUDLoadingView:@"Loading..."];
    if([[AppDelegate sharedAppDelegate]connected])
    {
        //if(self.txt_mobile.text.length>0)
        if ([[AppDelegate sharedAppDelegate]connected])
        {
            
            // [[AppDelegate sharedAppDelegate]showLoadingWithTitle:NSLocalizedString(@"LOGIN", nil)];
            NSString *deprt_latitude = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"deprt_latitude"];
            NSString *deprt_longitude = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"deprt_longitude"];
            NSString *destination_latitude = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"destination_latitude"];
            NSString *destination_longitude = [[NSUserDefaults standardUserDefaults]
                    stringForKey:@"destination_longitude"];
            NSUserDefaults *pref=[NSUserDefaults standardUserDefaults];
            // NSString *strDeviceId=[pref objectForKey:PREF_DEVICE_TOKEN];
            NSString *strUserToken=[pref objectForKey:PREF_USER_TOKEN];
            NSString *strUserID = [pref objectForKey:PREF_USER_ID];
            NSString *strdistance = [pref objectForKey:PARAM_DISTANCE];
            NSString *euro_price = [NSString stringWithFormat:@"%2@",self.euro_count_txtfield.text];
             NSString *min = [NSString stringWithFormat:@"%@",self.min_count_txtfield.text];
            NSString *qty = [NSString stringWithFormat:@"%@",self.order_contity.text];
            NSString *point = [NSString stringWithFormat:@"%@",self.point_count_txtfield.text];
            NSString *pack_id = nil;
            NSString *order_id = [[NSUserDefaults standardUserDefaults]stringForKey:@"Order"];
            
            NSMutableDictionary *dictParam=[[NSMutableDictionary alloc]init];
            // [dictParam setValue:@"ios" forKey:PARAM_DEVICE_TYPE];
            [dictParam setValue:strUserToken forKey:@"token"];
            [dictParam setValue:strUserID forKey:@"u_id"];
            [dictParam setValue:strdistance forKey:@"total_km"];
            [dictParam setValue:total_euro forKey:@"euro"];//euro_price
             [dictParam setValue:min forKey:@"min"];
            [dictParam setValue:strTID forKey:@"t_id"];
             [dictParam setValue:s_id forKey:@"s_id"];
            [dictParam setValue:a_id forKey:@"a_id"];
             [dictParam setValue:D_id forKey:@"d_id"];
            [dictParam setValue:qty forKey:@"qty"];
            if (order_id == nil) {
                [dictParam setValue:@"" forKey:@"order_id"];
          }
         else{
               [dictParam setValue:order_id forKey:@"order_id"];
            }

            if (total_euro_count == nil) {
                [dictParam setValue:total_euro forKey:@"total_euro"];
            }
            else{
                [dictParam setValue:total_euro_count forKey:@"total_euro"];
            }
           // [dictParam setValue:total_euro_count forKey:@"total_euro"];//total_euro
            [dictParam setValue:deprt_longitude forKey:@"s_longi"];
            [dictParam setValue:deprt_latitude forKey:@"s_lati"];
            [dictParam setValue:destination_longitude forKey:@"d_longi"];
            [dictParam setValue:destination_latitude forKey:@"d_lati"];
            [dictParam setValue:pts forKey:@"points"];
            
            
            
            //[dictParam setValue:a_id forKey:@"a_id"];
            AFNHelper *afn=[[AFNHelper alloc]initWithRequestMethod:POST_METHOD];
            [afn getDataFromPath:FILE_ORDER withParamData:dictParam withBlock:^(id response, NSError *error)
             {
                 [[AppDelegate sharedAppDelegate]hideLoadingView];
                 
                 NSLog(@"Validation Response ---> %@",response);
                 if (response)
                 {
                     if([response valueForKey:@"success"])
                     {
                         Order_CartViewController *back = [self.storyboard instantiateViewControllerWithIdentifier:@"Order_CartViewController"];
                         [self.navigationController pushViewController:back animated:YES];//
                     }
                     else
                     {
                         UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"" message:[response valueForKey:@"error"] delegate:self cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil, nil];
                         [alert show];
                     }
                 }
                 [APPDELEGATE hideLoadingView];

             }];
        }
        else
        {
        }
    }
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Network Status", nil) message:NSLocalizedString(@"NO_INTERNET", nil) delegate:self cancelButtonTitle:nil otherButtonTitles:NSLocalizedString(@"OK", nil), nil];
        [alert show];
    }
    [APPDELEGATE hideHUDLoadingView];
}

-(void)count
{
    order_conti = [NSString stringWithFormat:@"%d",count];
    self.order_contity.text = order_conti;
}

- (IBAction)btn_min:(id)sender
{
   
    if (count > 1 )
    {
        count--;
        
        NSString *point_test = [NSString stringWithFormat:@"%@",self.point_count_txtfield.text];
        self.point_count_txtfield.text = [NSString stringWithFormat:@"%d%@",[point_test intValue]- art_ptn,@"pts"];
        self.order_contity.text = [NSString stringWithFormat:@"%d",count];
        NSString *euro_test = [NSString stringWithFormat:@"%@",self.euro_count_txtfield.text];
        self.euro_count_txtfield.text = [NSString stringWithFormat:@"%.2f%@",[euro_test doubleValue]- tast_basci,@"\u20ac"];
        total_euro_count = [NSString stringWithFormat:@"%@",self.euro_count_txtfield.text];
        //pts = [NSString stringWithFormat:@"%d",[duplicate_pts intValue]*count];
//        max_updated_point = [NSString stringWithFormat:@"%d",[max_updated_point intValue]+[duplicate_pts intValue]];
//        pts = [NSString stringWithFormat:@"%d",[pts intValue]-[duplicate_pts intValue]];

        int pts_min = [pts intValue];
        pts_min = pts_min - [duplicate_pts intValue];
        pts =[NSString stringWithFormat:@"%d",pts_min];
        temp_pts = [NSString stringWithFormat:@"%@",pts];
        
        [[NSUserDefaults standardUserDefaults]setObject:temp_pts forKey:@"temp_pts"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        [[NSUserDefaults standardUserDefaults] setObject:max_updated_point forKey:@"max_updated_point"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        str = [NSString stringWithFormat:@"%@",self.point_count_txtfield.text];
    }
}

- (IBAction)btn_plus:(id)sender
{
    if ([pts intValue] < [max_point intValue])
              
    {
        count++;

        int article_point = art_ptn;
        self.point_count_txtfield.text = [NSString stringWithFormat:@"%d%@",article_point*count,@"pts"];
        self.order_contity.text = [NSString stringWithFormat:@"%d",count];
        double tran_test = tast_basci;
        self.euro_count_txtfield.text = [NSString stringWithFormat:@"%.2f%@",tran_test*count,@"\u20ac"];
        total_euro_count = [NSString stringWithFormat:@"%@",self.euro_count_txtfield.text];
        int pts_total = [pts intValue];
//        if ([[NSUserDefaults standardUserDefaults]stringForKey:@"transport_id"]) {
//            
//             pts = [NSString stringWithFormat:@"%d",[pts intValue]*count];
//        }
//        else{
//        NSString *ptsss = [NSString stringWithFormat:@"%d",[duplicate_pts intValue]*count];
//        pts = [NSString stringWithFormat:@"%d",[duplicate_pts intValue]*count];
//        }
//        max_updated_point = [NSString stringWithFormat:@"%d",[max_point intValue]-[pts intValue]];
//        [[NSUserDefaults standardUserDefaults] setObject:max_updated_point forKey:@"max_updated_point"];
//        [[NSUserDefaults standardUserDefaults] synchronize];
//        str = [NSString stringWithFormat:@"%@",self.point_count_txtfield.text];
        
        pts_total = [duplicate_pts intValue]+pts_total;
        
        pts = [NSString stringWithFormat:@"%d",pts_total];
        
        temp_pts = [NSString stringWithFormat:@"%@",pts];
        [[NSUserDefaults standardUserDefaults]setObject:temp_pts forKey:@"temp_pts"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
}

-(IBAction)validate_cmd:(id)sender
{
        [self temp_order];
}
- (IBAction)back_btn:(id)sender
{
   // ViewController *back = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (IBAction)notation_btn:(id)sender
{
//    OrderStatusVC *status = [self.storyboard instantiateViewControllerWithIdentifier:@"OrderStatusVC"];
//    [self.navigationController pushViewController:status animated:YES];
    
}
@end
