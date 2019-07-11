//
//  PGColouredAccessory.m
//  qualitas
//
//  Created by Morgan Conlan on 06/06/2013.
//  Copyright (c) 2013 Morgan Conlan. All rights reserved.
//

#import "PGColouredAccessory.h"

@implementation PGColouredAccessory

@synthesize accessoryColour = _accessoryColour;
@synthesize highlightedColour = _highlightedColour;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
		
        self.backgroundColor = [UIColor clearColor];
        
    }
    
    return self;
}


+ (PGColouredAccessory *)accessoryWithColour:(UIColor *)colour {
    
	PGColouredAccessory *ret = [[PGColouredAccessory alloc] initWithFrame:CGRectMake(0, 0, 11.0, 15.0)];
	ret.accessoryColour = colour;
    
	return ret;
}

- (void)drawRect:(CGRect)rect {
    
	// (x,y) is the tip of the arrow
	CGFloat x = CGRectGetMaxX(self.bounds)-3.0;;
	CGFloat y = CGRectGetMidY(self.bounds);
	const CGFloat R = 4.5;
	CGContextRef ctxt = UIGraphicsGetCurrentContext();
	CGContextMoveToPoint(ctxt, x-R, y-R);
	CGContextAddLineToPoint(ctxt, x, y);
	CGContextAddLineToPoint(ctxt, x-R, y+R);
	CGContextSetLineCap(ctxt, kCGLineCapSquare);
	CGContextSetLineJoin(ctxt, kCGLineJoinMiter);
	CGContextSetLineWidth(ctxt, 3);
    
	if (self.highlighted) {
        
		[self.highlightedColour setStroke];
	
    } else {
		
        [self.accessoryColour setStroke];
        
	}
    
	CGContextStrokePath(ctxt);
    
}

- (void)setHighlighted:(BOOL)highlighted {
    
	[super setHighlighted:highlighted];
    
	[self setNeedsDisplay];
    
}

- (UIColor *)accessoryColour {
    
	if (!_accessoryColour) {
        
		return [UIColor blackColor];
	}
    
	return _accessoryColour;
}

- (UIColor *)highlightedColour {
    
	if (!_highlightedColour) {
        
		return [UIColor whiteColor];
	
    }
    
	return _highlightedColour;
    
}



@end
