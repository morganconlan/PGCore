//
//  UIView+PGToast.m
//
//  Created by Andrew Podkovyrin on 18/04/14.
//  Copyright (c) 2014 Andrew Podkovyrin. All rights reserved.
//

#import "UIView+PGToast.h"
#import <QuartzCore/QuartzCore.h>
#import "UIView+PGToastStyle.h"
#import "NSString+PGToast.h"
#import "PGToaster.h"


@implementation UIView (PGToast)

#pragma mark - Text toast

- (NSInteger)makeToast:(NSString *)toastText {

    return [self makeToast:toastText
                  duration:[[self class] toastDuration]];

}

- (NSInteger)makeToast:(NSString *)toastText
              duration:(NSTimeInterval)duration {

    return [self makeToast:toastText
                  duration:duration
                  position:PGToastPositionBottom];

}

- (NSInteger)makeToast:(NSString *)toastText
              duration:(NSTimeInterval)duration
              position:(PGToastPosition)position {

    return [self makeToast:toastText
                  duration:duration
                  position:position
                completion:nil];

}

- (NSInteger)makeToast:(NSString *)toastText
              duration:(NSTimeInterval)duration
              position:(PGToastPosition)position
            completion:(void (^)(void))completion {

    if (!toastText.length) return NSNotFound;
    
    UIView *toastView = [self toastViewForText:toastText];
    CGPoint center = [self centerPointForPosition:position
                                        toastView:toastView];

    return [self makeToastView:toastView
                      duration:duration
                        center:center
                 tapToComplete:[[self class] toastTapToComplete]
                    completion:completion];

}

- (NSInteger)makeToast:(NSString *)toastText
                 duration:(NSTimeInterval)duration
                   center:(CGPoint)center
            tapToComplete:(BOOL)tapToComplete
               completion:(void (^)(void))completion {

    if (!toastText.length) return NSNotFound;
    
    UIView *toastView = [self toastViewForText:toastText];
    return [self makeToastView:toastView
                      duration:duration
                        center:center
                 tapToComplete:tapToComplete
                    completion:completion];

}

#pragma mark - View toast

- (NSInteger)makeToastView:(UIView *)toastView {

    return [self showToastView:toastView
                      duration:[[self class] toastDuration]];

}

- (NSInteger)showToastView:(UIView *)toastView
                  duration:(NSTimeInterval)duration {

    return [self makeToastView:toastView
                      duration:duration
                      position:PGToastPositionBottom];

}

- (NSInteger)makeToastView:(UIView *)toastView
                  duration:(NSTimeInterval)duration
                  position:(PGToastPosition)position {

    CGPoint center = [self centerPointForPosition:position
                                        toastView:toastView];
    return [self makeToastView:toastView
                      duration:duration
                        center:center
                 tapToComplete:[[self class] toastTapToComplete]
                    completion:nil];

}

- (NSInteger)makeToastView:(UIView *)toastView
                     duration:(NSTimeInterval)duration
                       center:(CGPoint)center
                tapToComplete:(BOOL)tapToComplete
                   completion:(void (^)(void))completion {

    if (!toastView) return NSNotFound;

    toastView.center = center;
    
    return [[PGToaster sharedInstance] makeToast:toastView
                                      parentView:self
                                        duration:duration
                                   tapToComplete:tapToComplete
                                      completion:completion];

}

#pragma mark - Eject

- (void)ejectToast:(NSInteger)toastID {

    [self ejectToast:toastID
            animated:YES];

}

- (void)ejectToast:(NSInteger)toastID
          animated:(BOOL)animated {

    [[PGToaster sharedInstance] ejectToastWithID:toastID
                                        animated:animated];

}

#pragma mark - Text toast view

- (UIView *)toastViewForText:(NSString *)toastText {

    UIView *toastView = [[UIView alloc] init];
    toastView.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin |
                                  UIViewAutoresizingFlexibleRightMargin |
                                  UIViewAutoresizingFlexibleTopMargin |
                                  UIViewAutoresizingFlexibleBottomMargin);
    toastView.layer.cornerRadius = [[self class] toastCornerRadius];
    toastView.backgroundColor = [UIColor colorWithWhite:0.f alpha:[[self class] toastOpacity]];
    
    UILabel *textLabel = [[UILabel alloc] init];
    textLabel.numberOfLines = [[self class] toastMaxNumberOfLines];
    textLabel.font = [[self class] toastFont];
    textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.text = toastText;
    [toastView addSubview:textLabel];
    
    CGFloat horizontalPadding = [[self class] toastHorizontalPadding] * 2;
    CGFloat toastViewWidth = CGRectGetWidth(self.bounds) - horizontalPadding;
    CGSize maxTextSize = CGSizeMake(toastViewWidth - horizontalPadding, CGRectGetHeight(self.bounds) * [[self class] toastMaxHeightPercent]);
    CGSize textSize = [textLabel.text toastSizeWithFont:textLabel.font constrainedToSize:maxTextSize lineBreakMode:textLabel.lineBreakMode];
    CGFloat toastViewHeight = MAX(textSize.height + [[self class] toastVerticalPadding] * 2, [[self class] toastMinHeight]);
    
    toastView.frame = CGRectMake(0.f, 0.f, toastViewWidth, toastViewHeight);
    textLabel.frame = toastView.bounds;
    
    return toastView;

}

#pragma mark - Additions

- (CGPoint)centerPointForPosition:(PGToastPosition)position
                        toastView:(UIView *)toastView {

    CGFloat padding = [[self class] toastVerticalPadding];
    CGFloat w = CGRectGetWidth(self.bounds);
    CGFloat h = CGRectGetHeight(self.bounds);
    CGFloat toastHeight = CGRectGetHeight(toastView.frame);
    
    switch (position) {
        case PGToastPositionBottom:
            return CGPointMake(w / 2.f, h - toastHeight / 2.f - padding);
        case PGToastPositionTop:
            return CGPointMake(w / 2.f, toastHeight / 2.f + padding);
        case PGToastPositionCenter:
            return CGPointMake(w / 2.f, h / 2.f);
    }

}

@end
