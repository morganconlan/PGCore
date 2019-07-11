//
//  PGVC.m
//  pgcore
//
//  Created by Morgan Conlan on 04/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGApp.h"
#import "PGVC.h"
#import <MediaPlayer/MediaPlayer.h>
#import <PGViewDeck/PGViewDeck.h>
#import "SCNetworkReachability.h"
#import "UIERealTimeBlurView.h"

@interface PGVC () {
    UIView *top, *middle, *bottom;
}

@property (nonatomic, assign) BOOL isBlurring;
@property (nonatomic, strong) UIERealTimeBlurView *blurView;
@property (nonatomic, strong) UIView *blurTintView;

@end

@implementation PGVC

- (id)init {

	if ((self = [super init])) {

        DEBUG_CYCLE(@"init");

		currentLayout = PGVCLayoutNotSet;
		currentDevice = [self setupCurrentDevice];

	}

	return self;

}

- (id)initWithSidemenuButton {

	if ((self = [self init])) {

        DEBUG_CYCLE(@"initWithSideMenu");

		_isDisplayingSidemenu = !PGApp.isiPad;
	}

	return self;
}

- (void)enableSideMenu {

	_isDisplayingSidemenu = !PGApp.isiPad;
}


#pragma mark - View lifecycle

- (void)loadView {

    if (_isUsingDefaultFrames) {
        DEBUG_CYCLE(@"default load view");
        [super loadView];
        return;
    }

    DEBUG_CYCLE(@"load view");

	// set up the base view
	UIView *view = [[UIView alloc] initWithFrame:[self applicationBounds]];
	view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

	view.backgroundColor = [PGApp.app.background backgroundColourForVC:self];
	self.view = view;

	if (PGApp.isiPad) self.navigationItem.hidesBackButton = YES;
}

- (void)viewDidLoad {
	[super viewDidLoad];

    DEBUG_CYCLE(@"viewDidLoad");

	self.title = [self performSelector:@selector(navTitle)];

	[self setupLeftNavButton];
	[self updateBackground];
	[self setupContentView];
	[self prepareForLayout];

}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

    self.navigationController.navigationBar.barStyle = [self preferredStatusBarStyle];

    DEBUG_CYCLE(@"viewWillAppear");

	[self prepareForLayout];
	self.contentView.alpha = 1.0f;
    
    SEL willAppearSelector = NSSelectorFromString(@"backgroundWillAppear");
    if ([self.backgroundView respondsToSelector:willAppearSelector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [self.backgroundView performSelector:willAppearSelector];
#pragma clang diagnostic pop
    }

    [self debugContentViewWithColour:self.contentViewDebugingColor];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];

    DEBUG_CYCLE(@"viewWillDisappear");

}

#pragma mark - Setup

- (PGDevice)setupCurrentDevice {

	return ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
	       ? PGDeviceIPhoneIOS7
	       : PGDeviceIPhoneIOS6;

}

- (void)setupContentView {
	DEBUG_LAYOUTING(@"setupContent");
	self.contentView = [[UIView alloc] init];
	[self.contentView setBackgroundColor:[UIColor clearColor]];
	[self.view addSubview:self.contentView];

}

- (void)layoutContentView {
	DEBUG_LAYOUTING(@"layoutContentView");
	[self.contentView setFrame:[self foregroundFrame]];
	[self.view setFrame:[self applicationBounds]];
	[_backgroundView setFrame:[self backgroundFrame]];
}

