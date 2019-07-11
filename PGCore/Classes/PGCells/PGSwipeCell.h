//
//  PGSwipeCell.h
//  pgcore
//
//  Created by Morgan Conlan on 08/07/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCell.h"
#import "PGTBDelegate.h"

@class PGCellInfoWrapper;

#warning Can't use PGCell directly for some reason
@interface PGSwipeCell : UITableViewCell<UIGestureRecognizerDelegate> // PGCell <UIGestureRecognizerDelegate>

// hacked properties that should be inherited from PGCell
// TODO: remove
@property (nonatomic, strong) NSMutableDictionary *info;
@property (nonatomic, readwrite) UIView *backView;
@property (nonatomic, strong) UIColor *titleColour;

- (void)updateCellInfo:(NSMutableDictionary *)info;

// End

@property (nonatomic, readwrite) PGSwipeCellRevealDirection revealDirection; // default is RMSwipeTableViewCellRevealDirectionBoth
@property (nonatomic, readwrite) PGSwipeCellAnimationType animationType; // default is RMSwipeTableViewCellAnimationTypeBounce
@property (nonatomic, readwrite) float animationDuration; // default is 0.2
@property (nonatomic, readwrite) BOOL revealsBackground; // default is NO
@property (nonatomic, readwrite) BOOL shouldAnimateCellReset; // this can be overriden at any point (useful in the swipeTableViewCellWillResetState:fromLocation: delegate method). default is YES - note: it will reset to YES in prepareForReuse
@property (nonatomic, readwrite) BOOL panElasticity; // When panning/swiping the cell's location is set to exponentially decay. The elsticity/stickiness closely matches that of a UIScrollView/UITableView. default is YES
@property (nonatomic, strong) UIColor *backViewbackgroundColor; // default is [UIColor colorWithWhite:0.92 alpha:1]

// exposed class methods for easy subclassing
- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer;
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer;
- (void)animateContentViewForPoint:(CGPoint)translation velocity:(CGPoint)velocity;
- (void)resetCellFromPoint:(CGPoint)translation velocity:(CGPoint)velocity;
//- (UIView *)backView;
- (void)cleanupBackView;

@end
