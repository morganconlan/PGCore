
//  PGTBVC.m
//  pgcore
//
//  Created by Morgan Conlan on 24/04/2013.
//  Copyright (c) 2013 Morgan Conlan. All rights reserved.
//

#import "PGTBVC.h"
#import "PGReorderTableView.h"
#import "NSIndexPath+Expanded.h"

NSString *const kPG_Table_Default = @"table_default";
NSString *const kPG_Table_Search = @"table_search";

@interface PGTBVC() <PGReorderTableViewDelegate>

@property (nonatomic, strong) UISwipeGestureRecognizer *twoFingerSwipeUp;
@property (nonatomic, strong) UISwipeGestureRecognizer *twoFingerSwipeDown;
@property (nonatomic, strong) UIRefreshControl *refresh;

@end

@implementation PGTBVC

#pragma mark - View lifecycle

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [table reloadData];

    if (self.isFadingTableOnAppear) {

        table.alpha = 0.0f;
    
        [UIView animateWithDuration:0.5
                         animations:^{table.alpha = 1.0f;}];

    }
}

- (void)viewDidDisappear:(BOOL)animated {
    
    self.fetchedResultsController = nil;

    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    
    _fetchedResultsController.delegate = nil;
    _fetchedResultsController = nil;
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Setup

- (void)setupTableWithDisclosure:(BOOL)showDisclosure
                          style:(UITableViewStyle)style {

    DDLogError(@"Table should be created with setupTable or setupTableWithFrame:");

}


- (void)setupTable {

    [self setupTableWithFrame:self.contentView.frame style:UITableViewStylePlain];
}

- (void)setupTableWithFrame:(CGRect)frame {
    [self setupTableWithFrame:frame style:UITableViewStylePlain];
}

- (void)setupTableWithFrame:(CGRect)frame style:(UITableViewStyle)style {

    if (_isTableSetup) return;

    if (table) {

        [table setFrame:frame];
        return;

    }

    self.isFadingTableOnAppear = YES;

    table = [[UITableView alloc] initWithFrame:self.contentView.bounds
                                         style:style];

    table.dataSource = self;
    table.delegate = self;
    [table.backgroundView setHidden:YES];
    table.backgroundColor = [UIColor clearColor];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];

    _twoFingerSwipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                  action:@selector(scrollToTop)];
    _twoFingerSwipeUp.direction = UISwipeGestureRecognizerDirectionUp;
    _twoFingerSwipeUp.numberOfTouchesRequired = 2;

    _twoFingerSwipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                    action:@selector(scrollToBottom)];
    _twoFingerSwipeDown.direction = UISwipeGestureRecognizerDirectionDown;
    _twoFingerSwipeDown.numberOfTouchesRequired = 2;

    [table addGestureRecognizer:_twoFingerSwipeUp];
    [table addGestureRecognizer:_twoFingerSwipeDown];

    if (_isPullToRefresh) { // Enable pull to refresh

        _refresh = [[UIRefreshControl alloc] init];
        //_refresh.attributedTitle = [[NSAttributedString alloc] initWithString:[PGApp.app string:kPG_PullToRefresh]];
        _refresh.tintColor = [PGApp.app colour:kPG_Colour_Pull_To_Refresh];

        [_refresh addTarget:self
                     action:@selector(pulledToRefresh:)
           forControlEvents:UIControlEventValueChanged];

        [self setRefresh:_refresh];
        [table addSubview:_refresh];

    }

    [self.contentView addSubview:table];

    [table setFrame:frame];

    _isTableSetup = YES;
}

- (void)setupTableWithStyle:(UITableViewStyle)style {
    
    [self setupTableWithDisclosure:NO
                            style:style];
    
}

