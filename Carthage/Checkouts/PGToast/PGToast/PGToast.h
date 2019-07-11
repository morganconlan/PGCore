//
//  PGToast.h
//
//  Created by Andrew Podkovyrin on 18/04/14.
//  Copyright (c) 2014 Andrew Podkovyrin. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for PGToast.
FOUNDATION_EXPORT double PGToastVersionNumber;

//! Project version string for PGToast.
FOUNDATION_EXPORT const unsigned char PGToastVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <PGToast/PublicHeader.h>
#import "NSString+PGToast.h"
#import "UIView+PGToast.h"
#import "UIView+PGToastStyle.h"

@protocol PGToastDelegate;

/**
 *  Toast object, created and managed by `PGToaster`
 */
@interface PGToast : NSObject

/**
 *  Unique (per app launch), auto-generated toast ID
 */
@property (assign, readonly, nonatomic) NSInteger toastID;
/**
 *  Toasting duration
 */
@property (assign, readwrite, nonatomic) NSTimeInterval duration;
/**
 *  Should eject toast by touching it
 */
@property (assign, readwrite, nonatomic) BOOL tapToComplete;
/**
 *  The view for toasting
 */
@property (strong, readwrite, nonatomic) UIView *toastView;
/**
 *  The parent view for toastView (via addSubview:)
 */
@property (weak, readwrite, nonatomic) UIView *parentView;
/**
 *  The delegate for toast object
 */
@property (weak, readwrite, nonatomic) id<PGToastDelegate> delegate;
/**
 *  The block to execute when toasting completes
 */
@property (copy, readwrite, nonatomic) void (^completionBlock)(void);

/**
 *  Starts toasting timer
 */
- (void)startTimer;

/**
 *  Adds tap gesture recognizer on toastView
 */
- (void)addTapToCompleteIfNeeded;

/**
 *  Stops toasting timer and removes tap gesture recognizer, if set
 */
- (void)stopToasting;

/**
 *  Returns a Boolean value that indicates whether the toast currently toasting
 */
- (BOOL)isActive;

/**
 *  Returns a Boolean value that indicates whether the toast is started
 */
- (BOOL)isStarted;

@end

/**
 *  Protocol for the PGToast to notify delegate that toast must be ejected
 */
@protocol PGToastDelegate <NSObject>

@required
/**
 *  Notification that PGToast object must be ejected
 *
 *  @param toast toast to eject
 */
- (void)toastDidFinished:(PGToast *)toast;

@end
