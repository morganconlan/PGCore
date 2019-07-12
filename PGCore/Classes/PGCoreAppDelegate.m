//
//  PGCoreAppDelegate.m
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGCoreAppDelegate.h"
#import "MTMigration.h"
#import <CocoaLumberjack/DDTTYLogger.h>
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import <AFNetworkActivityLogger/AFNetworkActivityConsoleLogger.h>
#import "PGNavigationController.h"
#import "PGNavigationBar.h"
#import "PGLineNumberLogFormatter.h"

@class PGMenuController;

@implementation PGCoreAppDelegate

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self setupLumberjack];
    
    if(getenv("NSZombieEnabled")
       || getenv("NSAutoreleaseFreedObjectCheckEnabled"))
        DDLogWarn(@"NSZombieEnabled/NSAutoreleaseFreedObjectCheckEnabled enabled!");
    setenv("XcodeColors", "YES", 0);
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    // Check if the app has run for the current version
    // Load defaults if not
    [self setupManagers:!PGApp.app.hasRunForVersion];
    // Make sure that managers have all been setup
    [self checkManagers];
    
    // Save current app version
    NSString *version = [[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"];
    [PGApp.app setObject:version
                  forKey:@"kPG_App_Version"];
    
    NSAssert(PGApp.app.configs.migrationVersion, @"App migration version must be set");

    [self setupAFNetworking];
    [self setupAppCenterSDK];
    [self performMigrations];
    [self setupMR];

    if (PGApp.isiPad) [self setupIpad];
    else (PGApp.app.menuManager.items > 0)
            ? [self setupViewdeck]
            : [self setupHome];

    [PGApp.app.configs setupAlert];

    if (PGApp.app.configs.withPushNotifications) {

        NSLog(@"App registerForRemoteNotificatins");
        //ask the user if they want to recieve push notifications
        [[PGNotificationsManager shared] registerForRemoteNotifications];

    } else {
        NSLog(@"App not registering for push notifications");
    }
    
    [self.window makeKeyAndVisible];

    [self performSelectorOnMainThread:@selector(checkLaunchOrientation:)
                           withObject:nil
                        waitUntilDone:NO];

    return YES;

}

- (void)performMigrations {
    // Default behviour is to wipe the db on migration
    [MTMigration migrateToVersion:PGApp.app.configs.migrationVersion
                            block:^
     {
         
         //delete store
         NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:@"data.sqlite"];
         NSError *error;
         [[NSFileManager defaultManager] removeItemAtPath:storeURL.path
                                                    error:&error];
         if (error != nil) {
             DDLogError(@"error deleting store: %@", [error localizedDescription]);
         }
         
     }];
    
}

- (void)applicationWillTerminate:(UIApplication *)application {
    
    [MagicalRecord cleanUp];
    
}

- (void)setupLumberjack {

    PGLineNumberLogFormatter *logFormatter = [PGLineNumberLogFormatter new];
    [[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];

    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];


}

- (void)setupAFNetworking {
    
    // Only allow when debugging
    if (PGApp.app.configs.isDebuggingAFNetworking) {
#if DEBUG

//        AFNetworkActivityConsoleLogger *consoleLogger = [AFNetworkActivityConsoleLogger new];
//        [consoleLogger setLevel:AFLoggerLevelDebug];
//        [[AFNetworkActivityLogger sharedLogger] removeLogger:[[[AFNetworkActivityLogger sharedLogger] loggers] anyObject]];
//        [[AFNetworkActivityLogger sharedLogger] addLogger:consoleLogger];
//        [[AFNetworkActivityLogger sharedLogger] startLogging];

#endif
    } else {
//        [[AFNetworkActivityLogger sharedLogger].loggers setLevel:AFLoggerLevelOff];
    }

    [[AFNetworkActivityLogger sharedLogger] startLogging];

}

- (void)setupAppCenterSDK {
    
    NSAssert(NO, @"setupAppCenterSDK must be implemented by subclass");
    
}

- (void)setupManagers:(BOOL)isLoadingFirstRun {
    
    DDLogWarn(@"Should be implemented by subclass. Using defaults");
    
    PGApp.app.configs = [[PGConfigsManager alloc] init];
    PGApp.app.coloursManager = [[PGColoursManager alloc] init];
    PGApp.app.fontManager = [[PGFontManager alloc] init];
    PGApp.app.strings = [[PGStringsManager alloc] init];
    PGApp.app.hud = [[PGHUDManager alloc] initDefault];
    PGApp.app.background = [[PGBackgroundManager alloc] init];
    PGApp.app.upload = [[PGUploadManager alloc] init];
}

