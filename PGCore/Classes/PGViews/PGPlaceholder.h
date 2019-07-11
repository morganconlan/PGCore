//
//  PGPlaceholder.h
//  pgcore
//
//  Created by Morgan Conlan on 08/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGApp.h"

@interface PGPlaceholder : UIView

@property (nonatomic, strong) UIColor *topColour;
@property (nonatomic, strong) UIColor *bottomColour;
@property (nonatomic, strong) UIColor *textColour;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) UILabel *lbl;

- (instancetype)initWithFrame:(CGRect)frame
                    topColour:(UIColor *)topColour
                 bottomColour:(UIColor *)bottomColour
                   textColour:(UIColor *)textColour
                      message:(NSString *)message;

@end
