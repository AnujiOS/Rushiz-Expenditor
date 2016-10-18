//
//  MVPlaceSearchTextField.m
//  PlaceSearchAPIDEMO
//
//  Created by Mrugrajsinh Vansadia on 26/04/14.
//  Copyright (c) 2014 Mrugrajsinh Vansadia. All rights reserved.
//

#import "MVPlaceSearchTextField.h"
//#import "Macro.h"
#import "PlaceDetail.h"
#import "PlaceObject.h"
#import "MLPAutoCompleteTextField.h"
#import "ViewController.h"
#import "UtilityClass.h"
#import "Constants.h"



@interface MVPlaceSearchTextField ()<MLPAutoCompleteFetchOperationDelegate,MLPAutoCompleteSortOperationDelegate,MLPAutoCompleteTextFieldDataSource,MLPAutoCompleteTextFieldDelegate,PlaceDetailDelegate>{
    GMSPlacesClient *_placesClient;
}

@end


@implementation MVPlaceSearchTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/



-(void)awakeFromNib{

    self.autoCompleteDataSource=self;
    self.autoCompleteDelegate=self;
    self.autoCompleteFontSize=14;
    self.autoCompleteTableBorderWidth=0.0;
    self.showTextFieldDropShadowWhenAutoCompleteTableIsOpen=NO;
    self.autoCompleteShouldHideOnSelection=YES;
    self.maximumNumberOfAutoCompleteRows= 5;
    self.autoCompleteShouldHideClosingKeyboard = YES;
    _placesClient = [GMSPlacesClient sharedClient];
    
}
#pragma mark - Datasource Autocomplete
//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    

        NSString *aQuery=textField.text;
        [NSObject cancelPreviousPerformRequestsWithTarget:_placesClient selector:@selector(autocompleteQuery:bounds:filter:callback:) object:self];
    
        if(aQuery.length>0){
            GMSAutocompleteFilter *filter = [[GMSAutocompleteFilter alloc] init];
            //filter.country = @"fr";
            //filter.type = kGMSPlacesAutocompleteTypeFilterRegion;
            filter.type = kGMSPlacesAutocompleteTypeFilterNoFilter;
            

        
            [_placesClient autocompleteQuery:aQuery
                                      bounds:nil
                                      filter:filter
                                    callback:^(NSArray *results, NSError *error) {
                                        if (error != nil) {
                                            NSLog(@"Autocomplete error %@", [error localizedDescription]);
                                            handler(nil);
                                            return;
                                        }
                                        if(results.count>0){
                                        NSMutableArray *arrfinal=[NSMutableArray array];
                                        for (GMSAutocompletePrediction* result in results) {
                                            NSDictionary *aTempDict =  [NSDictionary dictionaryWithObjectsAndKeys:result.attributedFullText.string,@"description",result.placeID,@"reference", nil];
                                            PlaceObject *placeObj=[[PlaceObject alloc]initWithPlaceName:[aTempDict objectForKey:@"description"]];
                                            placeObj.userInfo=aTempDict;
                                            [arrfinal addObject:placeObj];

                                        }
                                            handler(arrfinal);
                                        }else{
                                            handler(nil);
                                        }
                                    }];
        }else{
            handler(nil);
        }
}

