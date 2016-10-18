//
//  PaiementVC.h
//  Ruchiz
//
//  Created by mac on 9/7/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>





@interface PaiementVC : UIViewController
- (IBAction)aBtnPaymentClicked:(UIButton *)sender;
- (IBAction)aBtnBackClicked:(UIButton *)sender;
@property(nonatomic, strong, readwrite) NSString *CardType;
@property (nonatomic) NSDecimalNumber *amount;
@property (nonatomic,strong)NSString *str_amount;
@property (weak, nonatomic) IBOutlet UITableView *table_view;
- (IBAction)BtnCancle:(id)sender;



@end
