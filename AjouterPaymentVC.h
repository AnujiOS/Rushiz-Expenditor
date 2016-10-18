//
//  AjouterPaymentVC.h
//  Ruchiz
//
//  Created by mac on 9/5/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AjouterPaymentVC : UIViewController
- (IBAction)aBtn_backClicked:(id)sender;
- (IBAction)aBtn_ajouter_la_carte:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *cardNumber;
@property (weak, nonatomic) IBOutlet UITextField *selectedMonth;
@property (weak, nonatomic) IBOutlet UITextField *selectedYear;
@property (weak, nonatomic) IBOutlet UITextField *CVCNumber;
@property(nonatomic, strong, readwrite) NSString *CardType;

- (IBAction)camera_clicked:(id)sender;

@end
