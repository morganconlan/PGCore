//
//  PGTBDelegate.h
//  pgcore
//
//  Created by Morgan Conlan on 05/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PGSwipeCellRevealDirection) {
    PGSwipeCellRevealDirectionBoth = 0,
    PGSwipeCellRevealDirectionRight = 1,
    PGSwipeCellRevealDirectionLeft = 2,
    PGSwipeCellRevealDirectionNone = 3,
};

typedef NS_ENUM(NSUInteger, PGSwipeCellAnimationType) {
    PGSwipeCellAnimationTypeBounce = 0,
    PGSwipeCellAnimationTypeEaseIn,
    PGSwipeCellAnimationTypeEaseOut,
    PGSwipeCellAnimationTypeEaseInOut,
};

@class PGSwipeCell;

@protocol PGTBDelegate <NSObject>

- (id)objectForSelector:(SEL)sel
     onModelAtIndexPath:(NSIndexPath *)indexPath;

- (id)objectForSelector:(SEL)sel
         onModelForCell:(UITableViewCell *)cell;

- (void)performSelector:(SEL)sel
         onModelForCell:(UITableViewCell *)cell;

- (void)performSelectorWithDelegate:(SEL)sel
         onModelForCell:(UITableViewCell *)cell;

- (id)passDelegateGettingObjectForSelector:(SEL)sel
                        onModelAtIndexPath:(NSIndexPath *)indexPath;

- (id)passDelegateGettingObjectForSelector:(SEL)sel
                            onModelForCell:(UITableViewCell *)cell;

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell;

- (CGFloat)tableWidth;

@optional

#pragma mark - Swiping

- (void)swipeCellDidStartSwiping:(PGSwipeCell *)swipeCell;

- (void)swipeCell:(PGSwipeCell *)swipeCell
 swipedToLocation:(CGPoint)translation
         velocity:(CGPoint)velocity;

- (void)swipeCellWillResetState:(PGSwipeCell *)swipeCell
                   fromLocation:(CGPoint)translation
                      animation:(PGSwipeCellAnimationType)animation
                       velocity:(CGPoint)velocity;

- (void)swipeCellDidResetState:(PGSwipeCell *)swipeCell
                  fromLocation:(CGPoint)translation
                     animation:(PGSwipeCellAnimationType)animation
                      velocity:(CGPoint)velocity;


@end
