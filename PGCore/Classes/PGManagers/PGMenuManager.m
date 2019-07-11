//
//  PGMenuManager.m
//  pgcore
//
//  Created by Morgan Conlan on 06/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGMenuManager.h"

@implementation PGMenuManager

- (instancetype)initWithItems:(NSArray *)items {
    
    if ((self = [super init])) {
        
        _items = items;

        if (PGApp.app.configs.isDebugging
            && PGApp.app.configs.isDebuggingFiles) {

            _items = [_items arrayByAddingObject:@"PGVCFiles"];

        }
    }
    
    return self;
}

@end
