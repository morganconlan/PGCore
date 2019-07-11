//
//  PGConstants.m
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGConstants.h"

@implementation PGConstants

/******************************************************************************/
#pragma mark - Required App Keys
/******************************************************************************/

NSString *const kPG_APP_Timestamp = @"kPG_App_Timestamp";

/******************************************************************************/
#pragma mark - Required Image Keys
/******************************************************************************/

NSString *const kPG_Image_Background             = @"background.jpg";
NSString *const kPG_Image_Background568          = @"background568.jpg";
NSString *const kPG_Image_BackgroundLandscape    = @"background_landscape.jpg";
NSString *const kPG_Image_Background568Landscape = @"background568_landscape.jpg";
NSString *const kPG_Image_Refresh                = @"nav_btn_refresh";
NSString *const kPG_Image_Menu                   = @"nav_btn_menu";
NSString *const kPG_Image_Back                   = @"nav_btn_back";
NSString *const kPG_Image_Nav_Background44       = @"nav_background44";

/******************************************************************************/
#pragma mark - Required Cell Keys
/******************************************************************************/

NSString *const kPG_Cell_Menu              = @"PGMenuCell";
NSString *const kPG_Cell_Plain             = @"PGPlainCell";
NSString *const kPG_Cell_Paragraph         = @"PGParagraphCell";
NSString *const kPG_PGTwitterCollapsedCell = @"PGTwitterCollapsedCell";
NSString *const kPG_PGEmailCell            = @"PGEmailCell";
NSString *const kPG_PGTelCell              = @"PGTelCell";
NSString *const kPG_PGWebCell              = @"PGWebCell";
NSString *const kPG_PGIconCell             = @"PGIconCell";

/******************************************************************************/
#pragma mark Lang
NSString *const kPG_Lang = @"kPG_Lang";
NSString *const kPG_Lang_English = @"English";
/******************************************************************************/
#pragma mark Time
NSString *const kPG_Time_Ago      = @"TIME_AGO";
NSString *const kPG_Time_FromNow  = @"TIME_FROM_NOW";
NSString *const kPG_Time_LessThan = @"TIME_LESS_THAN";
NSString *const kPG_Time_About    = @"TIME_ABOUT";
NSString *const kPG_Time_Over     = @"TIME_OVER";
NSString *const kPG_Time_Almost   = @"TIME_ALMOST";
NSString *const kPG_Time_Seconds  = @"TIME_SECONDS";
NSString *const kPG_Time_Minute   = @"TIME_MINUTE";
NSString *const kPG_Time_Minutes  = @"TIME_MINUTES";
NSString *const kPG_Time_Hour     = @"TIME_HOUR";
NSString *const kPG_Time_Hours    = @"TIME_HOURS";
NSString *const kPG_Time_Day      = @"TIME_DAY";
NSString *const kPG_Time_Days     = @"TIME_DAYS";
NSString *const kPG_Time_Month    = @"TIME_MONTH";
NSString *const kPG_Time_Months   = @"TIME_MONTHS";
NSString *const kPG_Time_Year     = @"TIME_YEAR";
NSString *const kPG_Time_Years    = @"TIME_YEARS";
NSString *const kPG_IsAllDay      = @"IsAllDay";
/******************************************************************************/
#pragma mark Event types
NSString *const kPG_EventTypeEvents            = @"kPG_EventTypeEvent";
NSString *const kPG_EventTypeCompetitionAdults = @"kPG_EventTypeCompetitionAdult";
NSString *const kPG_EventTypeCompetitionYouths = @"kPG_EventTypeCompetitionYouth";
NSString *const kPG_CompetitionPrizes          = @"kPG_CompetitionPrizes";
NSString *const kPG_CompetitionResults         = @"kPG_CompetitionResults";
/******************************************************************************/
#pragma mark Twitter
NSString *const kPG_TwitterRetweetedBy = @"kPG_TwitterRetweetedBy";
/******************************************************************************/
#pragma mark Home

/******************************************************************************/
#pragma mark Location
NSString *const kPG_Location_Upnext = @"LOCATION_Upnext";

