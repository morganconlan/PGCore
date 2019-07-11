//
//  NSManagedObject+Extras.m
//  pangr
//
//  Created by Morgan Conlan on 04/12/2012.
//  Copyright (c) 2012 Morgan Conlan. All rights reserved.
//

#import "NSManagedObject+Extras.h"

@implementation NSManagedObject (Extras)

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
                                 relations:(NSArray *)relations
                             dateFormatter:(NSDateFormatter *)dateFormatter
                           numberFormatter:(NSNumberFormatter *)numFormatter {
    
    NSDictionary *attributes = [[self entity] attributesByName];
    NSDictionary *attributeMap = [PGApp.app.models attributeMapForObject:self];

#if DEBUG_API > 0

    [self debugAttributesForKeyedValues:keyedValues];

#endif

    for (NSString *attribute in attributes) {

        NSString *mappedAttribute = attributeMap[attribute];
        id value = keyedValues[mappedAttribute];
        
        //Reset single relations (fk in database) if applicable
        //setting everythin to nil breaks everything :(
        if ((value == nil) || (value == [NSNull null])) {
            
            if (!relations) continue;
            
            for (NSString *relation in relations) {
                
                if ([attribute isEqualToString:[NSString stringWithFormat:@"%@%@", relation, PGApp.app.configs.apiFK]]) {
                    [self setNilValueForKey:attribute];
                }
                
            }
            
            continue;
        }
        
        // Hardcode fix for lat and lng for now :(
        if ([attribute isEqualToString:@"lat"]
            || [attribute isEqualToString:@"lng"]) {
            
            if (value != nil) {
                
                if ([value isKindOfClass:[NSString class]])
                    [self setValue:[numFormatter numberFromString:(NSString *)value]
                            forKey:attribute];
                else {
                    [self setValue:value
                            forKey:attribute];
                }
                
            } else {
                
                [self setValue:@-99
                        forKey:attribute];
            }
            continue;
        }
        
        NSAttributeType attributeType = [attributes[attribute] attributeType];
        // Object
        if ((attributeType == NSStringAttributeType)
            && ([value isKindOfClass:[NSDictionary class]])) {
            
            //Ignoring
            continue;
            
        }
        // String
        else if ((attributeType == NSStringAttributeType)
                 && ([value isKindOfClass:[NSNumber class]])) {
            
            value = [value stringValue];
            // Store empty strings as nil
            if ([value isEqualToString:@""]) value = nil;
            
        }
        // Integer
        else if (((attributeType == NSInteger16AttributeType)
                  || (attributeType == NSInteger32AttributeType)
                  || (attributeType == NSInteger64AttributeType)
                  || (attributeType == NSBooleanAttributeType))
                 && ([value isKindOfClass:[NSString class]])) {
            
            value = @([value integerValue]);
            
        }
        // Decimal
        else if ((attributeType == NSDecimalAttributeType)
                 && ([value isKindOfClass:[NSString class]])) {
            
            value = @([value intValue]);
        }
        // Float
        else if ((attributeType == NSFloatAttributeType)
                 &&  ([value isKindOfClass:[NSString class]])) {
            
            value = @([value doubleValue]);
            
        }
        // Date
        else if ((attributeType == NSDateAttributeType)
                 && ([value isKindOfClass:[NSString class]])
                 && (dateFormatter != nil)) {
            //Append time for pure dates so that dateFormatter doesn't have a granny fit
            if ([value length] == 10) { // time is missing
                
                //If applicable, store the date as a string for grouping
                if ([self respondsToSelector:@selector(setDate_string:)]) {
                    
                    [self performSelector:@selector(setDate_string:)
                               withObject:value];
                    
                }
                
                value = [[PGApp.app.models.dateOnlyFormatter dateFromString:value] dateAtStartOfDay];
                
            } else if ([value length] > 19) { // microseconds should be removed

                value = [value substringToIndex:19];
                value = [dateFormatter dateFromString:value];
            }
            
        }
        
        [self setValue:value forKey:attribute];
    }

    if ([self respondsToSelector:@selector(setDate_start:)]) {
        
        NSString *timelessDateString = [NSString stringWithFormat:@"%@ 00:00:00",
                                  [keyedValues[@"datetime_start"] substringToIndex:10]];
        NSDate *timelessDate = [dateFormatter dateFromString:timelessDateString];
        
        if (timelessDate) [self performSelector:@selector(setDate_start:)
                                     withObject:timelessDate];
    }
}

- (void)debugAttributesForKeyedValues:(NSDictionary *)keyedValues {
#if DEBUG_API > 0
    if (!PGApp.app.models.debugAttributes) {
        PGApp.app.models.debugAttributes = [NSMutableDictionary dictionary];
    }

    if (PGApp.app.models.debugAttributes[self.entity.name]) return;

    NSDictionary *attributeMap = [PGApp.app.models attributeMapForObject:self];

    // invert attribute map to use the values as keys
    NSMutableDictionary *attributeMapValues = [NSMutableDictionary dictionary];
    for (NSString *attr in attributeMap.allValues) {
        attributeMapValues[attr] = @(YES);
    }

    NSString *attributes = @"";

    for (NSString *key in keyedValues.allKeys) {
        if (!attributeMapValues[key]) {
            attributes = [attributes stringByAppendingString:[NSString stringWithFormat:@"%@ present in json but not model\n", key]];
        }
    }

    if (attributes.length > 0) NSLog(@"\n\n%@\n%@\n", self.entity.name, attributes);

    PGApp.app.models.debugAttributes[self.entity.name] = @(YES);

#endif
}

