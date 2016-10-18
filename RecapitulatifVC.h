//
//  RecapitulatifVC.h
//  Ruchiz
//
//  Created by mac on 9/22/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecapitulatifVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lbl_totalPrize;
@property (weak, nonatomic) IBOutlet UILabel *lbl_serviceName;
@property (weak, nonatomic) IBOutlet UILabel *lbl_numProduct;
@property (weak, nonatomic) IBOutlet UILabel *lbl_Date;
- (IBAction)Btn_noter_votre_coursier:(id)sender;

@end
