//
//  PGReorderTableView.h
//  qualitas_v2
//
//  Created by Morgan Conlan on 23/07/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGReorderTableViewDelegate <UITableViewDelegate>

// This method is called when starting the re-ording process. You insert a blank row object into your
// data source and return the object you want to save for later. This method is only called once.
- (id)saveObjectAndInsertBlankRowAtIndexPath:(NSIndexPath *)indexPath;

// This method is called when the selected row is dragged to a new position. You simply update your
// data source to reflect that the rows have switched places. This can be called multiple times
// during the reordering process
- (void)moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath;

// This method is called when the selected row is released to its new position. The object is the same
// object you returned in saveObjectAndInsertBlankRowAtIndexPath:. Simply update the data source so the
// object is in its new position. You should do any saving/cleanup here.
- (void)finishReorderingWithObject:(id)object atIndexPath:(NSIndexPath *)indexPath;
@end

@interface PGReorderTableView : UITableView

@property (nonatomic, assign) id <PGReorderTableViewDelegate> delegate;
@property (nonatomic, assign) CGFloat draggingRowHeight;
@property (nonatomic, assign) CGFloat draggingViewOpacity;
@property (nonatomic, assign) BOOL canReorder;

@end
