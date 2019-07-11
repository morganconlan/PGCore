//
//  PGSearchVC.m
//  oireachtas
//
//  Created by Morgan Conlan on 16/10/2013.
//  Copyright (c) 2013 Morgan Conlan. All rights reserved.
//

#import "PGSearchVC.h"
#import "PGSearchBar.h"

@interface PGSearchVC ()

@end

@implementation PGSearchVC

- (void)viewDidDisappear:(BOOL)animated {

    self.searchWasActive = (self.searchWasPopped || [self.searchDisplayController isActive]);
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    
    self.searchWasActive = [self.searchDisplayController isActive];
    self.savedSearchTerm = [self.searchDisplayController.searchBar text];
    self.savedScopeButtonIndex = [self.searchDisplayController.searchBar selectedScopeButtonIndex];
    
    _searchFetchedResultsController.delegate = nil;
    _searchFetchedResultsController = nil;
    
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // restore search settings if they were saved in didReceiveMemoryWarning.
    if (self.savedSearchTerm) {
        
        [self.searchDisplayController setActive:self.searchWasActive];
        [self.searchDisplayController.searchBar setSelectedScopeButtonIndex:self.savedScopeButtonIndex];
        [self.searchDisplayController.searchBar setText:self.savedSearchTerm];
        
        self.savedSearchTerm = nil;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    _isDissapearing = YES;
    self.fetchedResultsController = nil;
    self.searchFetchedResultsController = nil;
    [super viewWillDisappear:animated];

}

#warning // FIXME: sometimes this doesn't get called. figure out why!
- (void)setupTableWithDisclosure:(BOOL)showDisclosure
                           style:(UITableViewStyle)style {
    
    [super setupTableWithDisclosure:showDisclosure style:style];
    
    PGSearchBar *searchBar = [[PGSearchBar alloc] initWithFrame:CGRectMake(0, 0, table.frame.size.width, 44.0)];
    searchBar.autoresizingMask = (UIViewAutoresizingFlexibleWidth);
    searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    searchBar.placeholder = [PGApp.app string:kPG_SEARCHBAR_Search];
    searchBar.delegate = self;
    searchBar.tintColor = [PGApp.app hex:0x333333];
    table.tableHeaderView = searchBar;
    
//    self.mySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
//    self.mySearchDisplayController.delegate = self;
//    self.mySearchDisplayController.searchResultsDataSource = self;
//    self.mySearchDisplayController.searchResultsDelegate = self;

}

- (void)setSearchBarInactive {
    
//    [self.mySearchDisplayController setActive:NO animated:YES];
    self.searchWasPopped = YES;

}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    PGSearchBar *pgSearchBar = (PGSearchBar *)searchBar;
    [pgSearchBar setShowsCancelButton:YES];
//    [pgSearchBar setCloseButtonTitle:[PGApp.app string:kPG_SEARCHBAR_Done]
//                            forState:UIControlStateNormal];
    
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    // The fetch controller is about to start sending change notifications, so prepare the table view for updates.
    
    UITableView *tableView = (controller == self.fetchedResultsController) ? table :self.searchDisplayController.searchResultsTableView;
    
    self.searchDisplayController.searchResultsTableView.backgroundColor = [self searchTableBackgroundColour];

    [tableView beginUpdates];
}

- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView {

//    return (self.mySearchDisplayController.isActive)
//            ? self.searchFetchedResultsController
//            : self.fetchedResultsController;
    return nil;
}

//- (void)controller:(NSFetchedResultsController *)controller
//  didChangeSection:(id )sectionInfo
//           atIndex:(NSUInteger)sectionIndex
//     forChangeType:(NSFetchedResultsChangeType)type {
//    
//    UITableView *tableView = (controller == self.fetchedResultsController)
//                                ? table
//                                : self.searchDisplayController.searchResultsTableView;
//    
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//            [tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
//                     withRowAnimation:UITableViewRowAnimationFade];
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//            [tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
//                     withRowAnimation:UITableViewRowAnimationFade];
//            break;
//    }
//}
//
//- (void)controller:(NSFetchedResultsController *)controller
//   didChangeObject:(id)anObject
//       atIndexPath:(NSIndexPath *)indexPath
//     forChangeType:(NSFetchedResultsChangeType)type
//      newIndexPath:(NSIndexPath *)newIndexPath {
//    
//    UITableView *tableView = (controller == self.fetchedResultsController)
//                                ? table
//                                : self.searchDisplayController.searchResultsTableView;
//    
//    switch(type) {
//            
//        case NSFetchedResultsChangeInsert:
//        {
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//        }
//            break;
//            
//        case NSFetchedResultsChangeDelete:
//        {
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//        }
//            break;
//            
//        case NSFetchedResultsChangeUpdate:
//        {
//            [(PGCell *)[tableView cellForRowAtIndexPath:indexPath] updateCellInfo:[[self infoWrapperForCellAtIndexPath:indexPath] info]];
//        }
//            break;
//            
//        case NSFetchedResultsChangeMove:
//        {
//            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//            
//            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//        }
//            break;
//    }
//}
//
//- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
//    // The fetch controller has sent all current change notifications, so tell the table view to process all updates.
//    UITableView *tableView = (controller == self.fetchedResultsController)
//                                ? table
//                                : self.searchDisplayController.searchResultsTableView;
//    
//    if (controller == self.fetchedResultsController) {
//        tableView = table;
//    } else {
//        tableView = self.searchDisplayController.searchResultsTableView;
//        
//    }
//    
//    [tableView endUpdates];
//}

