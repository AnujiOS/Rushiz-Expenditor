//
//  MVPlaceSearchTextField.h
//  PlaceSearchAPIDEMO
//
//  Created by Mrugrajsinh Vansadia on 26/04/14.
//  Copyright (c) 2014 Mrugrajsinh Vansadia. All rights reserved.
//



#import <Foundation/Foundation.h>
#import "MLPAutoCompleteTextField.h"
#import "MVPlaceSearchTextField.h"
#import "PlaceObject.h"
#import <GoogleMaps/GoogleMaps.h>
#import "AppDelegate.h"

@protocol PlaceSearchTextFieldDelegate;
@class ViewController;
@protocol MyProtocol;

@protocol MyProtocol <NSObject>

//- (void)deptsearch_method_smallmap;
//-(void)deptsearch_method_bigmap;
//-(void)destination_search_method_smallmap;
//-(void)destination_search_method_bigmap;
@end

@interface MVPlaceSearchTextField : MLPAutoCompleteTextField
@property(nonatomic,strong)NSString *strApiKey;
@property(nonatomic,strong)IBOutlet id<PlaceSearchTextFieldDelegate>placeSearchDelegate;
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict;

@end

@protocol PlaceSearchTextFieldDelegate <NSObject>

-(void)placeSearch:(MVPlaceSearchTextField*)textField ResponseForSelectedPlace:(GMSPlace*)responseDict;
-(void)placeSearchWillShowResult:(MVPlaceSearchTextField*)textField;
-(void)placeSearchWillHideResult:(MVPlaceSearchTextField*)textField;
-(void)placeSearch:(MVPlaceSearchTextField*)textField ResultCell:(UITableViewCell*)cell withPlaceObject:(PlaceObject*)placeObject atIndex:(NSInteger)index;
@end

