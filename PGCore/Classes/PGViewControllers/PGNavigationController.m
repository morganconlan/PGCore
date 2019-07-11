//
//  PGNavigationController.m
//  pgcore
//
//  Created by Morgan Conlan on 05/04/2013.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGNavigationController.h"

@interface PGNavigationController ()

@end

@implementation PGNavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController {
    
    if ((self = [super initWithRootViewController:rootViewController])) {
        
        [self customiseAppearance];
        
    }
    
    return self;
    
}

//ViewWillAppear is sometimes not called and this causes issues if the VC
//needs to re-layout (e.g. orientation changes have occured in the mean time)
- (UIViewController *)popViewControllerAnimated:(BOOL)animated {
    
    UIViewController *poppedVC = [super popViewControllerAnimated:animated];
    
    PGVC *topVC = (PGVC *)[self.viewControllers lastObject];
    
    // Make sure it's a PGVC
    if ([topVC respondsToSelector:@selector(prepareForLayout)])
        [topVC prepareForLayout];
    
    return poppedVC;
    
}

- (void)customiseAppearance {

    [self.navigationBar setTitleTextAttributes:
     @{
       UITextAttributeTextColor:[PGApp.app colour:kPG_Colour_Nav_Title],
       UITextAttributeTextShadowColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0],
       UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0, -1)],
       UITextAttributeFont:[PGApp.app font:kPG_Font_Nav]
       }];



    self.navigationBar.translucent = NO;//PGApp.app.configs.isNavTranslucent;

    if (PGApp.app.configs.isNavTranslucent) {

        [self.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = [UIImage new];
        [self.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
        self.navigationBar.shadowImage = [[UIImage alloc] init];
        self.navigationBar.backgroundColor = [UIColor clearColor];

    } else {

        self.navigationBar.barTintColor = (PGApp.app.configs.isDebugging)
            ? [UIColor redColor]
            : [PGApp.app colour:kPG_Colour_Nav_Tint];

    }

    [self.navigationBar setShadowImage:[UIImage new]];

    
}

- (BOOL)shouldAutorotate {
    
    return [[self.viewControllers lastObject] shouldAutorotate];
    
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
    
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
    
}

@end