- (PGCellInfoWrapper *)infoWrapper {
        
//    DDLogWarn(@"should be implemented in subclass");

    NSString *title, *about;

    SEL nameSelector = NSSelectorFromString(@"name");
    SEL nameSelectorEn = NSSelectorFromString(@"name_en");
    SEL nameSelectorGa = NSSelectorFromString(@"name_ga");
    SEL titleSelector = NSSelectorFromString(@"title");
    SEL titleSelectorEn = NSSelectorFromString(@"title_en");
    SEL titleSelectorGa = NSSelectorFromString(@"title_ga");
    SEL valueSelector = NSSelectorFromString(@"value");
    SEL valueSelectorEn = NSSelectorFromString(@"value_en");
    SEL valueSelectorGa = NSSelectorFromString(@"value_ga");

    SEL aboutSelector = NSSelectorFromString(@"about");
    SEL aboutSelectorEn = NSSelectorFromString(@"about_en");
    SEL aboutSelectorGA = NSSelectorFromString(@"about_ga");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    if ([self respondsToSelector:nameSelector]) {
    
        title = [self performSelector:nameSelector];
    
    } else if ([self respondsToSelector:titleSelector]) {

        title = [self performSelector:titleSelector];

    } else if ([self respondsToSelector:valueSelector]) {

        title = [self performSelector:valueSelector];

    } else if ([self respondsToSelector:valueSelectorEn]
               && ([PGApp.app.locale isEqualToString:@"en"])) {

        title = [self performSelector:valueSelectorEn];

    } else if ([self respondsToSelector:valueSelectorGa]
                && ([PGApp.app.locale isEqualToString:@"ga"])) {

        title = [self performSelector:valueSelectorGa];

    } else if ([self respondsToSelector:nameSelectorEn]
               && [self respondsToSelector:nameSelectorGa]) {
        
        title = ([PGApp.app.locale isEqualToString:@"en"])
                    ? [self performSelector:nameSelectorEn]
                    : [self performSelector:nameSelectorGa];
    
    } else if ([self respondsToSelector:titleSelectorEn]
               && [self respondsToSelector:titleSelectorGa]) {
    
        title = ([PGApp.app.locale isEqualToString:@"en"])
                    ? [self performSelector:titleSelectorEn]
                    : [self performSelector:titleSelectorGa];
        
    } else {
        
        title = self.description;
    }

    if ([self respondsToSelector:aboutSelector]) {

        about = [self performSelector:aboutSelector];

    } else if ([self respondsToSelector:aboutSelectorEn]
               && [self respondsToSelector:aboutSelectorGA]) {

        about = ([PGApp.app.locale isEqualToString:@"en"])
                    ? [self performSelector:titleSelectorEn]
                    : [self performSelector:titleSelectorGa];

    } else {

        about = nil;

    }
#pragma clang diagnostic pop
    
    PGCellInfoWrapper *infoWrapper = [PGCellInfoWrapper cell:kPGCell
                                                        info:@{kPGCell_Title: title,
                                                               kPGCell_Detail: (about) ? about : [NSNull null]}];
    
    return infoWrapper;

}

- (PGCellInfoWrapper *)infoWrapperForPGVC:(PGVC *)pgvc {
    // Optionally implemented in subclass
    return [self infoWrapper];
}

- (NSArray *)details {

//    DDLogWarn(@"Should be implemented by subclass.");

    return @[];
}

- (BOOL)isPKSet {
    
    SEL pkSelector = NSSelectorFromString(PGApp.app.configs.apiPK);
    if (![self respondsToSelector:pkSelector]) return NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    NSNumber *pk = [self performSelector:pkSelector];
#pragma clang diagnostic pop
    return ![[self safePK:pk] isEqual:[NSNull null]];
}

#pragma mark - Safely add to JSON

- (id)safePK:(NSNumber *)pk {
    
    return (pk == nil
            || [pk integerValue] == 0)
            ? [NSNull null]
            : pk;
    
}

- (id)safeNumber:(NSNumber *)number {
    
    if (number == nil) return [NSNull null];
    return number;
    
}

- (id)safeDate:(NSDate *)date {
    
    return (date == nil)
            ? [NSNull null]
            : [PGApp.app.models.dateFormatter stringFromDate:date];
    
}

- (id)safeDateOnly:(NSDate *)date {
    
    return (date == nil)
    ? [NSNull null]
    : [PGApp.app.models.dateOnlyFormatter stringFromDate:date];
    
}

- (id)safeString:(NSString *)string {
    
    return (string == nil)
            ? [NSNull null]
            : string;
    
}

- (id)safeTime:(NSString *)time {
    
    if (time == nil
        || time.length != 5) return [NSNull null];
    
    return [NSString stringWithFormat:@"%@:00", time];
    
}

#pragma mark - Page Elements

- (void)addToDetails:(NSMutableArray **)details
           infoWrapper:(PGCellInfoWrapper *)info {
    
    if (info == nil) {
        
       return;
    }
    [*details addObject:info];
    
}

#pragma mark - Access

+ (instancetype)pk:(NSNumber *)pk {

    return [[self class] MR_findFirstByAttribute:@"pk" withValue:pk];

}

+ (instancetype)id:(NSNumber *)pk {

    return [[self class] MR_findFirstByAttribute:@"id" withValue:pk];

}

#pragma mark - Debugging

+ (NSString *)readableNameFromClass:(Class)clazz {

    NSString *name = [NSStringFromClass(clazz) stringByReplacingOccurrencesOfString:@"PG"
                                                                         withString:@""];
    NSRegularExpression *regexp = [NSRegularExpression
                                   regularExpressionWithPattern:@"([a-z])([A-Z])"
                                   options:0
                                   error:NULL];
    return [regexp
            stringByReplacingMatchesInString:name
            options:0
            range:NSMakeRange(0, name.length)
            withTemplate:@"$1 $2"];
}

@end
