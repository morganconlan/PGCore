//
//  PGSearchBar.m
//  oireachtas
//
//  Created by Morgan Conlan on 16/10/2013.
//  Copyright (c) 2013 Morgan Conlan. All rights reserved.
//

#import "PGSearchBar.h"

@implementation PGSearchBar

- (void)setCloseButtonTitle:(NSString *)title
                   forState:(UIControlState)state {
    
    [self setTitle:title
          forState:state
           forView:self];

}

- (void)setTitle:(NSString *)title
        forState:(UIControlState)state
        forView:(UIView *)view {
    
    UIButton *cancelButton = nil;
    
    for(UIView *subView in view.subviews) {
        
        if([subView isKindOfClass:UIButton.class]) {
            
            cancelButton = (UIButton*)subView;
        
        } else {
            
            [self setTitle:title
                  forState:state
                   forView:subView];
        }
    }
    
    if (cancelButton) [cancelButton setTitle:title
                                    forState:state];
    
}

@end
