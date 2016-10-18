
#import "Constants.h"

NSString * const StripePublishableKey = @"pk_test_Q4wBmoIjldnMLfduK6au3Qrc";
NSString *const BackendChargeURLString = @"https://rushiz.herokuapp.com";
NSString *const AppleMerchantId = nil; // TODO: replace nil with your own value

// These can be found at https://www.parse.com/apps/stripe-test/edit#app_keys
NSString * const ParseApplicationId = nil; // TODO: replace nil with your own value
NSString * const ParseClientKey = nil; // TODO: replace nil with your own value

#pragma mark -
#pragma mark - APPLICATION NAME

NSString *const APPLICATION_NAME=@"Upper";

#pragma mark -
#pragma mark - Segue Identifier

NSString *const SEGUE_LOGIN=@"segueToLogin";
NSString *const SEGUE_SUCCESS_LOGIN=@"segueSuccessLogin";

NSString *const SEGUE_REGISTER=@"segueToRegister";
NSString *const SEGUE_MYTHINGS=@"segueToMyThings";
NSString *const SEGUE_PAYMENT=@"segueToPayment";
NSString *const SEGUE_PROFILE=@"segueToProfile";
NSString *const SEGUE_ABOUT=@"segueToAboutUs";
NSString *const SEGUE_PROMOTIONS=@"segueToPromotions";
NSString *const SEGUE_SHARE=@"segueToShare";
NSString *const SEGUE_SUPPORT=@"segueToSupport";
NSString *const SEGUE_ADD_PAYMENT=@"segueToAddPayment";
NSString *const SEGUE_TO_ACCEPT=@"segueToaccept";
NSString *const SEGUE_TO_DIRECT_LOGIN=@"segueToMapDirectLogin";
NSString *const SEGUE_TO_FEEDBACK=@"segueToFeedBack";
NSString *const SEGUE_TO_CONTACT=@"segueToContactUs";
NSString *const SEGUE_TO_HISTORY=@"segueToHistory";
NSString *const SEGUE_TO_ADD_CARD=@"segueToAddCard";
NSString *const SEGUE_TO_REFERRAL_CODE=@"segueToReferralCode";
NSString *const SEGUE_TO_APPLY_REFERRAL_CODE=@"segueToApplyReferral";



#pragma mark -
#pragma mark - Title

NSString *const TITLE_LOGIN=@"SIGN IN";
NSString *const TITLE_REGISTER=@"REGISTER";
NSString *const TITLE_MYTHINGS=@"MY THINGS";
NSString *const TITLE_PAYMENT=@"ADD PAYMENT";
NSString *const TITLE_PICKUP=@"PICK UP";
NSString *const TITLE_PROFILE=@"PROFILE";
NSString *const TITLE_ABOUT=@"ABOUT";
NSString *const TITLE_PROMOTIONS=@"PROMOTIONS";
NSString *const TITLE_SHARE=@"SHARE";
NSString *const TITLE_SUPPORT=@"SUPPORT";

#pragma mark -
#pragma mark - Prefences key

NSString *const PREF_DEVICE_TOKEN=@"deviceToken";
NSString *const PREF_USER_TOKEN=@"usertoken";
NSString *const PREF_USER_ID=@"userid";
NSString *const PREF_REQ_ID=@"requestid";
NSString *const PREF_IS_LOGIN=@"islogin";
NSString *const PREF_IS_LOGOUT=@"islogout";
NSString *const PREF_LOGIN_OBJECT=@"loginobject";
NSString *const PREF_IS_WALK_STARTED=@"iswalkstarted";
NSString *const PREF_REFERRAL_CODE=@"referral_code";
NSString *const PREF_IS_REFEREE=@"is_referee";
NSString *const PREF_FARE_AMOUNT=@"fare_amount";
NSString *const PRFE_HOME_ADDRESS=@"home_address";
NSString *const PREF_WORK_ADDRESS=@"work_address";
NSString *const PRFE_FARE_ADDRESS=@"fare_address";
NSString *const PRFE_PRICE_PER_DIST=@"price_dist";
NSString *const PRFE_PRICE_PER_TIME=@"price_time";
NSString *const PRFE_DESTINATION_ADDRESS=@"dist_address";
NSString *const PREF_IS_ETA=@"is_eta";
NSString *const PREF_IMAGES=@"link_image";
NSString *const PREF_EURO=@"euro";
NSString *const PREF_DISABLE=@"disable";
NSString *const PREF_TRANSPORT=@"transportobject";
NSString *const PREF_TOTAL_MINUT_KM=@"total_minut_km";
NSString *const PREF_TRANST_NAME=@"transt_name";
NSString *const PREF_DELIVERYBOY_IMAGE=@"Deliveryboy_image";
NSString *const PREF_DELIVERYBOY_NAME=@"Deliveryboy_name";

#pragma mark -
#pragma mark - WS METHODS

