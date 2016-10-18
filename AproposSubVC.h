//
//  AproposSubVC.h
//  Ruchiz
//
//  Created by mac on 9/7/16.
//  Copyright © 2016 ganesh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AproposSubVC : UIViewController<UIWebViewDelegate>
- (IBAction)aBtnBackClicked:(id)sender;


@property (weak, nonatomic) IBOutlet UIWebView *aWebView;
@property(strong,nonnull)NSString *flag;
@end
