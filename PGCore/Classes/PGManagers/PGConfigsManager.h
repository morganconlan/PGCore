//
//  PGConfigsManager.h
//  pgcore
//
//  Created by Morgan Conlan on 05/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PGApp.h"

@interface PGConfigsManager : NSObject

@property (nonatomic, strong) NSNumber *appId;
@property (nonatomic, assign) BOOL isLoadingFirstRun;

# pragma mark - Language Configs
@property (nonatomic, strong) NSArray *supportedLangs;
@property (nonatomic, strong) NSString *defaultLang;
@property (nonatomic, assign) BOOL isForceLoadingStrings;

# pragma mark - Server Configs
@property (nonatomic, strong) NSString *serverRoot;
@property (nonatomic, strong) NSString *s3assetsRoot;
@property (nonatomic, assign) BOOL resetTimestamp;

# pragma mark - OAuth
@property (nonatomic, strong) NSString *clientID;
@property (nonatomic, strong) NSString *clientSecret;
@property (nonatomic, strong) NSString *clientIdentifier;
@property (nonatomic, strong) NSString *clientOAuthString;

# pragma mark - Twitter
@property (nonatomic, strong) NSString *twitterConsumerKey;
@property (nonatomic, strong) NSString *twitterConsumerSecret;
@property (nonatomic, strong) NSString *twitterDefaultAccount;

# pragma mark - HockeyApp
@property (nonatomic, strong) NSString *hockeyAppId;

# pragma mark - Menu Configs
@property (nonatomic) CGFloat viewDeckWidth;
@property (nonatomic) CGFloat menuHeaderPadding;
@property (nonatomic) CGFloat menuCellHeight;
@property (nonatomic) CGFloat menuCellInsetLeft;
@property (nonatomic) BOOL isMenuDividerEnabled;
@property (nonatomic) BOOL isMenuIconsEnabled;
@property (nonatomic) BOOL isBlurring;

# pragma mark - Nav Configs
@property (nonatomic) BOOL isNavTitleTextDisabled;
@property (nonatomic) BOOL isDarkNav;
@property (nonatomic) BOOL isNavTranslucent;

# pragma mark - PGVC Configs
@property (nonatomic) CGFloat pgvcBackgroundAlpha;
@property (nonatomic) CGFloat pgvcFadeDuration;
@property (nonatomic) BOOL animatePGVCPush;

# pragma mark - PGVCMap
@property (nonatomic) BOOL isShowingLocationNameInNav;

#pragma mark - Cells Configs
@property (nonatomic, assign) CGFloat cellContentViewAlpha;
@property (nonatomic, assign) BOOL animateCellDivider;

# pragma mark - Core Data Configs
@property (nonatomic, assign) BOOL resetCoreData;
@property (nonatomic, assign) BOOL describeCoreDataStack;
@property (nonatomic, strong) NSString *migrationVersion;

# pragma mark - Misc Configs
@property (nonatomic) NSInteger randomDurationMin;
@property (nonatomic) NSInteger randomDurationMax;
@property (nonatomic, strong) NSNumberFormatter *numFormatter2Decimal;
@property (nonatomic, strong) CLLocation *userLocation;
@property (nonatomic, assign) BOOL withPushNotifications;
@property (nonatomic, strong) NSMutableDictionary *options;

# pragma mark - Debugging Flags
@property (nonatomic, assign) BOOL isDebugging;
@property (nonatomic, assign) BOOL isDebuggingStrings;
@property (nonatomic, assign) BOOL isDebuggingAFNetworking;
@property (nonatomic, assign) BOOL isDebuggingViews;
@property (nonatomic, assign) BOOL isDebuggingFiles;
@property (nonatomic, assign) BOOL isDebuggingModels;

# pragma mark - API Configs
@property (nonatomic, strong) NSString *apiVersion;
/**
 * Lookup key for model primary keys in the api. Usually "id".
 */
@property (nonatomic, strong) NSString *apiPK;
/**
 * Lookup key for model primary keys in the app. Usually "pk".
 */
@property (nonatomic, strong) NSString *apiAppPK;
/**
 * Suffix for object foreign keys, usually includes underscore: "_id".
 */
@property (nonatomic, strong) NSString *apiFK;

# pragma mark - iPad Configs
@property (nonatomic, assign) BOOL isiPad;
@property (nonatomic, assign) BOOL withiPad;

- (void)loadFirstRun;
- (void)setupAlert;

- (void)setOption:(id)option forKey:(NSString *)key;
- (id)optionForKey:(NSString *)key;

@end