- (void)setupReorderTable {
    
    table = [[PGReorderTableView alloc] initWithFrame:self.contentView.bounds
                                                style:UITableViewStylePlain];
    
    table.dataSource = self;
    table.delegate = self;
    [table.backgroundView setHidden:YES];
    table.backgroundColor = [UIColor clearColor];
    [table setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    [self.contentView addSubview:table];

}


#pragma mark - Fetched Results Controller

- (NSFetchedResultsController *)fetchedResultsController {
    //Must be implemented by subclass
    return nil;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    [self.activeTable beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.activeTable;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
        {
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
            
        case NSFetchedResultsChangeDelete:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
            
        case NSFetchedResultsChangeUpdate:
        {
            [tableView reloadRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
            
        case NSFetchedResultsChangeMove:
        {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
            
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationNone];
        }
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id )sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [table insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                 withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [table deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                 withRowAnimation:UITableViewRowAnimationFade];
            break;

        default:
            break;
    }
}


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
    [self.activeTable endUpdates];
}

#pragma mark - UITableView Datasource

- (void)setItems:(NSArray *)items_ {
    
    items = [items_ mutableCopy];
    
    if (items.count == 0) {
        
        isGrouped = NO;
        [self setupEmptyTable];
        
    } else {
        
        if (table.alpha != 1.0f) [table setAlpha:1.0f];
        
        if (isDisplayingEmpty) [self removeSetupEmptyTable];
        
        isGrouped = ([items_[0] isKindOfClass:[NSArray class]]
                     || [items_[0] isKindOfClass:[NSMutableArray class]]);

    }
    
    [table reloadData];
    
}

- (void)appendItems:(NSArray *)newItems {

    if (items.count == 0) {

        items = [newItems mutableCopy];
        return;
    }

    items = [items arrayByAddingObjectsFromArray:newItems];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.fetchedResultsController != nil) {
        
        return self.fetchedResultsController.sections.count;
    }
    
    return (isGrouped) ? items.count : 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    if (self.fetchedResultsController != nil) {
        
        return [self.fetchedResultsController.sections[section] numberOfObjects];
        
    }
    
    return (isGrouped) ? [items[section] count] : [items count];
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableDictionary *info = [[self infoWrapperForCellAtIndexPath:indexPath forTable:tableView] info];
    info[kPGCell_DelegateWidth] = @(tableView.frame.size.width);
    info[kPGCell_IsExpanded] = @([self cellExpandedAtIndexPath:indexPath]);
    CGFloat height = [[self cellClassAtIndexPath:indexPath] heightWithCellInfo:info];

    return height;
    
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {
    
    if (sections != nil
        && sections.count > 0
        && sections[section] != nil
        && [sections[section] isKindOfClass:[PGSectionWrapper class]]) {
    
        PGSectionWrapper *sectionWrapper = sections[section];
        return (sectionWrapper.section != nil)
                ? sectionWrapper.section.frame.size.height
                : 0.0f;
        
    }
    
    return 0.0f;
}

// Bugfix for footers always having a height
- (CGFloat)tableView:(UITableView *)tableView
heightForFooterInSection:(NSInteger)section {

    return 0.01f;

}

// Bugfix for footers always having a height
- (UIView *)tableView:(UITableView *)tableView
viewForFooterInSection:(NSInteger)section{

    return [[UIView alloc] initWithFrame:CGRectZero];

}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [cell setBackgroundColor:[PGApp.app colour:kPG_Colour_Cell_Background]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    PGCellInfoWrapper *infoWrapper = [self infoWrapperForCellAtIndexPath:indexPath];
    NSString *CellIdentifier = (infoWrapper != nil
                                && infoWrapper.cellIdentifier != nil)
                                    ? infoWrapper.cellIdentifier
                                    : kPGCell;
    
    PGCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        cell = [[[[PGApp cellClassForIdentifier:CellIdentifier] class] alloc] initWithStyle:UITableViewCellStyleDefault
                                                                            reuseIdentifier:CellIdentifier];
        
        cell.delegate = self;

    }

    NSMutableDictionary *info = infoWrapper.info;
    info[kPGCell_Section] = @(indexPath.section);
    info[kPGCell_Row] = @(indexPath.row);
    info[kPGCell_IsSelectable] = @(infoWrapper.isSelectable);
    info[kPGCell_IsEven] = @(indexPath.row % 2 == 0);
    if (info[kPGCell_IsDividerDisabled] == nil) info[kPGCell_IsDividerDisabled] = @(infoWrapper.isDividerDisabled);
    // check if cell is the last cell in the current section
    info[kPGCell_IsLastInSection] = @(indexPath.row == ([table numberOfRowsInSection:indexPath.section] - 1));
    info[kPGCell_IsExpanded] = @([self cellExpandedAtIndexPath:indexPath]);
    info[kPGCell_DelegateWidth] = @(tableView.frame.size.width);
    [cell updateCellInfo:info];
    
    if ([cell respondsToSelector:@selector(setupMap)]) {
        [cell performSelector:@selector(setupMap)];
    }

    [cell selectCell:[self cellSelectedAtIndexPath:indexPath]];
    
    return cell;
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath {
    
    PGCellInfoWrapper *infoWrapper = [self infoWrapperForCellAtIndexPath:indexPath];
    
    if (infoWrapper != nil
        && infoWrapper.cellIdentifier != nil)
        return infoWrapper.cellIdentifier;

    return kPGCell;
    
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {

    return [table indexPathForCell:cell];

}
    
- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PGCellInfoWrapper *infoWrapper = [self infoWrapperForCellAtIndexPath:indexPath];
    
    if (! infoWrapper.isSelectable
        || infoWrapper.selector == nil) return;
    
    SEL selector = NSSelectorFromString(infoWrapper.selector);
    
    if (infoWrapper.isPerformingSelectorOnCell) {
        id cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
            [cell performSelector:selector];
#pragma clang diagnostic pop
        } else {
            DDLogError(@"Couldn't perform: %@ on cell", infoWrapper.selector);
        }
        
        return;
    }

    // Pass the indexPath of the current cell as the argument
    if ([infoWrapper.selector hasSuffix:@"AtIndexPath:"]) {

        if ([self respondsToSelector:selector]) {
            [self performSelector:selector
                       withObject:indexPath
                       afterDelay:0.0f];
        } else {
            DDLogError(@"%@ doesn't respond to %@", [self class], infoWrapper.selector);
        }

        return;

    }
    
    if ([self respondsToSelector:selector]) {
        [self performSelector:selector
                   withObject:infoWrapper.object
                   afterDelay:0.0f];
    } else {
        DDLogError(@"%@ doesn't respond to %@", [self class], infoWrapper.selector);
    }
    
}

- (NSIndexPath *)tableView:(UITableView *)tableView
  willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (!isSelectionEnabled) return indexPath;
    
    [self selectRowAtIndexPath:indexPath];
    return nil;
    
}

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Don't do anything if cell is already selected
    if (_selectedIndex
        && _selectedIndex.section == indexPath.section
        && _selectedIndex.row == indexPath.row) {
        
        return;
        
    }
    
    if (_selectedIndex) {
    
        PGCell *oldCell = (PGCell *)[self.activeTable cellForRowAtIndexPath:_selectedIndex];
        [oldCell selectCell:NO];
        
    }
    
    PGCell *cell = (PGCell *)[self.activeTable cellForRowAtIndexPath:indexPath];
    [cell selectCell:YES];
    
    _selectedIndex = indexPath;
    
    [self tableView:self.activeTable
didSelectRowAtIndexPath:_selectedIndex];
    
}

