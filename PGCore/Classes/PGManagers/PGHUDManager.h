//
//  PGHUDManager.h
//  pgcore
//
//  Created by Morgan Conlan on 07/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMProgressHUD.h"

@interface PGHUDManager : NSObject

- (instancetype)initDefault;
- (void)showHUDwithTitle:(NSString *)titleKey message:(NSString *)messageKey;
- (void)showHUDwithTitle:(NSString *)titleKey
                 message:(NSString *)messageKey
     confirmationMessage:(NSString *)confimMessageKey
             cancelBlock:(void (^)(void))block;
- (void)dismiss;
- (void)dismissHudWithSuccess;
- (void)dismissHudWithError:(NSString *)errorMessageKey;

@end
