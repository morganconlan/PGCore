//
//  PGVCImageViewer.h
//  gaa_fixtures
//
//  Created by Morgan Conlan on 16/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGVC.h"

@interface PGVCImageViewer : PGVC

/**
 *  Args should have a NSURL url, NSNumber w, NSNumber h
 */
- (instancetype)initWithPhotoConfig:(NSDictionary *)args;

@end