#pragma mark -
#pragma mark Content Filtering
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSInteger)scope {
    
    // update the filter, in this case just blow away the FRC and let lazy evaluation create another with the relevant search info
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;
    // if you care about the scope save off the index to be used by the serchFetchedResultsController
    //self.savedScopeButtonIndex = scope;
}


#pragma mark -
#pragma mark Search Bar
- (void)searchDisplayController:(UISearchDisplayController *)controller
 willShowSearchResultsTableView:(UITableView *)tableView {
    
    tableView.backgroundColor = self.searchTableBackgroundColour;
    [tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
}

- (void)searchDisplayController:(UISearchDisplayController *)controller
willUnloadSearchResultsTableView:(UITableView *)tableView {
    
    // search is done so get rid of the search FRC and reclaim memory
    self.searchFetchedResultsController.delegate = nil;
    self.searchFetchedResultsController = nil;

    [self.expandedPaths removeObjectForKey:kPG_Table_Search];
    
    [table reloadData];

}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[self.searchDisplayController.searchBar selectedScopeButtonIndex]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - frc

- (NSFetchedResultsController *)newFetchedResultsControllerWithSearch:(NSString *)searchString {
    
    DDLogWarn(@"must be implemented by subclass");
    return nil;
}

- (NSFetchedResultsController *)searchFetchedResultsController {
    
    if (_searchFetchedResultsController != nil || _isDissapearing) {
        
        return _searchFetchedResultsController;
    }
    
    _searchFetchedResultsController = [self newFetchedResultsControllerWithSearch:self.searchDisplayController.searchBar.text];
    
    return _searchFetchedResultsController;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    NSInteger count = [[[self fetchedResultsControllerForTableView:tableView] sections] count];
    
    return count;
    
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    NSInteger numberOfRows = 0;
    NSFetchedResultsController *fetchController = [self fetchedResultsControllerForTableView:tableView];
    NSArray *frcSections = fetchController.sections;
    
    if (frcSections.count > 0) {
        
        id <NSFetchedResultsSectionInfo> sectionInfo = [frcSections objectAtIndex:section];
        numberOfRows = [sectionInfo numberOfObjects];
    
    }
    
    return numberOfRows;
    
}

- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath
                                forTable:(UITableView *)tableView {
    
    return [super cellIdentifierForIndexPath:indexPath];
    
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath {

    UITableView *activeTable = self.activeTable;

    if (table == activeTable) {
//        DDLogInfo(@"table");
    } else {
//        DDLogWarn(@"search-table");
    }

    return [self modelAtIndexPath:indexPath
                         forTable:[self activeTable]];
}

- (id)modelAtIndexPath:(NSIndexPath *)indexPath
              forTable:(UITableView *)tableView {
    
    return [[self fetchedResultsControllerForTableView:tableView] objectAtIndexPath:indexPath];
}

- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath
                     forTable:(UITableView *)tableView {
    
    return [PGApp cellClassForIdentifier:[self cellIdentifierForIndexPath:indexPath
                                                                 forTable:tableView]];
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
    
    PGCellInfoWrapper *infoWrapper = [[PGCellInfoWrapper alloc] initWithId:kPG_Cell_Plain
                                                                      info:@{@"title":(model != nil) ? [model description] : @"model missing!"}];
    
    return infoWrapper;
    
}

- (UITableView *)activeTable {
    
    return (self.searchDisplayController.isActive)
            ? self.searchDisplayController.searchResultsTableView
            : table;
    
}

- (id)modelForCell:(UITableViewCell *)cell {
    
    UITableView *activeTable = [self activeTable];
    NSIndexPath *indexPath = [activeTable indexPathForCell:cell];
    
    return [self modelAtIndexPath:indexPath forTable:activeTable];
    
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PGCellInfoWrapper *infoWrapper = [self infoWrapperForCellAtIndexPath:indexPath
                                                                forTable:tableView];
    
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

    } else {
        DDLogVerbose(@"...");
    }

    if ([self respondsToSelector:selector]) {
        [self performSelector:selector
                   withObject:infoWrapper.object
                   afterDelay:0.0f];
    } else {
        DDLogError(@"%@ doesn't respond to %@", [self class], infoWrapper.selector);
    }
    
}

# pragma mark - Search Table

- (UIColor *)searchTableBackgroundColour {
    return [UIColor whiteColor];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {

    [self.expandedPaths removeObjectForKey:kPG_Table_Search];
}

@end
