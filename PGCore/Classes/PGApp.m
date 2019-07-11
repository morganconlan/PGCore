//
//  PGApp.m
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGApp.h"
#import <PGAlertView/PGAlertView.h>

@class PGCell;

@interface PGApp()

@property (nonatomic, assign) CGFloat appWidth;

@end

@implementation PGApp

NSString const *appVersion = @"kPG_App_Version";

+ (PGApp *)app {
    
    static PGApp *app = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        app = [self new];
        DDLogInfo(@"app initted");

    });
    
    return app;
    
}

- (id)init {
    
    if ((self = [super init])) {
        
        [self setup];
        
    }
    
    return self;
    
}

- (void)setup {

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    BOOL versionIsCurrent = [version isEqualToString:[[NSUserDefaults standardUserDefaults] objectForKey:@"kPG_App_Version"]];
    DDLogVerbose(@"App setup: %@", (versionIsCurrent) ? @"current version" : @"new version" );
    _hasRunForVersion = versionIsCurrent;

}

- (NSString *)appTimestamp {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *timestamp = [defaults valueForKey:kPG_APP_Timestamp];
    
    return (timestamp == nil
            || PGApp.app.configs.resetTimestamp)
                ? @"2013-01-01T00:00:00.000Z"
                : timestamp;
    
}

#pragma mark - Bool Configs

- (BOOL)boolForKey:(NSString *)key {
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:key];
    
}

- (void)setBool:(BOOL)boolVal
         forKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setBool:boolVal
               forKey:key];
    
    [defaults synchronize];
    
}

- (BOOL)toggleBoolForKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    BOOL toggled = ![defaults boolForKey:key];
    [defaults setBool:toggled forKey:key];
    [defaults synchronize];
    
    return toggled;
    
}

#pragma mark - Object Configs

+ (id)objectForKey:(NSString *)key {

    return [[NSUserDefaults standardUserDefaults] objectForKey:key];

}

+ (void)setObject:(id)object
           forKey:(NSString *)key {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (object == nil) [defaults removeObjectForKey:key];
    else [defaults setObject:object
                      forKey:key];

    [defaults synchronize];

}

- (void)setObject:(id)object
           forKey:(NSString *)key {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (object == nil) [defaults removeObjectForKey:key];
    else [defaults setObject:object
                      forKey:key];
    
    [defaults synchronize];
    
}

- (void)setNumber:(NSNumber *)number
           forKey:(NSString *)key {

    [[NSUserDefaults standardUserDefaults] setObject:number
                                              forKey:key];

    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSNumber *)getNumberForKey:(NSString *)key {

    return (NSNumber *)[[NSUserDefaults standardUserDefaults] objectForKey:key];

}


#pragma mark - Locale

- (void)setLocale:(NSConstantString *)locale {

    [[NSUserDefaults standardUserDefaults] setObject:locale
                                              forKey:kPG_Lang];
    
    [[NSUserDefaults standardUserDefaults] synchronize];

}

- (NSString *)locale {
    
    NSString *currentLocale = [[NSUserDefaults standardUserDefaults] objectForKey:kPG_Lang];
    
    if (currentLocale == nil) {
        
        [self setLocale:_configs.defaultLang];
        return _configs.defaultLang;
    }
    
    return currentLocale;
    
}

- (NSString *)string:(NSString *)key { // shorthand for PGStringsManager call
    
    return [_strings stringForKey:key inLocale:[self locale]];
    
}

- (NSString *)navigationBarTitleForViewControllerNamed:(NSString *)pgvc {

    NSString *navTitle = [self string:[pgvc stringByAppendingString:@"_Nav"]];
    
    return (navTitle == nil
            || [navTitle isEqualToString:@""])
                ? [NSString stringWithFormat:@"*%@*", pgvc]
                : navTitle;
    
}

- (NSString *)menuTitleForForViewControllerNamed:(NSString *)pgvc {
    
    NSString *menuTitle = [self string:[pgvc stringByAppendingString:@"_Menu"]];
    
    return (menuTitle == nil
            || [menuTitle isEqualToString:@""])
                ? [NSString stringWithFormat:@"*%@*", pgvc]
                : menuTitle;
    
}

- (NSString *)menuImageTitleForForViewControllerNamed:(NSString *)pgvc {
    
    return [NSString stringWithFormat:@"icon_%@", pgvc];
    
}

/**
 *  Generate a Universally Unique Identifier
 *
 *  @return lowercase UUID string
 */
- (NSString *)uuid {

    NSString *uuid = [[[NSUUID UUID] UUIDString] lowercaseString];

    return (uuid.length > 0) ? uuid : [[[NSUUID UUID] UUIDString] lowercaseString];
    
}

