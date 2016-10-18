//
//  InfosutileVC.h
//  Ruchiz
//
//  Created by mac on 9/2/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfosutileVC : UIViewController<UITextFieldDelegate,UIScrollViewDelegate>

- (IBAction)aBtn_OKClicked:(id)sender;

- (IBAction)aBtn_BackClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UITextView *aDetailtextfeild;

@property (weak, nonatomic) IBOutlet UITextField *aTextfieldTelephone;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
- (IBAction)aTelephone_clicked:(id)sender;

@end