- (void)reloadSelectedCell {
    
    if (_selectedIndex == nil) return;
    
    [self.activeTable beginUpdates];
    
    [self.activeTable reloadRowsAtIndexPaths:@[_selectedIndex]
                 withRowAnimation:UITableViewRowAnimationNone];
    
    [self.activeTable endUpdates];
    
}

- (BOOL)isSelectionEnabled {
    
    return isSelectionEnabled;
}

#pragma mark - Convenience methods

- (void)setupEmptyTable {
    
    isDisplayingEmpty = YES;
}

- (void)removeSetupEmptyTable {
    
    isDisplayingEmpty = NO;
}

- (void)scrollToSection:(NSInteger)section {
    
    if (section <= 0) return;
    if (items.count == 0) return;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0
                                                inSection:section];
    
    [self.activeTable scrollToRowAtIndexPath:indexPath
                 atScrollPosition:UITableViewScrollPositionTop
                         animated:YES];
    
}

//TODO: support for grouped tables
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [items removeObjectAtIndex:indexPath.row];
    
    [self.activeTable beginUpdates];
    [self.activeTable deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.activeTable endUpdates];
    
    if (items.count == 0) [self setupEmptyTable];
    
}

- (void)layoutForPortrait {
    
    [super layoutForPortrait];
    [table setFrame:self.contentView.bounds];
    
}

