//
//  PGSectionWrapper.m
//  pgcore
//
//  Created by Morgan Conlan on 14/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGSectionWrapper.h"

@implementation PGSectionWrapper

+ (PGSectionWrapper *)emptySection {
    
    return [[PGSectionWrapper alloc] init];
}

+ (PGSectionWrapper *)section:(UIView *)section {
    
    PGSectionWrapper *wrapper = [[PGSectionWrapper alloc] init];
    wrapper.section = section;
    
    return wrapper;
}

- (void)reload {
    
    if ([_section respondsToSelector:@selector(reload)]) {
        
        [_section performSelector:@selector(reload)];
    
    }
    
}

@end
