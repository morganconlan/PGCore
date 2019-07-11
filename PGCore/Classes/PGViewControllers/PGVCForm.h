//
//  PGVCForm.h
//  pgcore
//
//  Created by Morgan Conlan on 10/08/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGVC.h"

@interface PGVCForm : PGVC <UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate, UITextViewDelegate>

/**
 *  The table view
 */
@property (nonatomic, strong) UITableView *tableView;

/**
 *  Array of arrays of BPFormCell objects. Each element from the ```formCells``` array is a section, having an array of cells.
 */
@property (nonatomic, strong) NSArray *formCells;

/**
 *  Set this to use a custom height for headers
 */
@property (nonatomic, assign) CGFloat customSectionHeaderHeight;

/**
 *  Set this to use a custom height for footers
 */
@property (nonatomic, assign) CGFloat customSectionFooterHeight;

/**
 *  Set the header title for a specified section
 *
 *  @param inHeaderTitle the header title
 *  @param inSection     the section
 */
- (void)setHeaderTitle:(NSString *)inHeaderTitle forSection:(int)inSection;

/**
 *  Set the footer title for a specified section
 *
 *  @param inFooterTitle the title
 *  @param inSection     the section
 */
- (void)setFooterTitle:(NSString *)inFooterTitle forSection:(int)inSection;

/**
 *  Checks all the form cells if they are valid
 *
 *  @return YES if all the cells are valid
 */
- (BOOL)allCellsAreValid;

- (void)setupTableView;

@end
