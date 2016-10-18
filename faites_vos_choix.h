//
//  faites_vos_choix.h
//  Ruchiz
//
//  Created by ganesh on 5/31/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface faites_vos_choix : UIViewController<UIScrollViewDelegate>

{
    NSMutableArray *transport;
    NSMutableArray *transport_img;
    NSMutableArray *transport_euro;
    NSMutableArray *service_img;
    NSMutableArray *article_img;
    NSMutableArray *delai_img;
    NSMutableArray *sevices_response;
    NSMutableArray *article_resposne;
    NSMutableArray *dimesion_response;
}
@property (weak, nonatomic) IBOutlet UITextField *km_count_txtfield;

@property (weak, nonatomic) IBOutlet UITextField *min_count_txtfield;
@property (weak, nonatomic) IBOutlet UITextField *euro_count_txtfield;
@property (weak, nonatomic) IBOutlet UITextField *point_count_txtfield;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll_view;
@property (weak, nonatomic) IBOutlet UITextField *order_contity;
- (IBAction)btn_min:(id)sender;
- (IBAction)btn_plus:(id)sender;
- (IBAction)validate_cmd:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *min_btn;
@property (weak, nonatomic) IBOutlet UIButton *plus_btn;
@property (weak, nonatomic) IBOutlet UIButton *validate_commd;
- (IBAction)notation_btn:(id)sender;

@property (weak, nonatomic) IBOutlet UICollectionView *collection_view;
@property (weak, nonatomic) IBOutlet UICollectionView *service_collectionview;
@property (weak, nonatomic) IBOutlet UICollectionView *article_collectionview;
@property (weak, nonatomic) IBOutlet UILabel *lbl_transport;
@property (weak, nonatomic) IBOutlet UILabel *lbl_service;
@property (weak, nonatomic) IBOutlet UILabel *lbl_article;
@property (weak, nonatomic) IBOutlet UICollectionView *dimension_collectionview;
@property (weak, nonatomic) IBOutlet UILabel *lbl_dimension;
- (IBAction)back_btn:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *definir;
@property (weak, nonatomic) IBOutlet UILabel *qte;

@property (weak, nonatomic) IBOutlet UIImageView *bg_1;
@property (weak, nonatomic) IBOutlet UIImageView *bg_2;

@property (weak, nonatomic) IBOutlet UIImageView *bg_3;

@property (weak, nonatomic) IBOutlet UIImageView *bg_4;

@property (weak, nonatomic) IBOutlet UIButton *btn_1;
@property (weak, nonatomic) IBOutlet UIView *option_view;

@property (weak, nonatomic) IBOutlet UIButton *btn_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_3;
@property (weak, nonatomic) IBOutlet UIButton *btn_4;
@property(strong,nonatomic)NSString *flag;


@end
