//
//  faites_vos_choixCollectionViewCell.h
//  Ruchiz
//
//  Created by ganesh on 5/31/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface faites_vos_choixCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *collection_img;
@property (weak, nonatomic) IBOutlet UIImageView *transport_disable_img;

@property (weak, nonatomic) IBOutlet UIImageView *service_collection_img;
@property (weak, nonatomic) IBOutlet UIImageView *article_img;
@property (weak, nonatomic) IBOutlet UIImageView *dimension_img;
@property (weak, nonatomic) IBOutlet UILabel *collection_name;
@property (weak, nonatomic) IBOutlet UILabel *service_name;
@property (weak, nonatomic) IBOutlet UILabel *dimension_name;
@property (weak, nonatomic) IBOutlet UILabel *article_name;

@end
