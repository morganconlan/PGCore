//
//  PGHUDManager.m
//  pgcore
//
//  Created by Morgan Conlan on 07/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGHUDManager.h"

@implementation PGHUDManager

- (instancetype)init {
    
    if ((self = [super init])) {
        
        [[MMProgressHUD sharedHUD] setPresentationStyle:MMProgressHUDPresentationStyleFade];
        
    }
    
    return self;
}

- (instancetype)initDefault {
    
    if ((self = [super init])) {
        
        [[MMProgressHUD sharedHUD] setPresentationStyle:MMProgressHUDPresentationStyleFade];
        
    }
    
    return self;
}

- (void)showHUDwithTitle:(NSString *)titleKey
                 message:(NSString *)messageKey {
    
    [MMProgressHUD showWithTitle:[PGApp.app string:titleKey]
                          status:[PGApp.app string:messageKey]
             confirmationMessage:[PGApp.app string:kPG_HUD_ConfirmCancel]
                     cancelBlock:^
     {
         
         DDLogWarn(@"Cancelled");
         
     }];
    
}

- (void)showHUDwithTitle:(NSString *)titleKey
                 message:(NSString *)messageKey
     confirmationMessage:(NSString *)confimMessageKey
             cancelBlock:(void (^)(void))block {
    
    [MMProgressHUD showWithTitle:[PGApp.app string:titleKey]
                          status:[PGApp.app string:messageKey]
             confirmationMessage:[PGApp.app string:kPG_HUD_ConfirmCancel]
                     cancelBlock:block];
    
}

- (void)dismiss {
    [MMProgressHUD dismiss];
}

- (void)dismissHudWithSuccess {

    [MMProgressHUD dismissWithSuccess:@""
                                title:@""
                           afterDelay:0.5];

}

- (void)dismissHudWithError:(NSString *)errorMessageKey {
    
    [MMProgressHUD dismissWithError:[PGApp.app string:errorMessageKey]
                         afterDelay:2.0f];
}

@end