- (void)debugContentViewWithColour:(UIColor *)debugColour {
#if DEBUG_CONTENT_VIEW > 0
	CGRect debugFrame;
	CGFloat midHeight;
#if DEBUG_CONTENT_VIEW > 1
	debugFrame = background.frame;
	midHeight = ((debugFrame.size.height + debugFrame.origin.y) / 2);
	DDLogVerbose(@"debugging background");
#else
	debugFrame = self.contentView.frame;
	midHeight = (debugFrame.size.height / 2);
	DDLogVerbose(@"debugging contentView");
#endif

	DEBUG_VIEW_FRAME(self, @"self.view", self.view);
	DEBUG_VIEW_FRAME(self, @"self.contentView", self.contentView);
	DEBUG_VIEW_FRAME(self, @"background frame", self.backgroundView);

	if (!top) {

		top = [[UIView alloc] init];
		[top setBackgroundColor:debugColour];
		[self.view addSubview:top];

	}

	[top setFrame:CGRectMake(10,
	                         debugFrame.origin.y,
	                         debugFrame.size.width - 20,
	                         10)];

	if (!middle) {

		middle = [[UIView alloc] init];
		[middle setBackgroundColor:debugColour];
		[self.view addSubview:middle];

	}

	[middle setFrame:CGRectMake(10,
	                            midHeight - 5,
	                            debugFrame.size.width - 20,
	                            10)];


	if (!bottom) {

		bottom = [[UIView alloc] init];
		[bottom setBackgroundColor:debugColour];
		[self.view addSubview:bottom];

	}

	[bottom setFrame:CGRectMake(10,
	                            debugFrame.origin.y
	                            + debugFrame.size.height
	                            - 10,
	                            debugFrame.size.width - 20,
	                            10)];

	DEBUG_VIEW_FRAME(self, @"top", top);
	DEBUG_VIEW_FRAME(self, @"middle", middle);
	DEBUG_VIEW_FRAME(self, @"bottom", bottom);

#endif
}

- (UIColor *)contentViewDebugingColor {
    return UIColor.redColor;
}

#pragma mark - Navbar item

- (void)setupLeftNavButton {

	if (PGApp.isiPad) {

        UIBarButtonItem *leftNav = (self.drillDownController.viewControllers.count > 2) ? [self backBarButton] : nil ;
		[self.drillDownController.leftViewController.navigationItem setLeftBarButtonItem:leftNav animated:YES];

	} else {

		if (_isDisplayingSidemenu) [self setMenuBarButton];
		else [self replaceBackButton];

	}

}

- (void)setMenuBarButton {
    
    if (PGApp.app.menuManager == nil) return;
    
	UIImage *menuButtonImage = [PGApp.app image:kPG_Image_Menu];
	UIButton *menuButton = [UIButton buttonWithType:UIButtonTypeCustom];

	[menuButton setImage:menuButtonImage
	 forState:UIControlStateNormal];
	menuButton.titleLabel.text = @"menu";

	menuButton.frame = CGRectMake(0, 0, 32, menuButtonImage.size.height);

	[menuButton addTarget:self
	 action:@selector(onShowMenuClick:)
	 forControlEvents:UIControlEventTouchUpInside];

	UIBarButtonItem *menuBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:menuButton];
	[self.navigationItem setLeftBarButtonItem:menuBarButtonItem animated:YES];

}

- (void)replaceBackButton {

    self.navigationItem.hidesBackButton = YES;
    [self.navigationItem setLeftBarButtonItem:[self backBarButton]
                                     animated:YES];

}

- (UIImage *)backButtonImage {

    return [PGApp.app image:kPG_Image_Back];

}

- (UIBarButtonItem *)backBarButton {

	UIImage *backButtonImage = [self backButtonImage];
	UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];

	[backButton setImage:backButtonImage
	 forState:UIControlStateNormal];
	backButton.titleLabel.text = @"<";

	backButton.frame = CGRectMake(0, 0, 32, backButtonImage.size.height);

    [backButton addTarget:(PGApp.isiPad) ? PGApp.app : self
	 action:@selector(popViewController)
	 forControlEvents:UIControlEventTouchUpInside];

	return [[UIBarButtonItem alloc] initWithCustomView:backButton];

}

- (void)onShowMenuClick:(id)sender {
    
	[PGApp.app.menu didOpenMenu];
	[self.viewDeckController openSide:PGViewDeckSideLeft animated:YES];

}

- (UIStatusBarStyle)preferredStatusBarStyle {

    return (PGApp.app.configs.isDarkNav)
            ? UIStatusBarStyleDefault
            : UIStatusBarStyleLightContent;

}

#pragma mark - Frames

- (CGRect)applicationBounds {

	CGRect bounds = [[UIScreen mainScreen] bounds];

    // since iOS 8 bounds is orientation dependent
    if ((NSFoundationVersionNumber <= NSFoundationVersionNumber_iOS_7_1)
        && UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])) {

        // swap for landscape
		bounds.size = CGSizeMake(bounds.size.height, bounds.size.width);

    }

	return bounds;

}

