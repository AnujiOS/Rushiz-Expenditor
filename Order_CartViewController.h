//
//  Order_CartViewController.h
//  Ruchiz
//
//  Created by ganesh on 6/6/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>


@class Order_CartViewController;

@protocol Order_CartViewControllerDelegate;
@interface Order_CartViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
    
}

- (IBAction)min_order:(UIButton *)sender;

- (IBAction)add_order:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *table_view_bg;

- (IBAction)menu_btn:(id)sender;

//- (BOOL)acceptCreditCards;
//- (void)setAcceptCreditCards:(BOOL)processCreditCards;
//- (void)setPayPalEnvironment:(NSString *)environment;
@property (weak, nonatomic) IBOutlet UITableView *table_view;
@property (nonatomic, strong, readwrite) IBOutlet UIButton *payment_cmd;
- (IBAction)pay_cmd:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *total_prize;
@property(nonatomic, strong, readwrite) NSString *environment;
@property(nonatomic, assign, readwrite) BOOL acceptCreditCards;
@property(nonatomic, strong, readwrite) NSString *resultText;
@property(weak, nonatomic) id <Order_CartViewControllerDelegate> delegate;
@property(nonatomic,strong)NSString *flag_btn;
- (void)update ;

@end
