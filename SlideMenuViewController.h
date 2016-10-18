//
//  SlideMenuViewController.h
//  Ruchiz
//
//  Created by ganesh on 6/14/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuViewController : UIViewController{
    
}
- (IBAction)profil:(id)sender;
- (IBAction)vos_factures:(id)sender;
- (IBAction)moyens_de_paiements:(id)sender;
- (IBAction)notification:(id)sender;
- (IBAction)offers:(id)sender;
- (IBAction)reglages:(id)sender;
- (IBAction)centre_daide:(id)sender;
- (IBAction)exit:(id)sender;

@property (weak, nonatomic) IBOutlet UILabel *user_name;

@property (weak, nonatomic) IBOutlet UIImageView *profile_pic;
@property (weak, nonatomic) IBOutlet UIImageView *profile_bg_pic;

@end
