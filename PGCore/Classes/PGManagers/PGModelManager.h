//
//  PGModelManager.h
//  pgcore
//
//  Created by Morgan Conlan on 07/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "PGApp.h"
#import <AFOAuth2Manager/AFOAuth2Manager.h>

@interface PGModelManager : NSObject

@property (nonatomic, strong) NSArray *entities;
@property (nonatomic, strong) NSMutableDictionary *entitiesMap;
@property (nonatomic, strong) NSMutableDictionary *entityAliases;
@property (nonatomic, strong) NSMutableDictionary *classAttributesMap;
@property (nonatomic, strong) NSMutableDictionary *loadedObjects;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) NSDateFormatter *dateOnlyFormatter;
@property (nonatomic, strong) NSNumberFormatter *numberFormatter;
@property (nonatomic, strong) NSManagedObjectContext *context;

#if DEBUG_API > 0
@property NSMutableDictionary *debugAttributes;
#endif

- (instancetype)initWithEntities:(NSArray *)entities;
- (void)loadObjects:(NSDictionary *)JSON
            success:(void (^)(void))success
            failure:(void (^)(void))failure;
- (void)reconcileUUIDsForManagedObjects:(NSSet *)objects withPKObjects:(NSArray *)pkObjects;
- (NSDictionary *)attributeMapForObject:(NSManagedObject *)object;

#pragma mark - Load with blocks
- (void)loadApiWithSuccess:(void (^)(void))success
                   failure:(void (^)(void))failure;
- (void)loadApiResource:(NSString *)resource
        withSuccess:(void (^)(void))success
            failure:(void (^)(void))failure;
- (void)loadUserApiWithSuccess:(void (^)(void))success
                       failure:(void (^)(void))failure;
- (void)loadExternalApiResource:(NSString *)resource
            withSuccess:(void (^)(void))success
                failure:(void (^)(void))failure;
@end