#pragma mark - AutoComplete Delegates
-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField didSelectAutoCompleteString:(NSString *)selectedString withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([APPDELEGATE connected])
    {
        [APPDELEGATE showLoadingWithTitle:NSLocalizedString(@"LOADING", nil)];
    
    PlaceObject *placeObj=(PlaceObject*)selectedObject;
    NSString *aStrPlaceReferance=[placeObj.userInfo objectForKey:@"reference"];
    PlaceDetail *placeDetail=[[PlaceDetail alloc]initWithApiKey:_strApiKey];
    placeDetail.delegate=self;
    [placeDetail getPlaceDetailForReferance:aStrPlaceReferance];
    
    [_placesClient lookUpPlaceID:aStrPlaceReferance callback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Place Details error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place placeID %@", place.placeID);
            NSLog(@"Place attributions %@", place.attributions);
            NSLog(@"Place Coordinate %f",place.coordinate.latitude);
            NSLog(@"Place Coordinate %f",place.coordinate.longitude);
            
           
            
            NSString *longitude = [NSString stringWithFormat:@"%f",place.coordinate.longitude];
            NSString *latitude = [NSString stringWithFormat:@"%f",place.coordinate.latitude];
            NSString *name = [NSString stringWithFormat:@"%@",place.name];
            NSString *formattedAddress = [NSString stringWithFormat:@"%@",place.formattedAddress];
            
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isDepartClicked"])
            {
                ViewController *vc = [[ViewController alloc]init];
                [[NSUserDefaults standardUserDefaults]setObject:longitude forKey:@"longitude_deprt"];
                [[NSUserDefaults standardUserDefaults]setObject:latitude forKey:@"latitude_deprt"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Seach_Depart"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Seach_Destination"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //[vc deptsearch_method_smallmap];
                //[vc deptsearch_method_bigmap];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"deptsearch_method_smallmap"object:vc];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"deptsearch_method_bigmap"object:vc];

               
            }
            else if ([[NSUserDefaults standardUserDefaults] boolForKey:@"isDestinationClicked"])
            {
                ViewController *vc = [[ViewController alloc]init];
                [[NSUserDefaults standardUserDefaults]setObject:longitude forKey:@"destination_longitude"];
                [[NSUserDefaults standardUserDefaults]setObject:latitude forKey:@"destination_latitude"];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"Seach_Depart"];
                [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Seach_Destination"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //[vc destination_search_method_smallmap];
                //[vc destination_search_method_bigmap];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"destination_search_method_smallmap"object:vc];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"destination_search_method_bigmap"object:vc];
                
            }
            
            else
            {
                
            }
            
            [[NSUserDefaults standardUserDefaults]setObject:name forKey:@"name"];
            [[NSUserDefaults standardUserDefaults]setObject:formattedAddress forKey:@"formattedAddress"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
        else {
            NSLog(@"No place details for %@", aStrPlaceReferance);
        }
        [APPDELEGATE hideLoadingView];

    }];
   
}
}
-(BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
         shouldConfigureCell:(UITableViewCell *)cell
      withAutoCompleteString:(NSString *)autocompleteString
        withAttributedString:(NSAttributedString *)boldedString
       forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
           forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_placeSearchDelegate respondsToSelector:@selector(placeSearch:ResultCell:withPlaceObject:atIndex:)]){
        [_placeSearchDelegate placeSearch:self ResultCell:cell withPlaceObject:autocompleteObject atIndex:indexPath.row];
    }else{
        cell.contentView.backgroundColor=[UIColor whiteColor];
    }
    return YES;
}

-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willShowAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    if([_placeSearchDelegate respondsToSelector:@selector(placeSearchWillShowResult:)]){
        [_placeSearchDelegate placeSearchWillShowResult:self];
    }
}
-(void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField willHideAutoCompleteTableView:(UITableView *)autoCompleteTableView{
    if([_placeSearchDelegate respondsToSelector:@selector(placeSearchWillHideResult:)]){
        [_placeSearchDelegate placeSearchWillHideResult:self];
    }
}


#pragma mark - PlaceDetail Delegate

-(void)placeDetailForReferance:(NSString *)referance didFinishWithResult:(GMSPlace*)resultDict{
        //Respond To Delegate
    [_placeSearchDelegate placeSearch:self ResponseForSelectedPlace:resultDict];
}


#pragma mark - URL Operation
- (NSDictionary *)stringWithUrl:(NSURL *)url
{
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url
                                                cachePolicy:NSURLRequestReturnCacheDataElseLoad
                                            timeoutInterval:30];
    // Fetch the JSON response
    NSData *urlData;
    NSURLResponse *response;
    NSError *error;
    
    // Make synchronous request
    urlData = [NSURLConnection sendSynchronousRequest:urlRequest
                                    returningResponse:&response
                                                error:&error];
    if(urlData){
        // Construct a Dictionary around the Data from the response
        NSDictionary *aDict=[NSJSONSerialization JSONObjectWithData:urlData options:NSJSONReadingAllowFragments error:&error];
        return aDict;
    }else{return nil;}
    
}



@end
