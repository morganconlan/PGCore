//
//  PGMenuController.h
//  pgcore
//
//  Created by Morgan Conlan on 05/04/2013.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGTBVC.h"

@interface PGMenuController : UIViewController// PGTBVC

@property (nonatomic, assign) BOOL isAnimatingMenu;

- (void)reloadTable;
- (void)didOpenMenu;
- (void)willCloseMenu;

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath;

@end
