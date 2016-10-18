//
//  PaymentViewController.h
//  Stripe
//
//  Created by Alex MacCaw on 3/4/13.
//
//

#import <UIKit/UIKit.h>
#import <Stripe.h>
#import "PaymentViewControllerVC.h"

@class PaymentViewController;
@protocol STPBackendCharging;

@protocol PaymentViewControllerDelegate<NSObject>

- (void)paymentViewController:(PaymentViewController *)controller didFinish:(NSError *)error;

@end

@interface PaymentViewController : UIViewController

@property (nonatomic) NSDecimalNumber *amount;
@property (nonatomic, weak) id<STPBackendCharging> backendCharger;
@property (nonatomic, weak) id<PaymentViewControllerDelegate> delegate;

@end