- (void)checkManagers {
    
    NSAssert(PGApp.app.configs, @"App configs have not been initialised");
    NSAssert(PGApp.app.coloursManager, @"App colours have not been initialised");
    NSAssert(PGApp.app.fontManager, @"App fonts have not been initialised");
    NSAssert(PGApp.app.strings, @"App strings have not been initialised");
    NSAssert(PGApp.app.hud, @"App hud has not been initialised");
    NSAssert(PGApp.app.background, @"App background manager has not been initialised");

}

- (void)setupMR {

    if (PGApp.app.configs.resetCoreData) [self deleteCoreDataStack];
    
    @try {

        [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:@"data.sqlite"];

        if (PGApp.app.configs.describeCoreDataStack) DDLogVerbose(@"%@", [MagicalRecord currentStack]);
        
    } @catch (NSException *exception) {
        
        DDLogVerbose(@"%@", [exception description]);
        
    }
}

- (void)deleteCoreDataStack {
    
    DDLogWarn(@"Deleting Coredata Stack");
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:@"data.sqlite"];
    NSError *error;
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path
                                               error:&error];
    if (error != nil) {
        DDLogError(@"error deleting store: %@", [error localizedDescription]);
    }
}

/**
 * Disabled by default.
 */
- (BOOL)isUsingViewDeck {
    return NO;
}

- (void)setupViewdeck {

    PGNavigationController *nc = [[PGNavigationController alloc] initWithRootViewController:[self home]];

    if (PGApp.app.menu == nil)
        PGApp.app.menu = [[PGMenuController alloc] init];

    self.deckController =  [[PGViewDeckController alloc] initWithCenterViewController:nc
                                                                   leftViewController:PGApp.app.menu
                                                                  rightViewController:nil];
    
    self.deckController.delegate = self;
    
//    [self.deckController setPanningMode:PGViewDeckNoPanning];
//    [self.deckController setNavigationControllerBehavior:PGViewDeckNavigationControllerContained];
//    [self.deckController setLeftSize:PGApp.app.width];

    self.window.rootViewController = self.deckController;
    
}

- (void)viewDeckController:(PGViewDeckController *)viewDeckController
           didOpenViewSide:(PGViewDeckSide)viewDeckSide
                  animated:(BOOL)animated {
    
    // Add the blur
    PGNavigationController *navController = (PGNavigationController *)self.deckController.centerViewController;
    PGVC *vc = (PGVC *)[navController.viewControllers lastObject];
    
    if ([vc respondsToSelector:@selector(addBlur)]) {
        
        [vc performSelector:@selector(addBlur)];
        
    }
    
}

- (void)viewDeckController:(PGViewDeckController *)viewDeckController
          didCloseViewSide:(PGViewDeckSide)viewDeckSide
                  animated:(BOOL)animated {
    
    // Remove the blur
    PGNavigationController *navController = (PGNavigationController *)self.deckController.centerViewController;
    PGVC *vc = (PGVC *)[navController.viewControllers lastObject];
    
    if ([vc respondsToSelector:@selector(removeBlur)]) {
        
        [vc performSelector:@selector(removeBlur)];
        
    }
    
}


- (PGVC *)home {

    DDLogError(@"Home view controller not implemented. Should be implemented by app delegate");
    return [[PGVCCoreHome alloc] init];
}

- (void)setupHome {
    
    DDLogVerbose(@"Setting up root view controller without side menu");
    PGNavigationController *nc = [[PGNavigationController alloc] initWithRootViewController:[self home]];
    self.window.rootViewController = nc;
    
}

- (void)setupIpad {

    self.drillController = [[PGDrillDownController alloc] initWithNavigationBarClass:[PGNavigationBar class]
                                                                        toolbarClass:[UIToolbar class]];
    if ((PGApp.app.menuManager.items > 0)) {

        if (PGApp.app.menu == nil)
            PGApp.app.menu = [[PGMenuController alloc] init];

        [self.drillController pushViewController:PGApp.app.menu
                                        animated:NO
                                      completion:nil];

    }

    [self.drillController pushViewController:self.home
                                    animated:NO
                                  completion:nil];

    self.window.rootViewController = self.drillController;
    
}

//Problems arise if started in landscape
- (void)checkLaunchOrientation:(id)sender {

    if (!PGApp.isiPad) return;

    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    BOOL isLandscape = UIInterfaceOrientationIsLandscape(self.drillController.leftViewController.interfaceOrientation);

    if (UIInterfaceOrientationIsLandscape(orientation) || isLandscape) {

        [(PGVC *)self.drillController.leftViewController prepareForResize];
        [(PGVC *)self.drillController.rightViewController wasChangedToRightViewController];

    }
}

@end
