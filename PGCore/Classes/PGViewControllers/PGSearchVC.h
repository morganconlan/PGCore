//
//  PGSearchVC.h
//  pgcore
//
//  Created by Morgan Conlan on 16/10/2013.
//  Copyright (c) 2013 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGTBVC.h"

@interface PGSearchVC : PGTBVC <UISearchBarDelegate, UISearchDisplayDelegate> {

    @protected
    // The saved state of the search UI if a memory warning removed the view.
    NSString        *savedSearchTerm_;
    NSInteger       savedScopeButtonIndex_;
    BOOL            searchWasActive_;

}

@property (nonatomic, retain) NSFetchedResultsController *searchFetchedResultsController;
//@property (nonatomic, retain) UISearchDisplayController *mySearchDisplayController;

@property (nonatomic, copy) NSString *savedSearchTerm;
@property (nonatomic) NSInteger savedScopeButtonIndex;
@property (nonatomic) BOOL searchWasActive;
@property (nonatomic) BOOL searchWasPopped;
@property (nonatomic, assign) BOOL isDissapearing;

- (void)setSearchBarInactive;
- (NSFetchedResultsController *)fetchedResultsControllerForTableView:(UITableView *)tableView;
- (NSFetchedResultsController *)newFetchedResultsControllerWithSearch:(NSString *)searchString;
- (id)modelAtIndexPath:(NSIndexPath *)indexPath forTable:(UITableView *)tableView;
- (NSString *)cellIdentifierForIndexPath:(NSIndexPath *)indexPath forTable:(UITableView *)tableView;
- (Class)cellClassAtIndexPath:(NSIndexPath *)indexPath forTable:(UITableView *)tableView;
- (PGCellInfoWrapper *)infoWrapperForCellAtIndexPath:(NSIndexPath *)indexPath forTable:(UITableView *)tableView;

- (UITableView *)activeTable;
- (UIColor *)searchTableBackgroundColour;


@end
