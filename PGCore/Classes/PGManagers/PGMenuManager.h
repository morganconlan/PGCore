//
//  PGMenuManager.h
//  pgcore
//
//  Created by Morgan Conlan on 06/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGApp.h"

@interface PGMenuManager : NSObject

/**An array of view controller name strings*/
@property (nonatomic, strong) NSArray *items;
@property (nonatomic, strong) UIColor *backgroundColour;

- (instancetype)initWithItems:(NSArray *)items;
//- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
