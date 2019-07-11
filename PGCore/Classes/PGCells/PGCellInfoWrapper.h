//
//  PGCellInfoWrapper.h
//  pgcore
//
//  Created by Morgan Conlan on 10/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGApp.h"

@interface PGCellInfoWrapper : NSObject

@property (nonatomic, assign) BOOL isSelectable;
@property (nonatomic, assign) BOOL isPerformingSelectorWithModel;
@property (nonatomic, assign) BOOL isPerformingSelectorOnCell;
@property (nonatomic, assign, setter=setIsShowingAccessory:) BOOL isShowingAccessory;
@property (nonatomic, assign) BOOL isDividerDisabled;
@property (nonatomic, strong) NSString *cellIdentifier;
/**
 *  Selector performed on delegate when cell is pressed
 */
@property (nonatomic, strong) NSString *selector;
/**
 *  Dictionary containing cell contents to be passed to the cell
 */
@property (nonatomic, strong) NSMutableDictionary *info;
/**
 *  Optional object to pass with selector
 */
@property (nonatomic, strong) id object;

// Swiping
/**
 *  Selector performed on delegate when the cell is swipped right
 *  If the selector contains the string IndexPath: and swipeRightOject is nil, the object passed will
 *  be the indexPath of the swiped cell
 */
@property (nonatomic, strong) NSString *swipeRightSelector;
/**
 *  Selector performed  on delegate when the cell is swiped left
 *  If the selector contains the string IndexPath: and swipeLeftOject is nil, the object passed will
 *  be the indexPath of the swiped cell
 */
@property (nonatomic, strong) NSString *swipeLeftSelector;
/**
 *  The target for swipeRightSelector
 */
@property (nonatomic, strong) id swipeRightObject;
/**
 *  The target for swipeLeftSelector
 */
@property (nonatomic, strong) id swipeLeftObject;

- (instancetype)initWithId:(NSString *)identifier info:(NSDictionary *)info;

+ (PGCellInfoWrapper *)plainCell:(NSString *)title;
+ (PGCellInfoWrapper *)cell:(NSString *)identifier;
+ (PGCellInfoWrapper *)cell:(NSString *)identifier info:(NSDictionary *)info;

+ (PGCellInfoWrapper *)email:(NSString *)email;
+ (PGCellInfoWrapper *)tel:(NSString *)tel;
+ (PGCellInfoWrapper *)web:(NSString *)web;

- (void)addStringInfo:(NSString *)value forKey:(NSString *)key;
- (void)addInfo:(id)value forKey:(NSString *)key;

@end
