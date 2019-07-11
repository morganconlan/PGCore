//
//  PGConfigsManager.m
//  pgcore
//
//  Created by Morgan Conlan on 05/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGConfigsManager.h"
#import <PGAlertView/PGAlertView.h>

@implementation PGConfigsManager

- (instancetype)init {
    
    if ((self = [super init])) {
        
        [self defaults];
    }
    
    return self;
}

// Root defaults
- (void)defaults {

    // Langs 'n' Strings
    _supportedLangs = @[@"en"];
    _defaultLang = @"en";
    
    // Menu
    _viewDeckWidth = 200.0f;
    _menuCellHeight = 60.0f;
    
    _pgvcBackgroundAlpha = 0.3f;
    _pgvcFadeDuration = 0.2f;
    _randomDurationMax = 100;
    _randomDurationMin = 50;
    _animatePGVCPush = NO;
    _resetCoreData = NO;
    _migrationVersion = nil; // This must be set
    
    //Map
    _isShowingLocationNameInNav = YES;
    
    _cellContentViewAlpha = 0.85f;
    _animateCellDivider = NO;
    
    //Menu
    _menuHeaderPadding = 0.0f;
    _isMenuDividerEnabled = YES;
    _isMenuIconsEnabled = NO;
    _menuCellInsetLeft = 10.0f;
    _isBlurring = NO;

    //Nav
    _isNavTitleTextDisabled = NO;
    _isDarkNav = YES;
    _isNavTranslucent = NO;

    //Debug flags
    _isDebugging = NO;
    _isDebuggingStrings = NO;
    _isDebuggingAFNetworking = NO;
    _isDebuggingViews = NO;

    //API
    _apiVersion = nil;
    
    _numFormatter2Decimal = [[NSNumberFormatter alloc] init];
    [_numFormatter2Decimal setNumberStyle:NSNumberFormatterDecimalStyle];
    [_numFormatter2Decimal setMaximumFractionDigits:2];

    // setup iPad
    _isiPad = ([UIDevice.currentDevice.model rangeOfString:@"iPad"].location != NSNotFound);

    _options = [NSMutableDictionary dictionary];

    [self setupAlert];
    [self checkInfoPList];
}

// App specific defaults, run once on first open for version
- (void)loadFirstRun {
    // To be implemented by subclass

}

- (void)setupAlert {

        [[PGAlertView appearance] setTitleFont:[PGApp.app font:kPG_Font_Alert_Title]];
        [[PGAlertView appearance] setTitleColor:[PGApp.app colour:kPG_Colour_Alert_Title]];
        [[PGAlertView appearance] setMessageFont:[PGApp.app font:kPG_Font_Alert_Message]];
        [[PGAlertView appearance] setMessageColor:[PGApp.app colour:kPG_Colour_Alert_Message]];
        [[PGAlertView appearance] setViewBackgroundColor:[PGApp.app colour:kPG_Colour_Alert_Background]];
        [[PGAlertView appearance] setCornerRadius:0];
        [[PGAlertView appearance] setShadowRadius:20];

}

- (void)checkInfoPList {

    // Set status bar style programmatically:
    /* Info.plist
     <key>UIViewControllerBasedStatusBarAppearance</key>
     <true/>
     */
//    NSAssert([[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"], @"missing key in info.plist: UIViewControllerBasedStatusBarAppearance");
}

- (void)setOption:(id)option forKey:(NSString *)key {
    [_options setObject:option forKey:key];
}

- (id)optionForKey:(NSString *)key {
    return _options[key];
}

@end