- (CGRect)foregroundFrame {

    if (_isUsingDefaultFrames) return self.view.frame;

	CGRect frame = [self applicationBounds];

	CGFloat height = [self heightForStatusBar] + [self heightForNavigationBar];
	frame.size.height -= height;

	return frame;

}

- (CGRect)backgroundFrame {

	CGRect backgroundFrame = [self foregroundFrame];
	return backgroundFrame;

}

- (CGFloat)heightForStatusBar {

    if (self.navigationController.navigationBarHidden
        || PGApp.isiPad) return 0.0f;

    CGRect frame = [[UIApplication sharedApplication] statusBarFrame];

    return (PGApp.isiPad
            && !self.isPortrait)
            ? frame.size.width
            : frame.size.height;

}

- (CGFloat)heightForNavigationBar {

    CGFloat height;

    if (PGApp.isiPad) {

        height = ([self isLeftViewController])
                    ? self.drillDownController.leftNavigationBar.frame.size.height
                    : self.drillDownController.rightNavigationBar.frame.size.height;

    } else {

        height = self.navigationController.navigationBar.frame.size.height;

    }

    return height;

}

- (CGFloat)width {
	return self.contentView.frame.size.width;
}

#pragma mark - Layouts

- (BOOL)shouldAutorotate {
	return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {

	return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {

	return UIInterfaceOrientationPortrait;
}

- (BOOL)isPortrait {

	UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];

	return (orientation == UIInterfaceOrientationPortrait
	        || orientation == UIInterfaceOrientationPortraitUpsideDown);

}

- (PGVCLayout)orientation {

	return ([self isPortrait])
	       ? PGVCLayoutPortrait
	       : PGVCLayoutLandscape;

}

- (void)prepareForLayout {

	if (currentLayout == [self orientation]) return;
	DEBUG_LAYOUTING(@"prepareForLayout");
	[self layoutContentView];


	if (!PGApp.isiPad) {

#warning ViewDeckSize not set
//        [self.viewDeckController setLeftSize:(self.contentView.bounds.size.width
//                                              - PGApp.app.configs.viewDeckWidth)];

        [self.viewDeckController closeSide:YES];

	}

	([self isPortrait])
        ? [self layoutForPortrait]
        : [self layoutForLandscape];

}

- (void)prepareForResize {
	DEBUG_LAYOUTING(@"prepareForResize");
	[self layoutContentView];

	if (currentLayout == PGVCLayoutPortrait) [self layoutForPortrait];
	else [self layoutForLandscape];
    
    [self updateBackground];
}

- (void)layoutForPortrait {
	DEBUG_LAYOUTING(@"layoutForPortrait");
	//if (!isCustomBackground) [self setBackground:[self backgroundViewForPortrait]];
	currentLayout = PGVCLayoutPortrait;
    
}

- (void)layoutForLandscape {
	DEBUG_LAYOUTING(@"layoutForLandscape");
	//if (!isCustomBackground) [self setBackground:[self backgroundViewForLandscape]];
	currentLayout = PGVCLayoutLandscape;
    
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
        duration:(NSTimeInterval)duration {
	DEBUG_LAYOUTING(@"willRotateToInterfaceOrientation");
	[self fadeContentOut];

}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {

	DEBUG_LAYOUTING(@"didRotateFromInterfaceOrientation");
	[super didRotateFromInterfaceOrientation:fromInterfaceOrientation];

	[self prepareForLayout];
	[self fadeContentIn];

}

#pragma mark - Content fade

- (void)fadeContentIn {

	[UIView animateWithDuration:0.4f
                     animations:^
	 {
	         [self.view setBackgroundColor:[PGApp.app.background backgroundColourForVC:self]];
	         [self.contentView setAlpha:1.0f];
         
	 }
                     completion:^(BOOL fin)
	 {
	         [UIView animateWithDuration:0.4f
                              animations:^
              {
	              [_backgroundView setAlpha:self.backgroundAlpha];
              }];
	 }];

}

- (void)fadeContentOut {
	
    [UIView animateWithDuration:0.2f
                     animations:^
	 {
	         [_backgroundView setAlpha:0.0f];
	         [self.contentView setAlpha:PGApp.app.configs.pgvcFadeDuration];
	         [self.view setBackgroundColor:[PGApp.app colour:kPG_Colour_PGVC_Background_Fade]];
	 }];
}

#pragma mark - Background

- (void)updateBackground {
	DEBUG_LAYOUTING(@"setBackground");

	[_backgroundView removeFromSuperview];

    _backgroundView = [PGApp.app.background backgroundForPGVC:self];
    [_backgroundView setAlpha:self.backgroundAlpha];
	
    [self.view addSubview:_backgroundView];
	[self.view sendSubviewToBack:_backgroundView];

}

- (CGFloat)backgroundAlpha {

	return PGApp.app.configs.pgvcBackgroundAlpha;
}

- (CGFloat)contentHeight {

	return self.contentView.bounds.size.height;

}

#pragma mark - Push / Pop

- (void)pushPGVC:(UIViewController<PGVCDelegate> *)pgvc {

	if ([self respondsToSelector:@selector(setSearchBarInactive)]) {
		[self performSelector:@selector(setSearchBarInactive)];
	}

    if (PGApp.isiPad) {

        [self fadeContentOut];

        [self.drillDownController pushViewController:pgvc
                                            animated:YES
                                          completion:^
         {

             [(PGVC *)self.drillDownController.leftViewController wasChangedToLeftViewController];
             [(PGVC *)self.drillDownController.rightViewController wasChangedToRightViewController];

         }];

    } else {

        [self.navigationController pushViewController:pgvc
                                             animated:PGApp.app.configs.animatePGVCPush];
        
    }

}

- (void)pushPGVC:(UIViewController<PGVCDelegate> *)pgvc
      afterBlock:(void (^)(void))block
        afterDelay:(NSTimeInterval)delay {

}

- (void)pushPGVC:(UIViewController<PGVCDelegate> *)pgvc
      afterBlock:(void (^)(void))block
      afterDelay:(NSTimeInterval)delay
  replacingRight:(BOOL)isReplacingRight {

    block();
    SEL selector = (isReplacingRight)
                    ? NSSelectorFromString(@"pushPGVCReplacingRight:")
                    : NSSelectorFromString(@"pushPGVC:");

    [self performSelector:selector
               withObject:pgvc
               afterDelay:delay];

}

// Optionally replace push the new view controller to the right side without changing the left one
- (void)pushPGVC:(UIViewController<PGVCDelegate> *)pgvc
  replacingRight:(BOOL)isReplacingRight {

	if (PGApp.isiPad
	    && isReplacingRight) {

        [self.drillDownController replaceRightViewController:pgvc
                                                    animated:YES
                                                  completion:nil];

	} else {

		[self pushPGVC:pgvc];

	}

}

- (void)pushPGVCReplacingRight:(UIViewController<PGVCDelegate> *)pgvc {

    [self pushPGVC:pgvc
    replacingRight:YES];
    
}

- (void)willPop {
    DEBUG_CYCLE(@"willPop");
}

- (void)popViewController {
	[self willPop];
    DEBUG_CYCLE(@"popViewController");

    if (PGApp.isiPad) {

        __block PGVC *old_left = (PGVC *)self.drillDownController.leftViewController;

        [old_left fadeContentOut];
        old_left.navigationItem.hidesBackButton = YES;

        [self.drillDownController popViewControllerAnimated:YES
                                                 completion:^
         {

             [old_left wasChangedToRightViewController];
             old_left.navigationItem.leftBarButtonItem = nil;
             [old_left fadeContentIn];

         }];

    } else {

        [UIView animateWithDuration:0.25
                         animations:^
         {
             self.contentView.alpha = 0.0f;
         }
                         completion:^(BOOL fin)
         {
             [self.navigationController popViewControllerAnimated:NO];
             
         }];

    }

}

- (BOOL)isLeftViewController {

	if (!PGApp.isiPad) return NO;
    return (self.drillDownController.leftViewController == self);

}

- (PGVC *)leftViewController {

	if (!PGApp.isiPad) return nil;
    return (PGVC *)self.drillDownController.leftViewController;

}

- (PGVC *)rightViewController {

	if (!PGApp.isiPad) return nil;
    return (PGVC *)self.drillDownController.rightViewController;

}

- (void)wasChangedToLeftViewController {
    DEBUG_CYCLE(@"wasChangedToLeftViewController");
    [self replaceBackButton];

    [self.navigationItem setRightBarButtonItem:nil
                                      animated:NO];
    [self prepareForResize];
    [self fadeContentIn];

}

- (void)wasChangedToRightViewController {
    DEBUG_CYCLE(@"wasChangedToRightViewController");
    [self prepareForResize];

}

#pragma mark - Abstract methods

+ (NSString *)menuTitle {

	return [PGApp.app menuTitleForForViewControllerNamed:NSStringFromClass([self class])];

}

+ (NSString *)menuImageTitle {

	return [PGApp.app menuImageTitleForForViewControllerNamed:NSStringFromClass([self class])];
}

- (NSString *)navTitle {
    if (PGApp.app.configs.isNavTitleTextDisabled) return @"";
	return [PGApp.app navigationBarTitleForViewControllerNamed:NSStringFromClass([self class])];

}

- (void)performSelectorOnDelegate:(SEL)sel
        withObject:(id)obj {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
	[self performSelector:sel
	 withObject:obj];
#pragma clang diagnostic pop

}

- (CGRect)bounds {

	return self.contentView.bounds;

}

#pragma mark - Communication methods

- (void)didPressEmail:(NSArray *)recipients {
    
    if([recipients isKindOfClass:[NSString class]] == YES) {
        DDLogWarn(@"expecting an array but got a string instead");
        NSString *recipient = (NSString *)recipients;
        recipients = @[recipient];
    }
    
	MFMailComposeViewController *picker=[[MFMailComposeViewController alloc] init];
	[picker.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
	picker.mailComposeDelegate = self;
	[picker setToRecipients:recipients];
	[picker setSubject:@""];

	[picker setMessageBody:@""
	 isHTML:YES];

    if ([MFMailComposeViewController canSendMail] && picker) {

        [self presentViewController:picker
         animated:YES
         completion:nil];

    } else {

        DDLogWarn(@"device can't send email");

    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
        didFinishWithResult:(MFMailComposeResult)result
        error:(NSError*)error {

	switch (result) {

	case MFMailComposeResultCancelled : {
			UIAlertView *ErrorAlert = [[UIAlertView alloc]
			                           initWithTitle:[PGApp.app string:kPG_ALERT_Cancel]
			                           message:[PGApp.app string:kPG_ALERT_Email_Cancelled]
			                           delegate:nil
			                           cancelButtonTitle:@"OK"
			                           otherButtonTitles:nil];
			[ErrorAlert show];
	}
		break;

	case MFMailComposeResultSaved : {
			UIAlertView *ErrorAlert = [[UIAlertView alloc]
			                           initWithTitle:[PGApp.app string:kPG_ALERT_Saved]
			                           message:[PGApp.app string:kPG_ALERT_Email_Saved]
			                           delegate:nil
			                           cancelButtonTitle:@"OK"
			                           otherButtonTitles:nil, nil];
			[ErrorAlert show];
	}
		break;

	case MFMailComposeResultSent: {
		UIAlertView *ErrorAlert = [[UIAlertView alloc]
		                           initWithTitle:[PGApp.app string:kPG_ALERT_Email_Sent]
		                           message:[PGApp.app string:kPG_ALERT_Thank_You]
		                           delegate:nil
		                           cancelButtonTitle:@"OK"
		                           otherButtonTitles:nil, nil];
		[ErrorAlert show];
	}
	break;

	case MFMailComposeResultFailed: {
		UIAlertView *ErrorAlert = [[UIAlertView alloc]
		                           initWithTitle:[PGApp.app string:kPG_ALERT_Error]
		                           message:[PGApp.app string:kPG_ALERT_Email_Send_Fail]
		                           delegate:nil
		                           cancelButtonTitle:@"OK"
		                           otherButtonTitles:nil, nil];
		[ErrorAlert show];
	}
	break;

	default: {
		UIAlertView *ErrorAlert = [[UIAlertView alloc]
		                           initWithTitle:[PGApp.app string:kPG_ALERT_Error]
		                           message:[PGApp.app string:kPG_ALERT_Email_Send_Fail]
		                           delegate:nil
		                           cancelButtonTitle:@"OK"
		                           otherButtonTitles:nil, nil];
		[ErrorAlert show];
	}
	break;
	}

	[self becomeFirstResponder];
	[self dismissViewControllerAnimated:YES completion:nil];

}

- (void)didPressTel:(NSString *)tel {

	UIDevice *device = [UIDevice currentDevice];

	if ([[device model] isEqualToString:@"iPhone"] ) {

		PGAlertView *alertView = [[PGAlertView alloc] initWithTitle:nil
                                                         andMessage:[NSString stringWithFormat: @"%@ %@",
                                                                     [PGApp.app string:kPG_ALERT_CallNumber],
                                                                     tel]];

		[alertView addButtonWithTitle:[PGApp.app string:kPG_ALERT_Cancel]
                                 type:PGAlertViewButtonTypeCancel
                              handler:nil];

		[alertView addButtonWithTitle:@"OK"
                                 type:PGAlertViewButtonTypeDefault
                              handler:^(PGAlertView *alertView)
		 {

		         NSString *phoneNumber = tel;
		         NSString *cleanedString =
		                 [[phoneNumber componentsSeparatedByCharactersInSet:
		                   [[NSCharacterSet characterSetWithCharactersInString:@"0123456789-+()"] invertedSet]] componentsJoinedByString:@""];
		         NSString *escapedPhoneNumber = [cleanedString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		         NSURL *telURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", escapedPhoneNumber]];

		         [[UIApplication sharedApplication] openURL:telURL];

		 }];
        
        [alertView show];

	} else {

		PGAlertView *alertView = [[PGAlertView alloc] initWithTitle:[PGApp.app string:kPG_ALERT_Call]
		                          andMessage:[PGApp.app string:kPG_ALERT_DeviceNotSupported]];

		[alertView addButtonWithTitle:@"OK"
                                 type:PGAlertViewButtonTypeDefault
                              handler:nil];

		[alertView show];

	}

}


- (void)didPressWeb:(NSString *)url {

	PGAlertView *alertView = [[PGAlertView alloc] initWithTitle:[PGApp.app string:kPG_ALERT_LeaveApp]
                                                     andMessage:url];

	[alertView addButtonWithTitle:[PGApp.app string:kPG_ALERT_Cancel]
                             type:PGAlertViewButtonTypeCancel
                          handler:nil];

	[alertView addButtonWithTitle:@"OK"
                             type:PGAlertViewButtonTypeDefault
                          handler:^(PGAlertView *alertView) { [self openWeb:url]; }];

	[alertView show];

}

/**
 *  Try open the given url and display an alert if there was an error
 *
 *  @param url the url to open
 */
- (void)openWeb:(NSString *)url {
    
    if (![url hasPrefix:@"http://"]
        && ![url hasPrefix:@"https://"]) url = [@"http://" stringByAppendingString:url];

	if (![[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]]) {

		PGAlertView *alertView = [[PGAlertView alloc] initWithTitle:[PGApp.app string:kPG_ALERT_Error]
		                          andMessage:[PGApp.app string:kPG_ALERT_Error_Server]];

		[alertView addButtonWithTitle:@"OK"
		 type:PGAlertViewButtonTypeDefault
		 handler:nil];

		[alertView show];
	}

}

#pragma mark - Refresh

- (void)setupRefresh {

	UIImage *refreshButtonImage = [PGApp.app image:kPG_Image_Refresh];
	UIButton *refreshButton = [UIButton buttonWithType:UIButtonTypeCustom];

	[refreshButton setImage:refreshButtonImage
	 forState:UIControlStateNormal];
	refreshButton.titleLabel.text = @"<";

	refreshButton.frame = CGRectMake(0, 0, 32, refreshButtonImage.size.height);

	[refreshButton addTarget:self
	 action:@selector(didPressRefresh)
	 forControlEvents:UIControlEventTouchUpInside];

	[self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:refreshButton]
	 animated:YES];

}

- (void)setupRightNavButtonWithImage:(UIImage *)image
        selector:(NSString *)selector {

	UIImage *navButtonImage = image;
	UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];

	[navButton setImage:navButtonImage
	 forState:UIControlStateNormal];
	navButton.titleLabel.text = @"<";

	navButton.frame = CGRectMake(0, 0, 32, image.size.height);

    [self setupRightNavButton:navButton
                     selector:selector];

}

- (void)setupRightNavButton:(UIButton *)navButton
                   selector:(NSString *)selector {

    SEL sel = NSSelectorFromString(selector);

    if (![self respondsToSelector:sel]) {

        DDLogError(@"%@", [NSString stringWithFormat:@"%@ doesn't respond to selector: %@",
                           self.description,
                           selector]);
        return;

    }

    [navButton addTarget:self
                  action:sel
        forControlEvents:UIControlEventTouchUpInside];

    [self.navigationItem setRightBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:navButton]
                                      animated:YES];
    
}

- (void)setupRightNavButtons:(NSArray *)navButtons
                   selectors:(NSArray *)selectors {

    if (navButtons.count != selectors.count
        || navButtons.count == 0) {

        DDLogError(@"number of buttons (%ld) does not match number of selectors (%ld) or none supplied.",
                   (long)navButtons.count,
                   (long)selectors.count);
        return;

    }

    NSMutableArray *buttons = [NSMutableArray array];

    for (NSInteger i=0; i<selectors.count; i++) {

        SEL sel = NSSelectorFromString(selectors[i]);

        if (![self respondsToSelector:sel]) {

            DDLogError(@"%@", [NSString stringWithFormat:@"%@ doesn't respond to selector: %@",
                               self.description,
                               selectors[i]]);
            continue;

        }

        UIButton *navButton = navButtons[i];

        [navButton addTarget:self
                      action:sel
            forControlEvents:UIControlEventTouchUpInside];

        [buttons addObject:[[UIBarButtonItem alloc] initWithCustomView:navButton]];

    }

    [self.navigationItem setRightBarButtonItems:buttons animated:YES];

}

- (void)setupRightNavButtonImages:(NSArray *)navButtons
                        selectors:(NSArray *)selectors {

    if (navButtons.count != selectors.count
        || navButtons.count == 0) {

        DDLogError(@"number of buttons does not match number of selectors");
        return;

    }

    NSMutableArray *buttons = [NSMutableArray array];


    for (UIImage *image in navButtons) {

        UIImage *navButtonImage = image;
        UIButton *navButton = [UIButton buttonWithType:UIButtonTypeCustom];

        [navButton setImage:navButtonImage
                   forState:UIControlStateNormal];
        navButton.titleLabel.text = @"<";

        navButton.frame = CGRectMake(0, 0, 32, image.size.height);
        [buttons addObject:navButton];

    }

    [self setupRightNavButtons:buttons
                     selectors:selectors];

}

- (void)didPressRefresh {

	DDLogWarn(@"should be implemented by subclass");

}

#pragma mark - Video

- (void)playVideo:(id<PGYoutubeDelegate>)video {

    DDLogError(@"Play video needs to be re-implemented");

}

- (void)presentMoviePlayerWithURL:(NSURL *)videoURL {

	MPMoviePlayerViewController *mp = [[MPMoviePlayerViewController alloc] initWithContentURL:videoURL];
	[self presentMoviePlayerViewControllerAnimated:mp];

}

#pragma mark - Blurring

- (void)addBlur {
    
    if (!PGApp.app.configs.isBlurring) return;

    _blurView = [[UIERealTimeBlurView alloc] initWithFrame:self.contentView.bounds];
    _blurView.renderStatic = YES;
    _blurView.alpha = 0.0f;
    [self.contentView addSubview:_blurView];
    
    _blurTintView = [[UIView alloc] initWithFrame:self.contentView.bounds];
    _blurTintView.backgroundColor = [PGApp.app hex:0x313131];
    _blurTintView.alpha = 0.0f;
    [self.contentView addSubview:_blurTintView];
    
    [UIView animateWithDuration:1.0f
                          delay:0.1f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^
    {
    
        _blurView.alpha = 0.5f;
        _blurTintView.alpha = 0.75f;
        
    }
                     completion:nil];
    
    _isBlurring = YES;
}

- (void)removeBlur {
    
    if (!PGApp.app.configs.isBlurring) return;
    
    [UIView animateWithDuration:0.5f
                     animations:^
    {
        _blurView.alpha = 0.0f;
        _blurTintView.alpha = 0.0f;
    }
                     completion:^(BOOL finished)
    {
        
        [_blurView removeFromSuperview];
        [_blurTintView removeFromSuperview];
        _blurView = nil;
        _blurTintView = nil;
        
    }];

    _isBlurring = NO;
}

@end
