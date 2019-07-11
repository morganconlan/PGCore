//
//  PGApp.h
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <MagicalRecord/MagicalRecord.h>
#import "PGConstants.h"
#import "PGCategories.h"
#import "PGMenuController.h"
#import "PGStringsManager.h"
#import "PGColoursManager.h"
#import "PGFontManager.h"
#import "PGConfigsManager.h"
#import "PGMenuManager.h"
#import "PGHUDManager.h"
#import "PGModelManager.h"
#import "PGUploadManager.h"
#import "PGBackgroundManager.h"

#ifndef ddLogLevel
#if DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelInfo;
#endif //DEBUG
#endif //ddLogLevel

@class PGMenuController, PGStringsManager, PGColoursManager, PGFontManager,
    PGConfigsManager, PGMenuManager, PGHUDManager, PGModelManager,
    PGUploadManager, PGBackgroundManager;

@interface PGApp : NSObject

@property (nonatomic, strong) NSString *locale;
@property (nonatomic, assign) BOOL hasRunForVersion;
@property (nonatomic, assign) BOOL loadedJSON;
@property (nonatomic, strong) PGMenuController *menu;
// Managers
@property (nonatomic, strong) PGStringsManager *strings;
@property (nonatomic, strong) PGColoursManager *coloursManager;
@property (nonatomic, strong) PGFontManager *fontManager;
@property (nonatomic, strong) PGConfigsManager *configs;
@property (nonatomic, strong) PGMenuManager *menuManager;
@property (nonatomic, strong) PGHUDManager *hud;
@property (nonatomic, strong) PGModelManager *models;
@property (nonatomic, strong) PGUploadManager *upload;
@property (nonatomic, strong) PGBackgroundManager *background;
// Temporary storage
@property (nonatomic, strong) NSArray *tweets;

@property (nonatomic, strong) MFMailComposeViewController *mailComposer;

extern NSString const *appVersion;

+ (PGApp *)app;
- (void)setup;

#pragma mark - BOOL Configs

- (NSString *)appTimestamp;
- (BOOL)boolForKey:(NSString *)key;
- (void)setBool:(BOOL)boolVal
         forKey:(NSString *)key;
- (BOOL)toggleBoolForKey:(NSString *)key;

#pragma mark - Object Configs
+ (id)objectForKey:(NSString *)key;
+ (void)setObject:(id)object forKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)setNumber:(NSNumber *)number
           forKey:(NSString *)key;
- (NSNumber *)getNumberForKey:(NSString *)key;

#pragma mark - Strings

- (NSString *)locale;
- (NSString *)string:(NSString *)key;
- (NSString *)navigationBarTitleForViewControllerNamed:(NSString *)pgvc;
- (NSString *)menuTitleForForViewControllerNamed:(NSString *)pgvc;
- (NSString *)menuImageTitleForForViewControllerNamed:(NSString *)pgvc;
- (NSString *)uuid;

#pragma mark - Colours
- (UIColor *)colour:(NSString *)key;
- (UIColor *)hex:(int)hex;
- (UIColor *)hexString:(NSString *)hex;

#pragma mark - Fonts
- (UIFont *)font:(NSString *)key;
+ (void)listFonts;

#pragma mark - Images
/**
 Get a UIImage from a given key.
 @param key
 @return UIImage
 */
- (UIImage *)image:(NSString *)key;

#pragma mark - Device

- (CGFloat)width;

#pragma mark - Cells
+ (Class)cellClassForIdentifier:(NSString *)identifier;

#pragma mark - Animation Helpers

- (CGFloat)randomDuration;

#pragma mark - iPad

+ (BOOL)isiPad;
- (void)popViewController;

#pragma mark - Dates

- (NSArray *)rangeOfDatesStarting:(NSDate *)dateStart
                           ending:(NSDate *)dateEnd;

#pragma mark - SIAlert shortcuts

- (void)alertOKWithTitle:(NSString *)title message:(NSString *)message;

#pragma mark - Mail composer
- (void)cycleMailComposer;

#pragma mark - Core Data
/**
 Convenience method for saving the NSManageObjectContext for the current thread
 */
+ (void)save;

@end
