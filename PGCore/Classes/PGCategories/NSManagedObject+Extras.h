//
//  NSManagedObject+Extras.h
//  pangr
//
//  Created by Morgan Conlan on 04/12/2012.
//  Copyright (c) 2012 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PGApp.h"
#import "PGCellInfoWrapper.h"
#import "PGVC.h"

@class PGCellInfoWrapper;

@interface NSManagedObject (Extras)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
                                 relations:(NSArray *)relations
                             dateFormatter:(NSDateFormatter *)dateFormatter
                           numberFormatter:(NSNumberFormatter *)numFormatter;

/**
 * Default wrapper for the information require to display the object in a cell
 */
- (PGCellInfoWrapper *)infoWrapper;

/**
 * Optional wrapper for the information require to display the object in a cell
 */
- (PGCellInfoWrapper *)infoWrapperForPGVC:(PGVC *)pgvc;

/**
 * An array of cell info wrappers to create the details section of the model 
 * in a table
 */
- (NSArray *)details;

- (BOOL)isPKSet;

#pragma mark - Safely add to JSON

- (id)safePK:(NSNumber *)pk;

- (id)safeNumber:(NSNumber *)number;

- (id)safeDate:(NSDate *)date;

- (id)safeDateOnly:(NSDate *)date;

- (id)safeString:(NSString *)string;

- (id)safeTime:(NSString *)time;

#pragma mark - Page Elements

- (void)addToDetails:(NSMutableArray **)details
           infoWrapper:(PGCellInfoWrapper *)info;

#pragma mark - Access

+ (instancetype)pk:(NSNumber *)pk;
+ (instancetype)id:(NSNumber *)pk;

#pragma mark - Debugging

+ (NSString *)readableNameFromClass:(Class)clazz;

@end
