//
//  PGColouredAccessory.h
//  qualitas
//
//  Created by Morgan Conlan on 06/06/2013.
//  Copyright (c) 2013 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGColouredAccessory : UIControl {
    
	UIColor *_accessoryColour;
	UIColor *_highlightedColour;

}

@property (nonatomic, retain) UIColor *accessoryColour;
@property (nonatomic, retain) UIColor *highlightedColour;

+ (PGColouredAccessory *)accessoryWithColour:(UIColor *)colour;

@end
