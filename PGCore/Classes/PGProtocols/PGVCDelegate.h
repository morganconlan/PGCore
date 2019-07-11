//
//  PGVCDelegate.h
//  pgcore
//
//  Created by Morgan Conlan on 06/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PGVCDelegate

@required

+ (NSString *)menuTitle;
- (NSString *)navTitle;
- (CGFloat)width;

@end
