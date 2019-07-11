//
//  PGSwipeCell.m
//  pgcore
//
//  Created by Morgan Conlan on 08/07/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGSwipeCell.h"

//@interface PGSwipeCell()
//
//@property (nonatomic, readwrite) UIView *backView;
//
//@end

@implementation PGSwipeCell

//- (id)initWithStyle:(UITableViewCellStyle)style
//    reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    if ((self = [super initWithStyle:style
//                     reuseIdentifier:reuseIdentifier])) {
//        
//        // We need to set the contentView's background colour, otherwise the sides are clear on the swipe and animations
//        [self.contentView setBackgroundColor:[UIColor whiteColor]];
//        
//        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
//        [panGestureRecognizer setDelegate:self];
//        [self addGestureRecognizer:panGestureRecognizer];
//        
//        self.revealDirection = PGSwipeCellRevealDirectionBoth;
//        self.animationType = PGSwipeCellAnimationTypeBounce;
//        self.animationDuration = 0.1f;
//        self.shouldAnimateCellReset = YES;
////        self.backViewbackgroundColor = [UIColor colorWithWhite:0.92 alpha:1];
//        self.panElasticity = YES;
//        
//        UIView *backgroundView = [[UIView alloc] initWithFrame:self.contentView.frame];
//        backgroundView.backgroundColor = [UIColor clearColor];
//        self.backgroundView = backgroundView;
//    
//    }
//    
//    return self;
//}
//
//- (void)prepareForReuse {
//    [super prepareForReuse];
//    
//    self.shouldAnimateCellReset = YES;
//}
//
//- (void)handlePanGesture:(UIPanGestureRecognizer *)panGestureRecognizer {
//    
//    CGPoint translation = [panGestureRecognizer translationInView:panGestureRecognizer.view];
//    CGPoint velocity = [panGestureRecognizer velocityInView:panGestureRecognizer.view];
//    
//    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan
//        && [panGestureRecognizer numberOfTouches] > 0) {
//    
//        if ([self.delegate respondsToSelector:@selector(swipeCellDidStartSwiping)]) {
//            [self.delegate swipeCellDidStartSwiping:self];
//        }
//        
//        [self animateContentViewForPoint:translation
//                                velocity:velocity];
//        
//    } else if (panGestureRecognizer.state == UIGestureRecognizerStateChanged
//               && [panGestureRecognizer numberOfTouches] > 0) {
//
//        [self animateContentViewForPoint:translation
//                                velocity:velocity];
//        
//    } else if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
//        
//        [self resetCellFromPoint:translation
//                        velocity:velocity];
//    }
//}
//
//#pragma mark - Gesture recognizer delegate
//
//- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)panGestureRecognizer {
//  
//    // We only want to deal with the gesture of it's a pan gesture
//    if ([panGestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
//        
//        CGPoint translation = [panGestureRecognizer translationInView:[self superview]];
//        return (fabs(translation.x) / fabs(translation.y) > 1)
//                ? YES
//                : NO;
//        
//    } else {
//        
//        return NO;
//        
//    }
//}
//
//#pragma mark - Gesture animations
//
//- (void)animateContentViewForPoint:(CGPoint)translation
//                          velocity:(CGPoint)velocity {
//    
//    if ((translation.x > 0
//            && self.revealDirection == PGSwipeCellRevealDirectionLeft)
//        || (translation.x < 0
//            && self.revealDirection == PGSwipeCellRevealDirectionRight)
//        || self.revealDirection == PGSwipeCellRevealDirectionBoth) {
//        
//        if (!self.backView) {
//
//            self.backView = [[UIView alloc] initWithFrame:self.contentView.frame];
//            self.backView.backgroundColor = self.backViewbackgroundColor;
//            
//        }
//        
//        [self.backgroundView addSubview:self.backView];
//        float panOffset = translation.x;
//        
//        if (self.panElasticity) {
//        
//            if (translation.x < 0) {
//            
//                panOffset = expf(translation.x / CGRectGetWidth(self.frame)) * translation.x;
//            
//            } else {
//            
//                panOffset = (1.0 / expf(translation.x / CGRectGetWidth(self.frame))) * translation.x;
//            
//            }
//        }
//        
//        self.contentView.frame = CGRectOffset(self.contentView.bounds, panOffset, 0);
//        
//        if ([self.delegate respondsToSelector:@selector(swipeCell:swipedToLocation:velocity:)]) {
//            
//            [self.delegate swipeCell:self
//                    swipedToLocation:translation
//                            velocity:velocity];
//            
//        }
//    }
//}
//
//- (void)resetCellFromPoint:(CGPoint)translation
//                  velocity:(CGPoint)velocity {
//    
//    if ([self.delegate respondsToSelector:@selector(swipeCellWillResetState:fromLocation:animation:velocity:)]) {
//        
//        [self.delegate swipeCellWillResetState:self
//                                  fromLocation:translation
//                                     animation:self.animationType
//                                      velocity:velocity];
//        
//    }
//    
//    if (self.shouldAnimateCellReset == NO) return;
//    
//    if ((self.revealDirection == PGSwipeCellRevealDirectionLeft
//            && translation.x < 0)
//        || (self.revealDirection == PGSwipeCellRevealDirectionRight
//            && translation.x > 0)) return;
//            
//    
//    if (self.animationType == PGSwipeCellAnimationTypeBounce) {
//        
//        // Animation lvl 1
//        [UIView animateWithDuration:self.animationDuration
//                              delay:0
//                            options:UIViewAnimationOptionCurveEaseIn
//                         animations:^
//        {
//            
//            self.contentView.frame = CGRectOffset(self.contentView.bounds,
//                                                  0 - (translation.x * 0.03),
//                                                  0);
//            
//        }
//                         completion:^(BOOL finished)
//        {
//            // Animation lvl 2
//            [UIView animateWithDuration:0.1
//                                  delay:0
//                                options:UIViewAnimationOptionCurveEaseInOut
//                             animations:^
//            {
//                
//                self.contentView.frame = CGRectOffset(self.contentView.bounds,
//                                                      0 + (translation.x * 0.02),
//                                                      0);
//                
//            }
//                              completion:^(BOOL finished)
//            {
//                // Animation lvl 3
//                [UIView animateWithDuration:0.1
//                                    delay:0
//                                  options:UIViewAnimationOptionCurveEaseOut
//                               animations:^
//                {
//                    
//                    self.contentView.frame = self.contentView.bounds;
//                    
//                }
//                               completion:^(BOOL finished)
//                {
//                    
//                    [self cleanupBackView];
//                    
//                    if ([self.delegate respondsToSelector:@selector(swipeCellDidResetState:fromLocation:animation:velocity:)]) {
//                        
//                        [self.delegate swipeCellDidResetState:self
//                                                 fromLocation:translation
//                                                    animation:self.animationType
//                                                     velocity:velocity];
//                        
//                    }
//                    
//                }]; // lvl 3
//                
//            }]; // lvl 2
//            
//        }]; // lvl 1
//        
//    } else {
//        
//        UIViewAnimationOptions option;
//        
//        switch (self.animationType) {
//            case PGSwipeCellAnimationTypeEaseInOut:
//                option = UIViewAnimationOptionCurveEaseInOut;
//                break;
//            case PGSwipeCellAnimationTypeEaseIn:
//                option = UIViewAnimationOptionCurveEaseIn;
//                break;
//            case PGSwipeCellAnimationTypeEaseOut:
//                option = UIViewAnimationOptionCurveEaseOut;
//                break;
//            default:
//                option = UIViewAnimationOptionCurveEaseOut;
//                break;
//        }
//        
//        [UIView animateWithDuration:self.animationDuration
//                              delay:0
//                            options:option
//                         animations:^
//        {
//        
//            self.contentView.frame = CGRectOffset(self.contentView.bounds, 0, 0);
//            
//        }
//                         completion:^(BOOL finished)
//        {
//            
//            if ([self.delegate respondsToSelector:@selector(swipeCellDidResetState:fromLocation:animation:velocity:)]) {
//            
//                [self.delegate swipeCellDidResetState:self
//                                         fromLocation:translation
//                                            animation:self.animationType
//                                             velocity:velocity];
//                
//            }
//            
//            [self cleanupBackView];
//            
//        }];
//    }
//}
//
//- (void)cleanupBackView {
//    
//    [self.backView removeFromSuperview];
//    self.backView = nil;
//    
//}

@end
