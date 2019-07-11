//
//  NSString+PGToast.m
//
//  Created by Andrew Podkovyrin on 18/04/14.
//  Copyright (c) 2014 Andrew Podkovyrin. All rights reserved.
//

#import "NSString+PGToast.h"

@implementation NSString (PGToast)

- (CGSize)toastSizeWithFont:(UIFont *)font
          constrainedToSize:(CGSize)maxSize
              lineBreakMode:(NSLineBreakMode)lineBreakMode {

    CGSize size;

    size = [self boundingRectWithSize:maxSize
                              options:[[self class] stringOptionsForLineBreakMode:lineBreakMode]
                           attributes:@{NSFontAttributeName: font}
                              context:nil].size;
    
    if (size.width == 0.f
        || size.height == 0.f) return CGSizeZero;

#if defined(__LP64__) && __LP64__
    return CGSizeMake(ceil(size.width), ceil(size.height));
#else
    return CGSizeMake(ceilf(size.width), ceilf(size.height));
#endif

}

+ (NSStringDrawingOptions)stringOptionsForLineBreakMode:(NSLineBreakMode)lineBreakMode {

    switch (lineBreakMode) {

        case NSLineBreakByWordWrapping: return NSStringDrawingUsesLineFragmentOrigin;
        case NSLineBreakByTruncatingTail: return NSStringDrawingTruncatesLastVisibleLine;

        default: return NSStringDrawingUsesLineFragmentOrigin;

    }

}

@end
