//
//  PGTBVC.h
//  pgcore
//
//  Created by Morgan Conlan on 24/04/2013.
//  Copyright (c) 2013 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PGVC.h"
#import "PGCell.h"
#import "PGSwipeCell.h"
#import "PGTBDelegate.h"
#import "PGSectionWrapper.h"
#import "PGCellInfoWrapper.h"

extern NSString *const kPG_Table_Default;
extern NSString *const kPG_Table_Search;

@class PGCell, PGCellInfoWrapper, PGApp;

@interface PGTBVC : PGVC <UITableViewDataSource, UITableViewDelegate,
PGTBDelegate, NSFetchedResultsControllerDelegate> {
    
    @protected
    NSMutableArray *items;
    NSMutableArray *sections;
    UITableView *table;
    BOOL isSelectionEnabled;
    BOOL isGrouped;
    BOOL isDisplayingEmpty;
    
}

@property (assign) BOOL isTableSetup;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSIndexPath *selectedIndex;
@property (nonatomic, assign) BOOL isPullToRefresh;
/// Set to YES by default in setupTableWithDisclosure:Style:. Must be set afterwards if used.
@property (nonatomic, assign) BOOL isFadingTableOnAppear;
/// Set of indexPaths that are expanded
//@property (nonatomic, strong) NSMutableSet *expandedPaths;
@property (nonatomic, strong) NSMutableDictionary *expandedPaths;
/// Set of indexPaths that are selected
@property (nonatomic, strong) NSMutableSet *selectedPaths;

- (void)setupTable;
- (void)setupTableWithFrame:(CGRect)frame;
- (void)setupTableWithFrame:(CGRect)frame style:(UITableViewStyle)style;
- (void)setupReorderTable;
- (void)setupTableWithStyle:(UITableViewStyle)style;
- (void)setupTableWithDisclosure:(BOOL)showDisclosure
                           style:(UITableViewStyle)style;
- (void)setItems:(NSArray *)items;
- (void)setupEmptyTable;
- (void)removeSetupEmptyTable;
- (void)removeItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)reloadSelectedCell;
- (BOOL)isSelectionEnabled;
- (UITableView *)activeTable;
- (id)modelAtIndexPath:(NSIndexPath *)indexPath;
- (id)modelAtIndexPath:(NSIndexPath *)indexPath
              forTable:(UITableView *)tableView;
- (id)modelForCell:(PGCell *)cell;
- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath;
- (NSString *)activeTableIdentifier;
#pragma mark - Sections
- (void)createSection:(PGSectionWrapper *)section
            withItems:(NSArray *)itemsForSection;
- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath;
- (PGCellInfoWrapper *)infoWrapperForCellAtIndexPath:(NSIndexPath *)indexPath;
- (void)scrollToSection:(NSInteger)section;
#pragma mark - Pull to refresh
/***
 * Unless this is overridden, it will just dismiss the refresh controll
 */
- (void)pulledToRefresh:(id)sender;
- (void)appendItems:(NSArray *)newItems;

#pragma mark - ReorderTableView Delegate Methods

- (id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath;

// This method is called when the selected row is dragged to a new position. You simply update your
// data source to reflect that the rows have switched places. This can be called multiple times
// during the reordering process
- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
               toIndexPath:(NSIndexPath *)toIndexPath;

- (void)updateOrderingForObjectAtIndex:(NSInteger)index;

// This method is called when the selected row is released to its new position. The object is the same
// object you returned in saveObjectAndInsertBlankRowAtIndexPath:. Simply update the data source so the
// object is in its new position. You should do any saving/cleanup here.
- (void)finishReorderingWithObject:(id)object
                       atIndexPath:(NSIndexPath *)indexPath;

#pragma mark - Expanding cells
- (void)toggleExpandedCell:(PGCell *)cell;
/**
 Adds the provided indexPath to @b expandedPaths if it doesn't already contain it.
 Removes it otherwise.
 @b self.expandedPaths is initialised if it isn't already the case.

 @param indexPath
 the indexPath to toggle
 */
- (void)toggleExpandedAtIndexPath:(NSIndexPath *)indexPath;
/**
 Whether or not the provided indexPath is contained in @b self.expandedPaths
 @param indexPath
 the indexPath to check
 @return BOOL

 */
- (BOOL)cellExpandedAtIndexPath:(NSIndexPath *)indexPath;
/**
 Whether or not the provided cell is expanded by checking if the cell's indexPath is contained in
 @b self.expandedPaths. Useful when called directly from a cell as a dynamic selector.
 @return NSNumber
 An NSNumber representation of a BOOL
 */
- (NSNumber *)isCellExpanded:(PGCell *)cell;

#pragma mark - Selecting cells
/**
 Adds the provided indexPath to @b self.selectedPaths if it doesn't already contain it.
 Removes it otherwise.
 @b self.selectedPaths is initialised if it isn't already the case.

 @param indexPath
 the indexPath to toggle
 */
- (void)toggleSelectedAtIndexPath:(NSIndexPath *)indexPath;
/**
 Whether or not the provided indexPath is contained in @b self.selectedPaths
 @param indexPath
 the indexPath to check
 @return BOOL

 */
- (BOOL)cellSelectedAtIndexPath:(NSIndexPath *)indexPath;
/**
 Whether or not the provided cell is expanded by checking if the cell's indexPath is contained in
 @b selectedPaths. Useful when called directly from a cell as a dynamic selector.
 @return NSNumber
 An NSNumber representation of a BOOL
 */
- (NSNumber *)isCellSelected:(PGCell *)cell;

@end