#pragma mark Settings
/******************************************************************************/
NSString *const kPG_App_Timestamp = @"APP_TIMESTAMP";
/******************************************************************************/
#pragma mark HUD
NSString *const kPG_HUD_ConnectingTwitter        = @"HUD_Connecting_Twitter";
NSString *const kPG_HUD_ConnectingTwitterFailed  = @"HUD_Connecting_Twitter_Failed";
NSString *const kPG_HUD_ConnectingFacebook       = @"HUD_Connecting_Facebook";
NSString *const kPG_HUD_ConnectingFacebookFailed = @"HUD_Connecting_Facebook_Failed";
NSString *const kPG_HUD_ConnectingServer         = @"HUD_Connecting_Server";
NSString *const kPG_HUD_ConnectingServerFailed   = @"HUD_Connecting_Server_Failed";
NSString *const kPG_HUD_ConfirmCancel            = @"HUD_Confirm_Cancel";
NSString *const kPG_HUD_Searching                = @"HUD_Searching";
NSString *const kPG_HUD_SearchingLocation        = @"HUD_Searching_Location";
NSString *const kPG_HUD_LocationError            = @"HUD_Location_Error";
NSString *const kPG_HUD_LocationFound            = @"HUD_Location_Found";
NSString *const kPG_HUD_LocationNoneNearby       = @"HUD_Location_None_Nearby";
NSString *const kPG_HUD_NotAuthorised            = @"HUD_NotAuthorised";
/******************************************************************************/
#pragma mark Alerts
NSString *const kPG_ALERT_CallNumber            = @"ALERT_CALL_NUMBER";
NSString *const kPG_ALERT_Call                  = @"ALERT_CALL";
NSString *const kPG_ALERT_DeviceNotSupported    = @"ALERT_DEVICE_NOT_SUPPORTED";
NSString *const kPG_ALERT_Cancel                = @"ALERT_CANCEL";
NSString *const kPG_ALERT_Cancelled             = @"ALERT_CANCELLED";
NSString *const kPG_ALERT_Thank_You             = @"ALERT_THANK_YOU";
NSString *const kPG_ALERT_Saved                 = @"ALERT_SAVED";
NSString *const kPG_ALERT_Email_Cancelled       = @"ALERT_EMAIL_CANCELLED";
NSString *const kPG_ALERT_Email_Saved           = @"ALERT_EMAIL_SAVED";
NSString *const kPG_ALERT_Email_Sent            = @"ALERT_EMAIL_SENT";
NSString *const kPG_ALERT_Email_Send_Fail       = @"ALERT_EMAIL_SEND_FAIL";
NSString *const kPG_ALERT_Error                 = @"ALERT_ERROR";
NSString *const kPG_ALERT_Error_Server          = @"ALERT_ERROR_SERVER";
NSString *const kPG_ALERT_LeaveApp              = @"ALERT_LEAVE_APP";
NSString *const kPG_ALERT_ConfirmDirections     = @"ALERT_CONFIRM_DIRECTIONS";
NSString *const kPG_ALERT_LocationPermission    = @"ALERT_LOCATION_PERMISSION";
NSString *const kPG_ALERT_NoWifi                = @"ALERT_NO_WIFI";
NSString *const kPG_ALERT_NoWifi_Info           = @"ALERT_NO_WIFI_INFO";
NSString *const kPG_ALERT_NoTwitter             = @"ALERT_NO_TWITTER";
NSString *const kPG_ALERT_NoTwitterInstructions = @"ALERT_NO_TWITTER_INSTRUCTIONS";
/******************************************************************************/
#pragma mark MSG
NSString *const kPG_MSG_Calendar = @"MSG_CALENDAR_NO_EVENTS";
NSString *const kPG_MSG_Planner  = @"MSG_PLANNER_EMPTY";
NSString *const kPG_MSG_Potd     = @"MSG_POTD";
NSString *const kPG_MSG_Upnext   = @"MSG_UPNEXT_EMPTY";
/******************************************************************************/
#pragma mark PopupText Placeholders
/******************************************************************************/
NSString *const kPG_SEARCHBAR_Search = @"SEARCH_BAR_SEARCH";
NSString *const kPG_SEARCHBAR_Done   = @"SEARCH_BAR_DONE";
/******************************************************************************/
#pragma mark ViewController Names
/******************************************************************************/
NSString *const kPG_PGVCTwitter_Menu = @"PGVCTwitter_Menu";
NSString *const kPG_PGVCTwitter_Nav = @"PGVCTwitter_Nav";
NSString *const kPG_PGVCMap_Menu = @"PGVCMap_Menu";
NSString *const kPG_PGVCMap_Nav = @"PGVCMap_Nav";

@end
