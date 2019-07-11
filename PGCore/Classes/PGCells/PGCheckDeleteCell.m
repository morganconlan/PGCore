//
//  PGCheckDeleteCell.m
//  pgcore
//
//  Created by Morgan Conlan on 27/07/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGCheckDeleteCell.h"

#define imgDeleteInactive (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_delete_inactive"]; \
        		NSAssert(image, @"Image icon_delete_inactive not found"); \
        		return image; \
        }()

#define imgDeleteActive (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_delete_active"]; \
        		NSAssert(image, @"Image icon_delete_active not found"); \
        		return image; \
        }()

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

@implementation PGCheckDeleteCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle
                     reuseIdentifier:reuseIdentifier])) {
        
        self.revealDirection = PGSwipeCellRevealDirectionBoth;
        self.backViewbackgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (UIImageView*)deleteGreyImageView {
    
    if (!_deleteGreyImageView) {
        
        CGRect frame = CGRectMake(CGRectGetMaxX(self.contentView.frame),
                                  0,
                                  CGRectGetHeight(self.frame),
                                  CGRectGetHeight(self.frame));
        
        _deleteGreyImageView = [[UIImageView alloc] initWithFrame:frame];
        
        if (_inactiveDeleteIcon == nil) {
            _inactiveDeleteIcon = imgDeleteInactive;
        }
        
        [_deleteGreyImageView setImage:_inactiveDeleteIcon];
        [_deleteGreyImageView setContentMode:UIViewContentModeCenter];
        
        [self.backView addSubview:_deleteGreyImageView];
        
    }
    
    return _deleteGreyImageView;
}

- (UIImageView*)deleteRedImageView {
    
    if (!_deleteRedImageView) {
        
        _deleteRedImageView = [[UIImageView alloc] initWithFrame:self.deleteGreyImageView.bounds];
        
        if (_activeDeleteIcon == nil) {
            _activeDeleteIcon = imgDeleteActive;
        }
        
        [_deleteRedImageView setImage:_activeDeleteIcon];
        [_deleteRedImageView setContentMode:UIViewContentModeCenter];
        
        [self.deleteGreyImageView addSubview:_deleteRedImageView];
        
    }
    
    return _deleteRedImageView;
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

- (void)updateCellInfo:(NSMutableDictionary *)info {
    [super updateCellInfo:info];
    
    if (info[@"is_checked"]) {
        [self setChecked:[info[@"is_checked"] boolValue]
                animated:NO];
    }
    
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
    
    [self.accessoryView setAlpha:0.0f];
    
    
    [self animateContentViewForCheck];
    [self animateContentViewForDelete];
        
   
    
    
}

- (void)animateContentViewForCheck {
    
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

- (void)animateContentViewForDelete {
    
    CGRect frame = CGRectMake(MAX(CGRectGetMaxX(self.frame)
                                  - CGRectGetWidth(self.deleteGreyImageView.frame),
                                  CGRectGetMaxX(self.contentView.frame)),
                              CGRectGetMinY(self.deleteGreyImageView.frame),
                              CGRectGetWidth(self.deleteGreyImageView.frame),
                              CGRectGetHeight(self.deleteGreyImageView.frame));
    
    [self.deleteGreyImageView setFrame:frame];
    
    if (CGRectGetMaxX(self.contentView.frame)
        < (CGRectGetMaxX(self.frame)
           - CGRectGetWidth(self.deleteGreyImageView.frame))) {
            
            [self.deleteRedImageView setAlpha:1];
            
        } else {
            
            [self.deleteRedImageView setAlpha:0];
        }
    
}

- (void)resetCellFromPoint:(CGPoint)translation
                 velocity:(CGPoint)velocity {
    
    [super resetCellFromPoint:translation
                     velocity:velocity];
    
    if (translation.x < 0) { // Delete
        
        CGRect frame = CGRectMake(CGRectGetMaxX(self.frame),
                                  CGRectGetMinY(self.deleteGreyImageView.frame),
                                  CGRectGetWidth(self.deleteGreyImageView.frame),
                                  CGRectGetHeight(self.deleteGreyImageView.frame));
        
        [UIView animateWithDuration:0.2
                         animations:^
        {
            
            [self.deleteGreyImageView setFrame:frame];
            
            [self.accessoryView setAlpha:1.0f];
            
        }];
    
    } else { // Check
        
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
        
    }
    
    if (self.isChecked) {
        [UIView animateWithDuration:0.5f
                         animations:^{ [_checkmarkItemImageView setAlpha:1];}];
    }
}

- (void)prepareForReuse {
	
    [super prepareForReuse];
    
	[self setUserInteractionEnabled:YES];
    [self.contentView setHidden:NO];
    [_checkmarkItemImageView removeFromSuperview];
    _checkmarkItemImageView = nil;
    [self cleanupBackView];
    
}

- (void)cleanupBackView {
    
    [super cleanupBackView];
    [_deleteGreyImageView removeFromSuperview];
    _deleteGreyImageView = nil;
    [_deleteRedImageView removeFromSuperview];
    _deleteRedImageView = nil;
    [_checkmarkGreyImageView removeFromSuperview];
    _checkmarkGreyImageView = nil;
    [_checkmarkGreenImageView removeFromSuperview];
    _checkmarkGreenImageView = nil;
    
}

@end
