//
//  PGAlertView.h
//  PGAlertView
//
//  Created by Morgan Conlan on 09/07/2019.
//  Copyright © 2019 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIWindow+SIUtils.h"

//! Project version number for PGAlertView.
FOUNDATION_EXPORT double PGAlertViewVersionNumber;

//! Project version string for PGAlertView.
FOUNDATION_EXPORT const unsigned char PGAlertViewVersionString[];

extern NSString *const PGAlertViewWillShowNotification;
extern NSString *const PGAlertViewDidShowNotification;
extern NSString *const PGAlertViewWillDismissNotification;
extern NSString *const PGAlertViewDidDismissNotification;

typedef NS_ENUM(NSInteger, PGAlertViewButtonType) {
    PGAlertViewButtonTypeDefault = 0,
    PGAlertViewButtonTypeDestructive,
    PGAlertViewButtonTypeCancel
};

typedef NS_ENUM(NSInteger, PGAlertViewBackgroundStyle) {
    PGAlertViewBackgroundStyleGradient = 0,
    PGAlertViewBackgroundStyleSolid,
};

typedef NS_ENUM(NSInteger, PGAlertViewButtonsListStyle) {
    PGAlertViewButtonsListStyleNormal = 0,
    PGAlertViewButtonsListStyleRows
};

typedef NS_ENUM(NSInteger, PGAlertViewTransitionStyle) {
    PGAlertViewTransitionStyleSlideFromBottom = 0,
    PGAlertViewTransitionStyleSlideFromTop,
    PGAlertViewTransitionStyleFade,
    PGAlertViewTransitionStyleBounce,
    PGAlertViewTransitionStyleDropDown
};

@class PGAlertView;
typedef void(^PGAlertViewHandler)(PGAlertView *alertView);

@interface PGAlertView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *message;

@property (nonatomic, assign) PGAlertViewTransitionStyle transitionStyle; // default is PGAlertViewTransitionStyleSlideFromBottom
@property (nonatomic, assign) PGAlertViewBackgroundStyle backgroundStyle; // default is PGAlertViewBackgroundStyleGradient
@property (nonatomic, assign) PGAlertViewButtonsListStyle buttonsListStyle; // default is PGAlertViewButtonsListStyleNormal

@property (nonatomic, copy) PGAlertViewHandler willShowHandler;
@property (nonatomic, copy) PGAlertViewHandler didShowHandler;
@property (nonatomic, copy) PGAlertViewHandler willDismissHandler;
@property (nonatomic, copy) PGAlertViewHandler didDismissHandler;

@property (nonatomic, readonly, getter = isVisible) BOOL visible;

@property (nonatomic, readonly, getter = isParallaxEffectEnabled) BOOL enabledParallaxEffect;

@property (nonatomic, strong) UIColor *viewBackgroundColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *messageColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *titleFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *messageFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *buttonFont NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *buttonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *cancelButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *destructiveButtonColor NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat cornerRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 2.0
@property (nonatomic, assign) CGFloat shadowRadius NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR; // default is 8.0

- (void)setDefaultButtonImage:(UIImage *)defaultButtonImage
                     forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

- (void)setCancelButtonImage:(UIImage *)cancelButtonImage
                    forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

- (void)setDestructiveButtonImage:(UIImage *)destructiveButtonImage
                         forState:(UIControlState)state NS_AVAILABLE_IOS(5_0) UI_APPEARANCE_SELECTOR;

- (id)initWithTitle:(NSString *)title
         andMessage:(NSString *)message;

- (void)addButtonWithTitle:(NSString *)title
                      type:(PGAlertViewButtonType)type
                   handler:(PGAlertViewHandler)handler;

- (void)show;

- (void)dismissAnimated:(BOOL)animated;

@end
