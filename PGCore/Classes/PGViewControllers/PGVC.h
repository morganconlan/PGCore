//
//  PGVC.h
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <PGViewDeck/PGViewDeck.h>
#import <PGDrillDownController/PGDrillDownController.h>
#import <PGAlertView/PGAlertView.h>
#import "PGYoutubeDelegate.h"
#import "PGVCDelegate.h"

#define XCODE_COLORS_ESCAPE_MAC @"\033["

#if DEBUG_IGNORE_MENU > 0
#define IGNORE_MENU if (![self isKindOfClass:[PGMenuController class]])
#else
#define IGNORE_MENU if (YES)
#endif

#if DEBUG_CONTENT_VIEW > 0
#define DEBUG_VIEW_FRAME(_SELF, _NAME, _VIEW) IGNORE_MENU DDLogVerbose( \
XCODE_COLORS_ESCAPE_MAC @"fg5,47,90;" \
@"%@ " \
XCODE_COLORS_ESCAPE_MAC @"fg75,154,234;" \
@"\"%@\":" \
XCODE_COLORS_ESCAPE_MAC@ "fg75,228,234;" \
@" %0.0f, %0.0f (%0.0f, %0.0f)" \
XCODE_COLORS_ESCAPE_MAC @"fg255,255,255;", \
NSStringFromClass([self class]), \
_NAME, _VIEW.frame.origin.x, \
_VIEW.frame.origin.y, \
_VIEW.frame.size.width, \
_VIEW.frame.size.height \
);
#else
#define DEBUG_VIEW_FRAME(_SELF, _NAME, _VIEW)
#endif

#if DEBUG_LAYOUTS > 0
#define DEBUG_LAYOUTING(_STRING) IGNORE_MENU DDLogVerbose( \
XCODE_COLORS_ESCAPE_MAC @"fg5,47,90;" \
@"%@ " \
XCODE_COLORS_ESCAPE_MAC @"fg187,163,136;" \
@"%@ " \
XCODE_COLORS_ESCAPE_MAC @"fg255,255,255;", \
NSStringFromClass([self class]), \
_STRING \
);
#else
#define DEBUG_LAYOUTING(_STRING)
#endif

#if DEBUG_LIFE_CYCLE > 0
#define DEBUG_CYCLE(_STRING) IGNORE_MENU DDLogVerbose( \
XCODE_COLORS_ESCAPE_MAC @"fg237,25,83;" \
@"%@ " \
XCODE_COLORS_ESCAPE_MAC @"fg187,163,136;" \
@"%@ " \
XCODE_COLORS_ESCAPE_MAC @"fg255,255,255;", \
NSStringFromClass([self class]), \
_STRING \
);
#else
#define DEBUG_CYCLE(_STRING)
#endif

#if DEBUG_METHODS_CALLED > 0
#define DEBUG_CALLED(_STRING) IGNORE_MENU DDLogVerbose( \
XCODE_COLORS_ESCAPE_MAC @"fg55,179,74;" \
@"%@ " \
XCODE_COLORS_ESCAPE_MAC @"fg187,163,136;" \
@"%@ " \
XCODE_COLORS_ESCAPE_MAC @"fg255,255,255;", \
NSStringFromClass([self class]), \
_STRING \
);
#else
#define DEBUG_CALLED(_STRING)
#endif

#import <CoreData/CoreData.h>
#import "PGConstants.h"

@interface PGVC : UIViewController <MFMailComposeViewControllerDelegate,
    PGViewDeckControllerDelegate, PGVCDelegate> {

@protected

    PGDevice currentDevice;
    PGVCLayout currentLayout;
    PGReachabilityRequest currentReachabilityRequest;
    NSManagedObject *object;
    
}

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *contentView;
@property (assign) BOOL isUsingDefaultFrames;
@property (nonatomic, assign) BOOL isDisplayingSidemenu;
@property (nonatomic, assign) BOOL isCustomBackground;

//Convenience Methods
- (void)enableSideMenu;
- (id)initWithSidemenuButton;
- (NSString *)navTitle;

// Back button
- (UIBarButtonItem *)backBarButton;
- (void)setupLeftNavButton;

// Pushes
- (void)pushPGVC:(UIViewController<PGVCDelegate> *)pgvc;
- (void)pushPGVC:(UIViewController<PGVCDelegate> *)pgvc
  replacingRight:(BOOL)isReplacingRight;
- (void)pushPGVC:(UIViewController<PGVCDelegate> *)pgvc
      afterBlock:(void (^)(void))block
      afterDelay:(NSTimeInterval)delay;
- (void)pushPGVC:(UIViewController<PGVCDelegate> *)pgvc
      afterBlock:(void (^)(void))block
      afterDelay:(NSTimeInterval)delay
  replacingRight:(BOOL)isReplacingRight;
- (void)willPop;
- (void)popViewController;

- (void)prepareForResize;
- (void)prepareForLayout;
- (void)layoutForPortrait;
- (void)layoutForLandscape;

- (BOOL)isPortrait;
- (void)debugContentViewWithColour:(UIColor *)debugColour;
- (UIColor *)contentViewDebugingColor;

- (void)layoutContentView;
- (void)fadeContentOut;
- (void)fadeContentIn;
- (CGFloat)contentHeight;
- (CGFloat)width;

//background
- (CGFloat)backgroundAlpha;

//frames
- (CGRect)applicationBounds;
- (CGRect)foregroundFrame;
- (CGRect)backgroundFrame;

//Sharing
- (void)didPressEmail:(NSArray *)recipients;
- (void)didPressTel:(NSString *)tel;
- (void)didPressWeb:(NSString *)web;

//Video
- (void)playVideo:(id<PGYoutubeDelegate>)video;

//Refresh
- (void)setupRefresh;
- (void)setupRightNavButtonWithImage:(UIImage *)image
                            selector:(NSString *)selector;
- (void)setupRightNavButton:(UIButton *)navButton
                   selector:(NSString *)selector;
- (void)setupRightNavButtons:(NSArray *)navButtons
                   selectors:(NSArray *)selectors;
- (void)setupRightNavButtonImages:(NSArray *)navButtons
                   selectors:(NSArray *)selectors;
- (void)didPressRefresh;

//MSG
//TODO: implement generic mechanism to display message
//- (void)showMSG;
//- (void)hideMSG;

// Blurring
- (void)addBlur;
- (void)removeBlur;

// ViewDeck
- (void)viewDeckController:(PGViewDeckController *)viewDeckController
           didOpenViewSide:(PGViewDeckSide)viewDeckSide
                  animated:(BOOL)animated;

// iPad
- (BOOL)isLeftViewController;
- (void)wasChangedToLeftViewController;
- (void)wasChangedToRightViewController;

@end
