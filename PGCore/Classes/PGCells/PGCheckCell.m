//
//  PGCheckCell.m
//  pgcore
//
//  Created by Morgan Conlan on 09/07/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGCheckCell.h"

#define imgCheckInactive (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_check_inactive"]; \
        		NSAssert(image, @"Image icon_check_inactive not found"); \
        		return image; \
        }()

#define imgCheckActive (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_check_active"]; \
        		NSAssert(image, @"Image icon_check_active not found"); \
        		return image; \
        }()

#define imgCheckSelected (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_check_selected"]; \
        		NSAssert(image, @"Image icon_check_selected not found"); \
        		return image; \
        }()

#define kYOffset 16.0f

@implementation PGCheckCell


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style
                     reuseIdentifier:reuseIdentifier])) {
        
        self.revealDirection = PGSwipeCellRevealDirectionLeft;
        self.backViewbackgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}

- (void)updateCellInfo:(NSMutableDictionary *)info {
    
    [super updateCellInfo:info];
    
    if (info[@"is_checked"]) {
        [self setChecked:[info[@"is_checked"] boolValue]
                animated:NO];
    }

    if (info[@"reveal_direction"]) {

        switch ([info[@"reveal_direction"] integerValue]) {

            case 0:
                self.revealDirection = PGSwipeCellRevealDirectionBoth;
                break;

            case 1:
                self.revealDirection = PGSwipeCellRevealDirectionRight;
                break;
            case 2:
                self.revealDirection = PGSwipeCellRevealDirectionLeft;
                break;
            case 3:
                self.revealDirection = PGSwipeCellRevealDirectionNone;
                break;

        }

    }

}

- (void)drawContentView:(CGRect)rect {
    
    CGFloat useableWidth = [self.info[kPGCell_DelegateWidth] floatValue] - 80.0f;
    
    CGFloat cellHeight = kYOffset;
    
    //Title
    NSString *title = self.info[@"title"];
    CGSize constraintSize = CGSizeMake(useableWidth, MAXFLOAT);
    CGSize titleSize = [title sizeWithFont:[PGApp.app font:kPG_Font_Cell_Default]
                         constrainedToSize:constraintSize
                             lineBreakMode:NSLineBreakByWordWrapping];
    
    if (self.titleColour == nil) {
        self.titleColour  = [PGApp.app hex:0x333333];
    }
    
    [self.titleColour set];
    
    [title drawInRect:CGRectMake(40.0f, cellHeight, useableWidth, titleSize.height)
             withFont:[PGApp.app font:kPG_Font_Cell_Default]
        lineBreakMode:NSLineBreakByWordWrapping];
    
}

+ (CGFloat)heightWithCellInfo:(NSDictionary *)info {
    
    //width minus favoutite button and accessory
    CGFloat useableWidth = [info[kPGCell_DelegateWidth] floatValue] - 80.0f;
    
    CGFloat cellHeight = kYOffset;
    
    //Title
    NSString *title = info[@"title"];
    CGSize constraintSize = CGSizeMake(useableWidth, MAXFLOAT);
    CGSize titleSize = [title sizeWithFont:[PGApp.app font:kPG_Font_Cell_Default]
                         constrainedToSize:constraintSize
                             lineBreakMode:NSLineBreakByWordWrapping];
    
    cellHeight += titleSize.height + (kYOffset / 2);
    
    return ceilf(cellHeight);
    
}

- (UIImageView*)checkmarkGreyImageView {
    
    if (!_checkmarkGreyImageView) {
        
        CGRect frame = CGRectMake(0,
                                  0,
                                  CGRectGetHeight(self.frame),
                                  CGRectGetHeight(self.frame));
        
        _checkmarkGreyImageView = [[UIImageView alloc] initWithFrame:frame];
        
        if (_inactiveCheckIcon == nil) {
            _inactiveCheckIcon = imgCheckInactive;
        }
        
        [_checkmarkGreyImageView setImage:_inactiveCheckIcon];
        [_checkmarkGreyImageView setContentMode:UIViewContentModeCenter];
        [self.backView addSubview:_checkmarkGreyImageView];
        
    }
    
    return _checkmarkGreyImageView;
}

- (UIImageView*)checkmarkGreenImageView {
    
    if (!_checkmarkGreenImageView) {
        
        _checkmarkGreenImageView = [[UIImageView alloc] initWithFrame:self.checkmarkGreyImageView.bounds];
        
        if (_activeCheckIcon == nil) {
            _activeCheckIcon = imgCheckActive;
        }
        
        [_checkmarkGreenImageView setImage:_activeCheckIcon];
        [_checkmarkGreenImageView setContentMode:UIViewContentModeCenter];
        [self.checkmarkGreyImageView addSubview:_checkmarkGreenImageView];
        
    }
    
    return _checkmarkGreenImageView;
}


- (UIImageView*)checkmarkItemImageView {
    
    if (!_checkmarkItemImageView) {
        
        if (_selectedCheckIcon == nil) {
            _selectedCheckIcon = imgCheckSelected;
        }
        
        _checkmarkItemImageView = [[UIImageView alloc] initWithImage:_selectedCheckIcon];
        [_checkmarkItemImageView setFrame:CGRectMake(10, (self.bounds.size.height - 20) / 2, 20, 20)];
        [_checkmarkItemImageView setAlpha:0.0f];
        [self.contentView addSubview:_checkmarkItemImageView];
    }
    
    return _checkmarkItemImageView;
}

