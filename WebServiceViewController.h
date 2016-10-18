//
//  WebServiceViewController.h
//  Diet Calorie Counter
//
//  Created by User Name on 5/17/13.
//  Copyright (c) 2013 xoomsolutions. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "Reachability.h"
#import <SystemConfiguration/SystemConfiguration.h>



@protocol WebServiceDelegate <NSObject>
@optional
- (void)webserviceConnection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)webserviceConnectionDidFinishLoading:(NSURLConnection *)connection successFullyGotData:(NSMutableData *)data currentReqMethod:(NSString *)strCurrentReqMethod;

- (void)webserviceconnection:(NSURLConnection *)connection   didSendBodyData:(NSInteger)bytesWritten
 totalBytesWritten:(NSInteger)totalBytesWritten
   totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite;

@end

@interface WebServiceViewController : UIViewController

+ (WebServiceViewController*) wsVC;

@property(nonatomic,retain)id <WebServiceDelegate> delegate;
@property(nonatomic,strong)NSMutableData *responseData;
@property(nonatomic,strong)NSString *strCurrentRequestMethod;



@property (nonatomic, strong) NSString *strURL;
@property (nonatomic, strong) NSString *jsonString;
@property (nonatomic, strong) NSString *strCallHttpMethod;
@property (nonatomic, strong) NSMutableData *activeDownload;
@property (nonatomic, strong) NSURLConnection *imageConnection;
@property (nonatomic, strong) NSString *strMethodName;

- (NSMutableDictionary *)sendRequestForMethod:(NSString *)strMethod withParameter:(NSMutableDictionary *)dictDetail;

- (NSMutableDictionary *)sendRequestForMethod:(NSString *)strMethod withParameter:(NSMutableDictionary *)dictDetail withImageArray:(NSMutableArray *)arrImages;

- (NSMutableDictionary *)sendRequestWithParameter:(NSMutableDictionary *)dictDetail;
- (NSMutableDictionary *)sendReqGoogleApiWith:(NSMutableDictionary *)dictDetail;
- (BOOL)connected;
-(NSMutableDictionary *)PostDataWithImage:(UIImage *)profileImage withParameter:(NSMutableDictionary *)dictParameters withImageKey:(NSString *)strImageKey;
+ (NSMutableDictionary *)simpleURLFetch:(NSString * )methodName param:(NSDictionary *)jsonDict;

-(void)PostData:(NSMutableDictionary *)dictDetail;

@end