NSString *const FILE_REGISTER=@"register";
NSString *const FILE_LOGIN=@"login";
NSString *const FILE_THING=@"thing";
NSString *const FILE_ADD_CARD=@"addcardtoken";
NSString *const FILE_CREATE_REQUEST=@"createrequest";
NSString *const FILE_GET_REQUEST=@"getrequest";
NSString *const FILE_GET_REQUEST_LOCATION=@"getrequestlocation";
NSString *const FILE_GET_REQUEST_PROGRESS=@"requestinprogress";
NSString *const FILE_RATE_DRIVER=@"rating";
NSString *const FILE_PAGE=@"application/pages";
NSString *const FILE_APPLICATION_TYPE=@"application/types";
NSString *const FILE_FORGET_PASSWORD=@"application/forgot-password";
NSString *const FILE_UPADTE=@"update";
NSString *const FILE_HISTORY=@"history";
NSString *const FILE_GET_CARDS=@"cards";
NSString *const FILE_SELECT_CARD=@"card_selection";
NSString *const FILE_REQUEST_PATH=@"requestpath";
NSString *const FILE_REFERRAL=@"referral";
NSString *const FILE_CANCEL_REQUEST=@"cancelrequest";
NSString *const FILE_APPLY_REFERRAL=@"apply-referral";
NSString *const FILE_GET_PROVIDERS=@"provider_list";
NSString *const FILE_PAYMENT_TYPE=@"payment_type";
NSString *const FILE_SET_DESTINATION=@"setdestination";
NSString *const FILE_APPLY_PROMO=@"apply-promo";
NSString *const FILE_LOGOUT=@"logout";
NSString *const FILE_TRANSPORT=@"transport";
NSString *const FILE_SERVICE=@"services";
NSString *const FILE_ARTICLE=@"articles";
NSString *const FILE_DIMENSION=@"dimension";
NSString *const FILE_ORDER=@"temp_order";
NSString *const FILE_VIEW_CART=@"view_cart";//view_cart_order
NSString *const FILE_CART_DELETE=@"cart_delete";
NSString *const FILE_TRANSPORT_IOS=@"transport_ios";
NSString *const FILE_PAYMENT_ORDER=@"payment_order";
NSString *const FILE_PROFILE_VIEW=@"view_profile";
NSString *const FILE_PROFILE_UPDATE=@"update";
NSString *const FILE_PROMO_CODE=@"pk-apply-promo";
NSString *const FILE_OWNER_WAITORDER=@"owner_waitorder";
NSString *const FILE_OWNER_ACCEPT_WAIT_ORDER=@"owner_accept_wait_order";
NSString *const FILE_OWNER_COMPLETE_ORDER=@"owner_completeorder";
NSString *const FILE_OWNER_PACK_ORDER_DETAILS=@"owner_pack_order_details";
NSString *const FILE_SAVE_ORDER_INFO=@"save_order_info";
NSString *const FILE_SAVE_CARD_INFO=@"save_cardinfo";
NSString *const FILE_DISPLAY_CARD_INFO=@"display_cardinfo";
NSString *const FILE_DELETE_CARD_INFO=@"delete_cardinfo";
NSString *const FILE_GET_ORDER_BILL=@"get_order_bill";
NSString *const FILE_GET_PROVIDER_CURRENT_LOCATION=@"get_provider_current_location";
NSString *const FILE_RATING=@"rating";
#pragma mark -
#pragma mark - PARAMETER NAME

NSString *const PARAM_EMAIL=@"email";
NSString *const PARAM_PASSWORD=@"password";
NSString *const PARAM_FIRST_NAME=@"first_name";
NSString *const PARAM_LAST_NAME=@"last_name";
NSString *const PARAM_PHONE=@"phone";
NSString *const PARAM_PICTURE=@"picture";
NSString *const PARAM_DEVICE_TOKEN=@"device_token";
NSString *const PARAM_DEVICE_TYPE=@"device_type";
NSString *const PARAM_BIO=@"bio";
NSString *const PARAM_ADDRESS=@"address";
NSString *const PARAM_KEY=@"key";
NSString *const PARAM_STATE=@"state";
NSString *const PARAM_COUNTRY=@"country";
NSString *const PARAM_ZIPCODE=@"zipcode";
NSString *const PARAM_LOGIN_BY=@"login_by";
NSString *const PARAM_SOCIAL_UNIQUE_ID=@"social_unique_id";

NSString *const PARAM_NAME=@"name";
NSString *const PARAM_AGE=@"age";
NSString *const PARAM_NOTES=@"notes";
NSString *const PARAM_TYPE=@"type";
NSString *const PARAM_PAYMENT_OPT=@"payment_opt";
NSString *const PARAM_ID=@"id";
NSString *const PARAM_TOKEN=@"token";
NSString *const PARAM_STRIPE_TOKEN=@"payment_token";
NSString *const PARAM_LAST_FOUR=@"last_four";
NSString *const PARAM_REFERRAL_SKIP=@"is_skip";
NSString *const PARAM_OLD_PASSWORD=@"old_password";
NSString *const PARAM_NEW_PASSWORD=@"new_password";

NSString *const PARAM_LATITUDE=@"latitude";
NSString *const PARAM_LONGITUDE=@"longitude";
NSString *const PARAM_DISTANCE=@"distance";
NSString *const PARAM_REQUEST_ID=@"request_id";
NSString *const PARAM_CASH_CARD=@"cash_or_card";
NSString *const PARAM_DEFAULT_CARD=@"default_card_id";
NSString *const PARAM_COMMENT=@"comment";
NSString *const PARAM_RATING=@"rating";
NSString *const PARAM_REFERRAL_CODE=@"referral_code";
NSString *const PARAM_PROMO_CODE=@"promo_code";


NSDictionary *dictBillInfo;
int is_completed;
int is_dog_rated;
int is_walker_started;
int is_walker_arrived;
int is_started;
NSArray *arrPage;


NSString *strForCurLatitude;
NSString *strForCurLongitude;




