//
//  PGSectionWrapper.h
//  pgcore
//
//  Created by Morgan Conlan on 14/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGSectionWrapper;

@interface PGSectionWrapper : NSObject

@property (nonatomic, strong) UIView *section;

+ (PGSectionWrapper *)emptySection;
+ (PGSectionWrapper *)section:(UIView *)section;
- (void)reload;

@end