#pragma mark - Colours

- (UIColor *)colour:(NSString *)key {

    return [_coloursManager colourForKey:key];
}

- (UIColor *)hex:(int)hex {
    
    return [PGColoursManager colourForHex:hex];
}

- (UIColor *)hexString:(NSString *)hex {
    
    return [PGColoursManager colorForHexString:hex];
}

#pragma mark - Fonts

- (UIFont *)font:(NSString *)key {
    
    return [_fontManager fontForKey:key];
}

+ (void)listFonts {

    NSArray *fontFamilies = [[UIFont familyNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    DDLogVerbose(@"\nAVAILABLE FONTS:");

    for (int i = 0; i < [fontFamilies count]; i++) {

        NSString *fontFamily = [fontFamilies objectAtIndex:i];
        NSArray *fontNames = [UIFont fontNamesForFamilyName:[fontFamilies objectAtIndex:i]];
        DDLogVerbose(@"%@: %@", fontFamily, fontNames);

    }

}

#pragma mark - Images

- (UIImage *)image:(NSString *)key {
    
    UIImage *image = [UIImage imageNamed:key];
#ifdef DEBUG
    NSString * message = [NSString stringWithFormat:@"Image %@ not found", key];
    NSAssert(image, message);
#else
    if (image == nil) DDLogError(@"image not found for key: %@", key);
#endif
    return image;
}

#pragma mark - Device

- (CGFloat)width {
    
    if (_appWidth > 0) return _appWidth;
    
    CGRect bounds = [[UIScreen mainScreen] bounds]; // portrait bounds
    if (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {
        //swap for landscape
        bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);
    }
    
    _appWidth = bounds.size.width;
    
    return _appWidth;
}

#pragma mark - Cells 

+ (Class)cellClassForIdentifier:(NSString *)identifier {
    
    if ([identifier hasPrefix:@"kPG_"]) {
        identifier = [identifier substringFromIndex:4];
    }
    
    Class cellClass = NSClassFromString(identifier);
    
    if (cellClass != Nil) return cellClass;
    
    DDLogError(@"%@ does not exist", identifier);
    
    return [PGCell class];
}

#pragma mark - Animation Helpers

- (CGFloat)randomDuration {
    
    return ((float)arc4random_uniform(_configs.randomDurationMax)
            + _configs.randomDurationMin)
    / 100.0f;
    
}

#pragma mark - iPad

+ (BOOL)isiPad {
    return PGApp.app.configs.isiPad && PGApp.app.configs.withiPad;
}

- (void)popViewController {

    [(PGVC *)PGApp.app.menu.drillDownController.rightViewController popViewController];

}

#pragma mark - Dates

- (NSArray *)rangeOfDatesStarting:(NSDate *)dateStart
                           ending:(NSDate *)dateEnd {
    
    NSMutableArray *dateList = [NSMutableArray array];
    
    if (dateStart == nil) {
        
        return dateList;
        
    }
    
    NSCalendar *currentCalendar = [NSDate currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setDay:1];
    
    [dateList addObject: dateStart];
    NSDate *currentDate = dateStart;
    
    // add one the first time through, so that we can use NSOrderedAscending
    // (prevents millisecond infinite loop)
    currentDate = [currentCalendar dateByAddingComponents:comps
                                                   toDate:currentDate
                                                  options:0];
    
    while ( [dateEnd compare: currentDate] != NSOrderedAscending) {
        
        [dateList addObject: currentDate];
        currentDate = [currentCalendar dateByAddingComponents:comps
                                                       toDate:currentDate
                                                      options:0];
    }
    
    if (![dateList.lastObject isSameDate:dateEnd]) { // clock change issue?
        [dateList addObject: dateEnd];
    }
    
    return dateList;
}

#pragma mark - Core Data

+ (void)save {

    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {

        if (contextDidSave) {

            DDLogInfo(@"Context saved.");

        } else if (error) {

            DDLogError(@"Error saving context: %@", error.description);
        }

    }];

}

#pragma mark - SIAlert shortcuts

- (void)alertOKWithTitle:(NSString *)title
                 message:(NSString *)message {

    PGAlertView *alert = [[PGAlertView alloc] initWithTitle:title andMessage:message];

    [alert addButtonWithTitle:@"OK"
                         type:PGAlertViewButtonTypeCancel
                      handler:nil];

    [alert show];

}

#pragma mark - Mail composer

- (void)cycleMailComposer {
    self.mailComposer = nil;
    self.mailComposer = [[MFMailComposeViewController alloc] init];
}

@end
