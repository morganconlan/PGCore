//
//  PGCoreAppDelegate.h
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGApp.h"
#import "PGVCCoreHome.h"
#import "PGNotificationsManager.h"
#import <MagicalRecord/MagicalRecord.h>
#import <PGViewDeck/PGViewDeck.h>
#import <PGDrillDownController/PGDrillDownController.h>

@interface PGCoreAppDelegate : UIResponder <PGViewDeckControllerDelegate, PGNotificationsDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) PGViewDeckController *deckController;
@property (strong, nonatomic) PGDrillDownController* drillController;

- (BOOL)application:(UIApplication *)application
didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;

- (void)setupLumberjack;
- (void)setupAFNetworking;
- (void)setupAppCenterSDK;
- (void)setupViewdeck;
- (void)performMigrations;
/**
 * This is where the following should be setup:
 * stringsManager, coloursManager, fontManager, configs, menuManager
 */
- (void)setupManagers:(BOOL)isLoadingFirstRun;
- (void)deleteCoreDataStack;
- (void)setupMR;
- (BOOL)isUsingViewDeck;
- (PGVC *)home;

@end
