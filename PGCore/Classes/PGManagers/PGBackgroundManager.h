//
//  PGBackgroundManager.h
//  pgcore
//
//  Created by Morgan Conlan on 10/06/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGApp.h"
#import "PGVC.h"

@interface PGBackgroundManager : NSObject

@property (nonatomic, assign) BOOL isImageBackground;
@property (nonatomic, assign) BOOL isAlwaysViewBackground;

- (instancetype)initForCustomBackground;

- (UIView *)backgroundForPGVC:(PGVC *)pgvc;
- (UIView *)backgroundViewForPGVC:(PGVC *)pgvc;
/**
 *  Search PGColourManager for the background colour of the given view controller
 *  return the default background colour if nothing is found
 *
 *  @param pgvc PGVC subclass
 *
 *  @return UIColor
 */
- (UIColor *)backgroundColourForVC:(PGVC *)pgvc;

@end
