//
//  PGSearchBar.h
//  oireachtas
//
//  Created by Morgan Conlan on 16/10/2013.
//  Copyright (c) 2013 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGSearchBar : UISearchBar

- (void)setCloseButtonTitle:(NSString *)title
                   forState:(UIControlState)state;

@end