- (void)layoutForLandscape {
    
    [super layoutForLandscape];
    [self.activeTable setFrame:self.contentView.bounds];
    
}
    
- (PGCellInfoWrapper *)infoWrapperForCellAtIndexPath:(NSIndexPath *)indexPath {

    return [self infoWrapperForCellAtIndexPath:indexPath
                                      forTable:table];

}

- (PGCellInfoWrapper *)infoWrapperForCellAtIndexPath:(NSIndexPath *)indexPath
                                            forTable:(UITableView *)tableView {
    
    id model = [self modelAtIndexPath:indexPath
                             forTable:tableView];
    
    if ([model isKindOfClass:[PGCellInfoWrapper class]]) {
        
        return model;
    }
    
    if ([model respondsToSelector:@selector(infoWrapperForPGVC:)]) {
        
        return [model infoWrapperForPGVC:self];
    }
    
    if ([model respondsToSelector:@selector(infoWrapper)]) {
        
        return [model infoWrapper];
    }

    // generate infoWrapper from selector string
    // this will regenerate the infoWrapper every time it's called!
    if ([model isKindOfClass:[NSString class]]) {

        SEL infoWrapperSelector = NSSelectorFromString(model);
        if ([self respondsToSelector:infoWrapperSelector]) {
            return [self performSelector:infoWrapperSelector];
        }
    }
    
    // infoWrapper is missing so create one instead
    NSDictionary *info = @{@"title": @":( No infoWrapper for indexPath"};
    
    PGCellInfoWrapper *infoWrapper = [[PGCellInfoWrapper alloc] initWithId:kPG_Cell_Plain
                                                                      info:info];
    
    return infoWrapper;
    
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath {

    return [PGApp cellClassForIdentifier:[self cellIdentifierForIndexPath:indexPath]];
    
}

#pragma mark - Section Handling

- (void)createSection:(PGSectionWrapper *)section
            withItems:(NSArray *)itemsForSection {
    
    if (itemsForSection == nil
        || itemsForSection.count == 0) return;
    
    if (items == nil) items = [NSMutableArray array];
    if (sections == nil) sections = [NSMutableArray array];
    
    [items addObject:itemsForSection];

    [sections addObject:section];
    
    isGrouped = YES;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {
    
    if (sections != nil
        && sections.count > section
        && sections[section] != nil
        && [sections[section] isKindOfClass:[PGSectionWrapper class]]) {
        
        PGSectionWrapper *sectionWrapper = sections[section];
        
        UIView *sectionView = sectionWrapper.section;
        
//        if ([sectionView respondsToSelector:@selector(animateIn)]) {
//            [sectionView performSelector:@selector(animateIn) withObject:nil afterDelay:0.0f];
//        }
        
        return sectionView;
    }
    
    return nil;
}

- (CGFloat)tableWidth {
    return self.activeTable.frame.size.width;
}

#pragma mark - PGTBVCDelegate Methods

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView {

    return self.fetchedResultsController;

}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {

    if (!indexPath) return nil;

    if (self.fetchedResultsController != nil) {
        
        id model = [self.fetchedResultsController objectAtIndexPath:indexPath];
        return model;
        
    }

    return (isGrouped)
            ? items[indexPath.section][indexPath.row]
            : items[indexPath.row];
    
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath
              forTable:(UITableView *)tableView {

//    return [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
    return [self modelAtIndexPath:indexPath];
}

- (id)modelForCell:(UITableViewCell *)cell {

    NSIndexPath *indexPath = [self.activeTable indexPathForRowAtPoint:cell.center];
    
    return [self modelAtIndexPath:indexPath];
    
}

- (id)objectForSelector:(SEL)sel
onModelAtIndexPath:(NSIndexPath *)indexPath {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [[self modelAtIndexPath:indexPath] performSelector:sel];
#pragma clang diagnostic pop
    
}

- (id)passDelegateGettingObjectForSelector:(SEL)sel
     onModelAtIndexPath:(NSIndexPath *)indexPath {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    return [[self modelAtIndexPath:indexPath] performSelector:sel withObject:self];
#pragma clang diagnostic pop
    
}

- (id)objectForSelector:(SEL)sel
         onModelForCell:(UITableViewCell *)cell {
    
    id model = [self modelForCell:(PGCell *)cell];
    
    if ([model respondsToSelector:sel]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [[self modelForCell:(PGCell *)cell] performSelector:sel];
#pragma clang diagnostic pop
    } else {
        
        //DDLogWarn(@"%@ can't perform selector '%@'", [model description], NSStringFromSelector(sel));
        return nil;
    }
    
}

//Pass the delegate as well as sometimes context is required
- (id)passDelegateGettingObjectForSelector:(SEL)sel
         onModelForCell:(UITableViewCell *)cell {
    
    id model = [self modelForCell:(PGCell *)cell];
    
    if ([model respondsToSelector:sel]){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        return [[self modelForCell:(PGCell *)cell] performSelector:sel
                                              withObject:self];
#pragma clang diagnostic pop
    } else {
        
        DDLogWarn(@"%@ can't perform selector '%@'", [model description], NSStringFromSelector(sel));
        return nil;
    }
    
}

- (void)performSelector:(SEL)sel
         onModelForCell:(UITableViewCell *)cell {

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSManagedObject *model = [self modelForCell:(PGCell *)cell];
    if ([model respondsToSelector:sel]) {
        [[self modelForCell:cell] performSelector:sel];
    } else {
        DDLogError(@"%@ doesn't respond to %@", NSStringFromClass(model.class), NSStringFromSelector(sel));
    }
    

    //Delegate might be interested in selector, so check if it responds
    //Also passing the cell to it so modify selector to have withObject
    SEL selForDelegate = NSSelectorFromString([NSString stringWithFormat:@"%@:",
                                            NSStringFromSelector(sel)]);
    
    if ([self respondsToSelector:selForDelegate]) {
        
        [self performSelector:selForDelegate withObject:cell];
        
    }
#pragma clang diagnostic pop
    
}

- (void)performSelectorWithDelegate:(SEL)sel
         onModelForCell:(UITableViewCell *)cell {
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSManagedObject *model = [self modelForCell:cell];
    if ([model respondsToSelector:sel]) {
        [[self modelForCell:cell] performSelector:sel withObject:self];
    } else {
        DDLogError(@"%@ doesn't respond to %@", NSStringFromClass(model.class), NSStringFromSelector(sel));
    }
#pragma clang diagnostic pop
    
}

#pragma mark - Swipe Gesture selectors 

- (void)scrollToTop {
    [table scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                     inSection:0]
                 atScrollPosition:UITableViewScrollPositionTop
                         animated:NO];
}

- (void)scrollToBottom {
    DDLogVerbose(@"TODO!");
}

#pragma mark - Pull to refresh

- (void)pulledToRefresh:(id)sender {
    // End Refreshing
    [(UIRefreshControl *)sender endRefreshing];
}

#pragma mark - Swiping

// support for swipping in searches
- (UITableView *)activeTable {
    return table;
}

- (void)swipeCellDidStartSwiping:(PGSwipeCell *)swipeCell {
    
}

- (void)swipeell:(PGSwipeCell *)swipeCell
swipedToLocation:(CGPoint)translation
        velocity:(CGPoint)velocity {
    
}

- (void)swipeCellWillResetState:(PGSwipeCell *)swipeCell
                   fromLocation:(CGPoint)translation
                      animation:(PGSwipeCellAnimationType)animation
                       velocity:(CGPoint)velocity {
    
}

- (void)swipeCellDidResetState:(PGSwipeCell *)swipeCell
                  fromLocation:(CGPoint)translation
                     animation:(PGSwipeCellAnimationType)animation
                      velocity:(CGPoint)velocity {
    
    UITableView *tableView = self.activeTable; // support searchVC table too
    NSIndexPath *indexPath = [tableView indexPathForCell:swipeCell];
    
    if (indexPath == nil) return;
    PGCellInfoWrapper *infoWrapper = [self infoWrapperForCellAtIndexPath:indexPath];
    
    // Swiping Right
    if (translation.x < (-tableView.rowHeight * 1.5)
        && (swipeCell.revealDirection == PGSwipeCellRevealDirectionBoth
            || swipeCell.revealDirection == PGSwipeCellRevealDirectionRight)) {
            
        // Nothing to do!
        if (infoWrapper.swipeRightSelector == nil) return;
        
        SEL selector = NSSelectorFromString(infoWrapper.swipeRightSelector);
        
        if (infoWrapper.isPerformingSelectorOnCell) {
            
            if ([swipeCell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [swipeCell performSelector:selector];
#pragma clang diagnostic pop
            } else {
                DDLogError(@"Couldn't perform: %@ on cell", infoWrapper.swipeRightSelector);
            }
            
            return;
        }
        
        // Check if the selector contains IndexPath: in which case, pass the indexPath as the object
        id swipeRightObject = ([infoWrapper.swipeRightSelector rangeOfString:@"IndexPath:"].location == NSNotFound)
                                ? infoWrapper.swipeRightObject
                                : indexPath;
        
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector
                       withObject:swipeRightObject
                       afterDelay:0.0f];
        } else {
            DDLogError(@"%@ doesn't respond to %@", [self class], infoWrapper.swipeRightSelector);
        }
    
        // Swiping Left
    } else if (translation.x > (tableView.rowHeight * 1.5)
               && (swipeCell.revealDirection == PGSwipeCellRevealDirectionBoth
                   || swipeCell.revealDirection == PGSwipeCellRevealDirectionLeft)) {
          
        // Nothing to do!
        if (infoWrapper.swipeLeftSelector == nil) return;
        
        SEL selector = NSSelectorFromString(infoWrapper.swipeLeftSelector);
        
        if (infoWrapper.isPerformingSelectorOnCell) {
            
            if ([swipeCell respondsToSelector:selector]) {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
                [swipeCell performSelector:selector];
#pragma clang diagnostic pop
            } else {
                DDLogError(@"Couldn't perform: %@ on cell", infoWrapper.swipeLeftSelector);
            }
            
            return;
        }
        
        // Check if the selector contains IndexPath: in which case, pass the indexPath as the object
        id swipeLeftObject = ([infoWrapper.swipeLeftSelector rangeOfString:@"IndexPath:"].location == NSNotFound)
                                ? infoWrapper.swipeLeftObject
                                : indexPath;
        
        if ([self respondsToSelector:selector]) {
            [self performSelector:selector
                       withObject:swipeLeftObject
                       afterDelay:0.0f];
        } else {
            DDLogError(@"%@ doesn't respond to %@", [self class], infoWrapper.swipeLeftSelector);
        }
    
    }
    
}

#pragma mark - ReorderTableViewDelegate Methods

- (id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDLogWarn(@"should be implemented by subclass.");
    
    return nil;
    
}

// This method is called when the selected row is dragged to a new position. You simply update your
// data source to reflect that the rows have switched places. This can be called multiple times
// during the reordering process
- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
               toIndexPath:(NSIndexPath *)toIndexPath {
    
    DDLogWarn(@"should be implemented by subclass.");
}

- (void)updateOrderingForObjectAtIndex:(NSInteger)index {
    
    DDLogWarn(@"should be implemented by subclass.");
    
}

// This method is called when the selected row is released to its new position. The object is the same
// object you returned in saveObjectAndInsertBlankRowAtIndexPath:. Simply update the data source so the
// object is in its new position. You should do any saving/cleanup here.
- (void)finishReorderingWithObject:(id)object
                       atIndexPath:(NSIndexPath *)indexPath {
    
    DDLogWarn(@"should be implemented by subclass.");
}

#pragma mark - Expanding Cells

- (NSString *)activeTableIdentifier {

    if (table != self.activeTable) return kPG_Table_Search;
    return kPG_Table_Default;

}

- (void)toggleExpandedCell:(PGCell *)cell {

    NSIndexPath *indexPath = [table indexPathForCell:cell];
    [self toggleExpandedAtIndexPath:indexPath];

}

- (void)toggleExpandedAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath == nil) return;

    if (self.expandedPaths == nil) {
        self.expandedPaths = [NSMutableDictionary dictionary];
    }

    if (self.expandedPaths[self.activeTableIdentifier] == nil) {

        self.expandedPaths[self.activeTableIdentifier] = [NSMutableSet set];

        [self.expandedPaths[self.activeTableIdentifier] addObject:indexPath];
        [self.activeTable reloadRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];

        return;

    }

    // Note: - (NSUInteger)hash overwritten in category NSIndexPath+Expanded
    if ([self.expandedPaths[self.activeTableIdentifier] containsObject:indexPath]) {
        [self.expandedPaths[self.activeTableIdentifier] removeObject:indexPath];
    } else {
        [self.expandedPaths[self.activeTableIdentifier] addObject:indexPath];
    }

    [self.activeTable reloadRowsAtIndexPaths:@[indexPath]
                            withRowAnimation:UITableViewRowAnimationFade];

}

