//
//  PGBackgroundManager.m
//  pgcore
//
//  Created by Morgan Conlan on 10/06/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGBackgroundManager.h"

@implementation PGBackgroundManager

- (instancetype)init {
    
    if ((self = [super init])) {
        
        _isImageBackground = ([PGApp.app image:kPG_Image_Background] != nil);
        
    }
    
    return self;
}

- (instancetype)initForCustomBackground {
    
    if ((self = [super init])) {
        
        _isImageBackground = NO;
        _isAlwaysViewBackground = YES;
        
    }
    
    return self;
    
}

- (UIView *)backgroundForPGVC:(PGVC *)pgvc {
    
    if (pgvc.isCustomBackground
        || _isAlwaysViewBackground) {

        return [self backgroundViewForPGVC:pgvc];
    }
    
    if (_isImageBackground) {
        
        return (pgvc.isPortrait)
                    ? self.backgroundImageForPortrait
                    : self.backgroundImageForLandscape;
        
    }
    
    // No background!
    return [[UIView alloc] init];
}


- (UIView *)backgroundImageForPortrait {
    
	return [[UIImageView alloc] initWithImage:(IS_PHONEPOD5())
                                                ? [PGApp.app image:kPG_Image_Background568]
                                                : [PGApp.app image:kPG_Image_Background]];
    
}

- (UIView *)backgroundImageForLandscape {
    
	return [[UIImageView alloc] initWithImage:(IS_PHONEPOD5())
                                                ? [PGApp.app image:kPG_Image_Background568Landscape]
                                                : [PGApp.app image:kPG_Image_BackgroundLandscape] ];
    
}

- (UIView *)backgroundViewForPGVC:(PGVC *)pgvc {
    
    DDLogWarn(@"This method should be implemented by a subclass");
    UIView *customBackground = [[UIView alloc] initWithFrame:pgvc.backgroundFrame];
    customBackground.backgroundColor = [PGApp.app colour:kPG_Colour_PGVC_Background];
    
    return customBackground;
}

- (UIColor *)backgroundColourForVC:(PGVC *)pgvc {
    
    UIColor *backgroundColour = PGApp.app.coloursManager.colours[[self backgroundColourKey:pgvc]];
    
    return (backgroundColour != nil)
                ? backgroundColour
                : [PGApp.app colour:kPG_Colour_PGVC_Background];
}

/**
 *  Creates the key for the colours manager colour dictionary
 *
 *  @param pgvc The view controller for which the background colour is requested
 *
 *  @return NSString The colour key
 */
- (NSString *)backgroundColourKey:(PGVC *)pgvc {
    
    NSString *key = [NSString stringWithFormat:@"kPG_Colour_Background_%@",
                     NSStringFromClass([pgvc class])];
    
//    DDLogVerbose(@"%@", key);
    
    return key;
}


@end
