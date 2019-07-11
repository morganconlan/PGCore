//
//  PangrMenuController.m
//  pgcore
//
//  Created by Morgan Conlan on 05/04/2013.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGMenuController.h"
#import <PGViewDeck/PGViewDeck.h>
#import "PGNavigationController.h"
#import "PGMenuCell.h"

@interface PGMenuController () {
    
    NSMutableArray *itemIndex;
}

@end

@implementation PGMenuController

#pragma mark - View Lifecycle

//- (instancetype)init {
//
//    if ((self = [super init])) {
//
//        self.isAnimatingMenu = NO;
//        self.preferredContentSize = CGSizeMake(260.0, 480.0);
//
//    }
//
//    return self;
//}
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//
//    [self initItems];
//
//    [self setupTable];
//    self.isFadingTableOnAppear = NO;
//
//    [self selectFirst];
//
//}
//
//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    
//    PGMenuCell *selected = (PGMenuCell *)[table cellForRowAtIndexPath:self.selectedIndex];
//    [selected selectCell:YES];
//    
//}
//
//- (CGRect)applicationBounds {
//
//    CGRect bounds = [super applicationBounds];
//
//    if (!PGApp.isiPad) bounds.size.height += 20.0f;
//
//    return bounds;
//
//}
//
//
//- (void)setupTable {
//    
//    CGRect frame = CGRectMake(0, 0, (PGApp.isiPad) ? 320 : 220, self.contentHeight);
//
//    table = [[UITableView alloc] initWithFrame:frame
//                                         style:UITableViewStylePlain];
//    
//    table.dataSource = self;
//    table.delegate = self;
//
//    UIVisualEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *backgroundView = [[UIVisualEffectView alloc] initWithEffect:blur];
//    table.backgroundView = backgroundView;
//    table.backgroundColor = UIColor.clearColor;
//    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
//    
//    [self.contentView addSubview:table];
//    self.contentView.backgroundColor = UIColor.clearColor;
//    self.view.backgroundColor = UIColor.clearColor;
//
////    if (PGApp.app.menuManager.backgroundColour)
////        self.contentView.backgroundColor = PGApp.app.menuManager.backgroundColour;
//    
//}
//
//- (void)selectFirst {
//    
//    self.selectedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
//    
//}
//
//- (NSString *)navTitle {
//    return nil;
//}
//
////- (CGSize)preferredContentSize {
////    return table.frame.size;
////}
//
//#pragma mark - UITableView Datasource
//
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    
//    return 1;
//    
//}
//
//- (NSInteger)tableView:(UITableView *)tableView
// numberOfRowsInSection:(NSInteger)section {
//    
//    return [itemIndex count];
//    
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    PGMenuCell *cell = (PGMenuCell *)[super tableView:tableView cellForRowAtIndexPath:indexPath];
//
//    [cell selectCell:(self.selectedIndex.row == indexPath.row)];
//    
//    return cell;
//}
//
//- (UIView *)tableView:(UITableView *)tableView
//viewForHeaderInSection:(NSInteger)section {
//    return [[UIView alloc] initWithFrame:CGRectZero];
//}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return PGApp.app.configs.menuHeaderPadding;
//}
//
//- (PGCellInfoWrapper *)infoWrapperForCellAtIndexPath:(NSIndexPath *)indexPath {
//#pragma clang diagnostic push
//#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    
//    NSMutableDictionary *info = [NSMutableDictionary dictionary];
//    
//    //each item is a class. each class responds to menuTitle
//    info[@"title"] = [itemIndex[indexPath.row] performSelector:@selector(menuTitle)];
//    if (PGApp.app.configs.isMenuIconsEnabled)
//        info[@"img"] = [PGApp.app menuImageTitleForForViewControllerNamed:itemIndex[indexPath.row]];
//    
//    return [[PGCellInfoWrapper alloc] initWithId:kPG_Cell_Menu
//                                            info:info];
//#pragma clang diagnostic pop
//
//}
//
//#pragma mark - UITableView Delegate methods
//
//- (NSIndexPath *)tableView:(UITableView *)tableView
//  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    [self selectRowAtIndexPath:indexPath];
//    return nil;
//    
//}
//
//- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (self.selectedIndex.section == indexPath.section
//        && self.selectedIndex.row == indexPath.row) {
//        
//        // Remove the blur
//        PGNavigationController *navController = (PGNavigationController *)self.viewDeckController.centerViewController;
//        PGVC *vc = (PGVC *)[navController.viewControllers lastObject];
//        
//        if ([vc respondsToSelector:@selector(removeBlur)]) {
//            
//            [vc performSelector:@selector(removeBlur)];
//            
//        }
//        
//        [self.viewDeckController toggleLeftSideAnimated:self.isAnimatingMenu];
//
//        if (PGApp.isiPad
//            && self.drillDownController.rightViewController != nil)
//
//            return;
//        
//    }
//    
//    PGMenuCell *oldCell = (PGMenuCell *)[table cellForRowAtIndexPath:self.selectedIndex];
//    [oldCell selectCell:NO];
//    
//    PGMenuCell *cell = (PGMenuCell *)[table cellForRowAtIndexPath:indexPath];
//    [cell selectCell:YES];
//    
//    self.selectedIndex = indexPath;
//    
//    
//    [self performSelector:@selector(selectSelected)
//               withObject:nil
//               afterDelay:0.1f];
//}
//
//- (void)selectSelected {
//    
//    [self tableView:table didSelectRowAtIndexPath:self.selectedIndex];
//    
//}
//
//- (void)tableView:(UITableView *)tableView
//didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    PGVC *controller = [[itemIndex[indexPath.row] alloc] initWithSidemenuButton];
//    
//    if (PGApp.isiPad) {
//
//        controller.navigationItem.hidesBackButton = YES;
//        [self.drillDownController replaceRightViewController:controller
//                                                    animated:YES
//                                                  completion:^
//        {
//            [(PGVC *)self.drillDownController.rightViewController wasChangedToRightViewController];
//
//        }];
//
//    } else {
//
//        [self.viewDeckController.navigationController popToRootViewControllerAnimated:YES];
//        
//        PGNavigationController *nc = [[PGNavigationController alloc] initWithRootViewController:controller];
//        [nc.navigationBar setTranslucent:NO];
//        [self.viewDeckController setCenterViewController:nc];
//        
//        [self willCloseMenu];
//        
//        if (self.viewDeckController.openSide != PGViewDeckSideNone)
//            [self.viewDeckController toggleLeftSideAnimated:self.isAnimatingMenu];
//        
//    }
//}
//
//#pragma mark - Init Menu items
//
//- (void)initItems {
//    
//    NSArray *menuItems = PGApp.app.menuManager.items;
//    
//    itemIndex = [NSMutableArray array];
//
//    for (NSString *item in menuItems) {
//
//        Class itemClass = NSClassFromString(item);
//        if (itemClass != Nil) {
//            [itemIndex addObject:itemClass];
//        } else {
//            DDLogError(@"itemClass %@ is Nil :(", item);
//        }
//        
//    }
//    
//}
//
//#pragma mark - Open / Close
//
//- (void)didOpenMenu {
//    //To be implemented by subclass
//}
//
//- (void)willCloseMenu {
//    //To be implemented by subclass
//}
//
//- (void)reloadTable {
//    
//    [table reloadData];
//    
//}
//
//// Disable fading in / out
//
//- (void)fadeContentIn {}
//
//- (void)fadeContentOut {}
//
////- (void)setBackground:(UIImage *)image {}
////- (UIImage *)backgroundForPortrait { return nil; }
////- (UIImage *)backgroundForLandscape { return nil; }

@end