- (void)setChecked:(BOOL)checked
          animated:(BOOL)animated {

    self.isChecked = checked;
    
    if (animated) {
        
        if (checked) {
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            animation.toValue = (id)[UIColor colorWithRed:0.149 green:0.784 blue:0.424 alpha:0.750].CGColor;
            animation.fromValue = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.duration = 0.25;
            
            if (_checkmarkItemImageView == nil) [self checkmarkItemImageView];
            [_checkmarkItemImageView setAlpha:0.25];
            
            [UIView animateWithDuration:0.25
                             animations:^
             {
                 [_checkmarkItemImageView setAlpha:1];
             }];
            
        } else {
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"borderColor"];
            animation.toValue = (id)[UIColor colorWithWhite:0 alpha:0.3].CGColor;
            animation.fromValue = (id)[UIColor colorWithRed:0.149 green:0.784 blue:0.424 alpha:0.750].CGColor;
            animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            animation.duration = 0.25;
            
            [UIView animateWithDuration:0.25
                             animations:^
             {
                 [_checkmarkItemImageView setAlpha:0];
             }
                             completion:nil];
        }
        
    } else {
        
        if (checked) {
            
            if (_checkmarkItemImageView == nil) [self checkmarkItemImageView];
            [_checkmarkItemImageView setAlpha:1];
            
        } else {
            
            [_checkmarkItemImageView setAlpha:0];
            
        }
    }
}

- (void)animateContentViewForPoint:(CGPoint)translation
                          velocity:(CGPoint)velocity {
    
    [super animateContentViewForPoint:translation
                             velocity:velocity];
    
    [UIView animateWithDuration:0.5f
                     animations:^{ [_checkmarkItemImageView setAlpha:0];}];
    
    if (translation.x > 0) {
        
        [self.checkmarkGreyImageView setFrame:CGRectMake(MIN(CGRectGetMinX(self.contentView.frame)
                                                             - CGRectGetWidth(self.checkmarkGreyImageView.frame), 0),
                                                         CGRectGetMinY(self.checkmarkGreyImageView.frame),
                                                         CGRectGetWidth(self.checkmarkGreyImageView.frame),
                                                         CGRectGetHeight(self.checkmarkGreyImageView.frame))];
        
        if (self.contentView.frame.origin.x > CGRectGetWidth(self.checkmarkGreyImageView.frame)
            && self.isChecked == NO) {
            
            [self.checkmarkGreenImageView setAlpha:1];
            
        } else if (self.isChecked == NO) {
            
            [self.checkmarkGreenImageView setAlpha:0];
            
        } else if (self.contentView.frame.origin.x > CGRectGetWidth(self.checkmarkGreyImageView.frame)
                   && self.isChecked == YES) {
            
            if (self.checkmarkGreyImageView.alpha == 1) {
                
                [UIView animateWithDuration:0.25
                                 animations:^{
                                     CATransform3D rotate = CATransform3DMakeRotation(-0.4, 0, 0, 1);
                                     [self.checkmarkGreenImageView.layer setTransform:CATransform3DTranslate(rotate, -10, 20, 0)];
                                     [self.checkmarkGreenImageView setAlpha:0];
                                 }];
                
            }
            
        } else if (self.isChecked == YES) {
            
            CATransform3D rotate = CATransform3DMakeRotation(0, 0, 0, 1);
            [self.checkmarkGreenImageView.layer setTransform:CATransform3DTranslate(rotate, 0, 0, 0)];
            [self.checkmarkGreenImageView setAlpha:1];
            
        }
        
    }
}

- (void)resetCellFromPoint:(CGPoint)translation
                  velocity:(CGPoint)velocity {
    
    [super resetCellFromPoint:translation
                     velocity:velocity];
    
    if (translation.x > 0
        && translation.x < CGRectGetHeight(self.frame) * 1.5) {
        
        [UIView animateWithDuration:0.2
                         animations:^
         {
             [self.checkmarkGreyImageView setFrame:CGRectMake(-CGRectGetWidth(self.checkmarkGreyImageView.frame),
                                                              CGRectGetMinY(self.checkmarkGreyImageView.frame),
                                                              CGRectGetWidth(self.checkmarkGreyImageView.frame),
                                                              CGRectGetHeight(self.checkmarkGreyImageView.frame))];
         }];
        
    }
    
    if (self.isChecked) {
        [UIView animateWithDuration:0.5f
                         animations:^{ [_checkmarkItemImageView setAlpha:1];}];
    }
}

- (void)prepareForReuse {
    [super prepareForReuse];
    
    [_checkmarkItemImageView removeFromSuperview];
    _checkmarkItemImageView = nil;
}

- (void)cleanupBackView {
    
    [super cleanupBackView];
    [_checkmarkGreyImageView removeFromSuperview];
    _checkmarkGreyImageView = nil;
    [_checkmarkGreenImageView removeFromSuperview];
    _checkmarkGreenImageView = nil;
    
}

@end
