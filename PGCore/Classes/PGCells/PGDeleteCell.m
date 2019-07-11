//
//  PGDeleteCell.m
//  pgcore
//
//  Created by Morgan Conlan on 09/07/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGDeleteCell.h"

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

@implementation PGDeleteCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:UITableViewCellStyleSubtitle
                     reuseIdentifier:reuseIdentifier])) {
        
        self.revealDirection = PGSwipeCellRevealDirectionRight;
        self.backViewbackgroundColor = [UIColor clearColor];
    }
    
    return self;
}

- (void)updateCellInfo:(NSDictionary*)info {
    
    self.info = info;
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    [self setNeedsDisplay];
    
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

- (void)animateContentViewForPoint:(CGPoint)translation
                         velocity:(CGPoint)velocity {
    
    [super animateContentViewForPoint:translation
                             velocity:velocity];
    
    [self.accessoryView setAlpha:0.0f];
    
    
    if (translation.x >= 0) return;
        
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
    
    if (translation.x < 0) {
        
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
    }
}



- (void)prepareForReuse {
	
    [super prepareForReuse];
    
	[self setUserInteractionEnabled:YES];
    [self.contentView setHidden:NO];
    [self cleanupBackView];
    
}

- (void)cleanupBackView {
    
    [super cleanupBackView];
    [_deleteGreyImageView removeFromSuperview];
    _deleteGreyImageView = nil;
    [_deleteRedImageView removeFromSuperview];
    _deleteRedImageView = nil;
    
}

@end
