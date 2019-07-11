//
//  NSString+PGToast.h
//
//  Created by Andrew Podkovyrin on 18/04/14.
//  Copyright (c) 2014 Andrew Podkovyrin. All rights reserved.
//

#import <UIKit/UIkit.h>

@interface NSString (PGToast)

- (CGSize)toastSizeWithFont:(UIFont *)font
             constrainedToSize:(CGSize)maxSize
                 lineBreakMode:(NSLineBreakMode)lineBreakMode;

@end