- (BOOL)cellExpandedAtIndexPath:(NSIndexPath *)indexPath {

    if (self.expandedPaths == nil
        || self.expandedPaths[self.activeTableIdentifier] == nil) return NO;

    return [self.expandedPaths[self.activeTableIdentifier] containsObject:indexPath];

}

- (NSNumber *)isCellExpanded:(PGCell *)cell {

    NSIndexPath *indexPath = [table indexPathForCell:cell];
    return @([self cellExpandedAtIndexPath:indexPath]);

}

#pragma mark - Selecting Cells

- (void)toggleSelectedAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath == nil) return;

    if (self.selectedPaths == nil) {
        self.selectedPaths = [NSMutableSet set];

        [self.selectedPaths addObject:indexPath];
        [self.activeTable reloadRowsAtIndexPaths:@[indexPath]
                     withRowAnimation:UITableViewRowAnimationFade];

        return;

    }

    // Note: - (NSUInteger)hash overwritten in category NSIndexPath+Expanded
    if ([self.selectedPaths containsObject:indexPath]) {
        [self.selectedPaths removeObject:indexPath];
    } else {
        [self.selectedPaths addObject:indexPath];
    }

    [self.activeTable reloadRowsAtIndexPaths:@[indexPath]
                 withRowAnimation:UITableViewRowAnimationFade];

}

- (BOOL)cellSelectedAtIndexPath:(NSIndexPath *)indexPath {

    return [self.selectedPaths containsObject:indexPath];

}

- (NSNumber *)isCellSelected:(PGCell *)cell {

    NSIndexPath *indexPath = [table indexPathForCell:cell];
    return @([self cellSelectedAtIndexPath:indexPath]);
    
}

@end
