//
//  PGConstants.h
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <Foundation/Foundation.h>

#define IDIOM    UI_USER_INTERFACE_IDIOM()

#define DEBUG_CONTENT_VIEW 0
#define DEBUG_LAYOUTS 0
#define DEBUG_LIFE_CYCLE 0
#define DEBUG_METHODS_CALLED 0
#define DEBUG_IGNORE_MENU 0
#define DEBUG_VIEWS 0
#define DEBUG_API 2

#define IS_PHONEPOD5() ([UIScreen mainScreen].bounds.size.height == 568.0f \
                        && [UIScreen mainScreen].scale == 2.f \
                        && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_RETINA ([[UIScreen mainScreen] scale] >= 2.0)

#define SCREEN_WIDTH ([[UIScreen mainScreen] bounds].size.width)
#define SCREEN_HEIGHT ([[UIScreen mainScreen] bounds].size.height)
#define SCREEN_MAX_LENGTH (MAX(SCREEN_WIDTH, SCREEN_HEIGHT))
#define SCREEN_MIN_LENGTH (MIN(SCREEN_WIDTH, SCREEN_HEIGHT))

#define IS_IPHONE_4_OR_LESS (IS_IPHONE && SCREEN_MAX_LENGTH < 568.0)
#define IS_IPHONE_5 (IS_IPHONE && SCREEN_MAX_LENGTH == 568.0)
#define IS_IPHONE_6 (IS_IPHONE && SCREEN_MAX_LENGTH == 667.0)
#define IS_IPHONE_6P (IS_IPHONE && SCREEN_MAX_LENGTH == 736.0)
#define IS_IPHONE_X (IS_IPHONE && SCREEN_MAX_LENGTH == 812.0)

/******************************************************************************/
#pragma mark - PGTypes
/******************************************************************************/
typedef NS_ENUM( NSUInteger, PGVCLayout ) {
    PGVCLayoutNotSet,
    PGVCLayoutPortrait,
    PGVCLayoutLandscape
};

typedef NS_ENUM( NSUInteger, PGDevice) {
    PGDeviceIPhoneIOS6,
    PGDeviceIPadIOS6,
    PGDeviceIPhoneIOS7,
    PGDeviceIPadIOS7
};

typedef NS_ENUM( NSUInteger, PGReachabilityRequest) {
    PGReachabilityRequestNone,
    PGReachabilityRequestWaiting,
    PGReachabilityRequestCancelled
};

@interface PGConstants : NSObject

/******************************************************************************/
#pragma mark - Required App Keys
/******************************************************************************/

extern NSString *const kPG_APP_Timestamp;

/******************************************************************************/
#pragma mark - Required Image Keys
/******************************************************************************/

extern NSString *const kPG_Image_Background;
extern NSString *const kPG_Image_Background568;
extern NSString *const kPG_Image_BackgroundLandscape;
extern NSString *const kPG_Image_Background568Landscape;
extern NSString *const kPG_Image_Refresh;
extern NSString *const kPG_Image_Menu;
extern NSString *const kPG_Image_Back;
extern NSString *const kPG_Image_Nav_Background44;

/******************************************************************************/
#pragma mark - Required Cell Keys
/******************************************************************************/

extern NSString *const kPG_Cell_Menu;
extern NSString *const kPG_Cell_Plain;
extern NSString *const kPG_Cell_Paragraph;
extern NSString *const kPG_PGTwitterCollapsedCell;
extern NSString *const kPG_PGEmailCell;
extern NSString *const kPG_PGTelCell;
extern NSString *const kPG_PGWebCell;
extern NSString *const kPG_PGIconCell;

/******************************************************************************/
#pragma mark Lang
extern NSString *const kPG_Lang;
extern NSString *const kPG_Lang_English;
/******************************************************************************/
#pragma mark Time
extern NSString *const kPG_Time_Ago;
extern NSString *const kPG_Time_FromNow;
extern NSString *const kPG_Time_LessThan;
extern NSString *const kPG_Time_About;
extern NSString *const kPG_Time_Over;
extern NSString *const kPG_Time_Almost;
extern NSString *const kPG_Time_Seconds;
extern NSString *const kPG_Time_Minute;
extern NSString *const kPG_Time_Minutes;
extern NSString *const kPG_Time_Hour;
extern NSString *const kPG_Time_Hours;
extern NSString *const kPG_Time_Day;
extern NSString *const kPG_Time_Days;
extern NSString *const kPG_Time_Month;
extern NSString *const kPG_Time_Months;
extern NSString *const kPG_Time_Year;
extern NSString *const kPG_Time_Years;
extern NSString *const kPG_IsAllDay;
#pragma mark Settings
/******************************************************************************/
#pragma mark HUD
extern NSString *const kPG_HUD_ConnectingTwitter;
extern NSString *const kPG_HUD_ConnectingTwitterFailed;
extern NSString *const kPG_HUD_ConnectingFacebook;
extern NSString *const kPG_HUD_ConnectingFacebookFailed;
extern NSString *const kPG_HUD_ConnectingServer;
extern NSString *const kPG_HUD_ConnectingServerFailed;
extern NSString *const kPG_HUD_ConfirmCancel;
extern NSString *const kPG_HUD_Searching;
extern NSString *const kPG_HUD_SearchingLocation;
extern NSString *const kPG_HUD_LocationError;
extern NSString *const kPG_HUD_LocationFound;
extern NSString *const kPG_HUD_LocationNoneNearby;
extern NSString *const kPG_HUD_NotAuthorised;
/******************************************************************************/
#pragma mark Alerts
extern NSString *const kPG_ALERT_CallNumber;
extern NSString *const kPG_ALERT_Call;
extern NSString *const kPG_ALERT_DeviceNotSupported;
extern NSString *const kPG_ALERT_Cancel;
extern NSString *const kPG_ALERT_Cancelled;
extern NSString *const kPG_ALERT_Thank_You;
extern NSString *const kPG_ALERT_Saved;
extern NSString *const kPG_ALERT_Email_Cancelled;
extern NSString *const kPG_ALERT_Email_Saved;
extern NSString *const kPG_ALERT_Email_Sent;
extern NSString *const kPG_ALERT_Email_Send_Fail;
extern NSString *const kPG_ALERT_Error;
extern NSString *const kPG_ALERT_Error_Server;
extern NSString *const kPG_ALERT_LeaveApp;
extern NSString *const kPG_ALERT_ConfirmDirections;
extern NSString *const kPG_ALERT_LocationPermission;
extern NSString *const kPG_ALERT_NoWifi;
extern NSString *const kPG_ALERT_NoWifi_Info;
extern NSString *const kPG_ALERT_NoTwitter;
extern NSString *const kPG_ALERT_NoTwitterInstructions;
/******************************************************************************/
#pragma mark MSG
extern NSString *const kPG_MSG_Calendar;
extern NSString *const kPG_MSG_Planner;
extern NSString *const kPG_MSG_Upnext;
/******************************************************************************/
#pragma mark PopupText Placeholders
/******************************************************************************/
extern NSString *const kPG_SEARCHBAR_Search;
extern NSString *const kPG_SEARCHBAR_Done;
/******************************************************************************/
#pragma mark ViewController Names
/******************************************************************************/
extern NSString *const kPG_PGVCTwitter_Menu;
extern NSString *const kPG_PGVCTwitter_Nav;
extern NSString *const kPG_PGVCMap_Menu;
extern NSString *const kPG_PGVCMap_Nav;

@end
