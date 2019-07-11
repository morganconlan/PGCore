//
//  PGPlaceholder.m
//  pgcore
//
//  Created by Morgan Conlan on 08/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGPlaceholder.h"

@implementation PGPlaceholder

- (instancetype)initWithFrame:(CGRect)frame
                    topColour:(UIColor *)topColour
                 bottomColour:(UIColor *)bottomColour
                   textColour:(UIColor *)textColour
                      message:(NSString *)message {
    
    if ((self = [super initWithFrame:frame])) {
        
        _topColour = topColour;
        _bottomColour = bottomColour;
        _textColour = textColour;
        _message = message;

        [self setup];
        
    }
    
    return self;
}

- (void)setup {
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = @[(id)_topColour.CGColor, (id)_bottomColour.CGColor];
    [self.layer addSublayer:gradient];
    
    _lbl = [[UILabel alloc] initWithFrame:self.bounds];
    _lbl.backgroundColor = [UIColor clearColor];
    _lbl.text = _message;
    _lbl.font = [PGApp.app font:kPG_Font_Placeholder];
    _lbl.textColor = _textColour;
    _lbl.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:_lbl];
}

@end
