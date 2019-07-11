//
//  PGModelManager.m
//  pgcore
//
//  Created by Morgan Conlan on 07/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGModelManager.h"
#import "NSManagedObject+Extras.h"


@interface PGModelManager ()

@end

@implementation PGModelManager

- (instancetype)initWithEntities:(NSArray *)entities {

	if ((self = [super init])) {

		_entities = entities;
		[self loadEntitiesMap];
		[self setupFormatters];
	}

	return self;
}

- (void)loadEntitiesMap {

	static dispatch_once_t once;
	dispatch_once(&once, ^
    {
      
        self.entitiesMap = [NSMutableDictionary dictionary];
        self.entityAliases = [NSMutableDictionary dictionary];
        self.classAttributesMap = [NSMutableDictionary dictionary];
        NSAssert(PGApp.app.configs.apiPK, @"\n\napiPK value must be set.\n");
        NSAssert(PGApp.app.configs.apiAppPK, @"\n\napiAppPK value must be set.\n");
        NSAssert(PGApp.app.configs.apiFK, @"\n\napiFK value must be set.\n");
      
      NSManagedObjectModel *model = [NSManagedObjectModel MR_defaultManagedObjectModel];
      for (NSEntityDescription *description in model.entities) {
          
          NSString *className = description.managedObjectClassName;
          NSString *classKey = description.userInfo[@"key"];

          if (description.userInfo[@"alias"]) {
              self.entityAliases[description.userInfo[@"alias"]] = classKey;
          }
          
          NSNumber *notifyModified = (description.userInfo[@"notifyModified"] != nil)
                                          ? @(YES)
                                          : @(NO);

          NSString *classKeyMessage = [NSString stringWithFormat:@"Entity \"%@\" must have a class key. Use 'skip' to ignore the entity during mapping", className];
          NSAssert(classKey, classKeyMessage);
          
          if ([classKey isEqualToString:@"skip"]) continue;

#if DEBUG_API > 0
              DDLogVerbose(@"entitymap: %@", classKey);
#endif

          self.classAttributesMap[className] = [self attributeMapForDescription:description];
          
          //Check for relationships
          if (description.relationshipsByName.count == 0) {
              self.entitiesMap[classKey] = @{@"className": className,
                                         @"notifyModified": notifyModified};
              continue;
          }
          
          NSMutableDictionary *entityMap = [NSMutableDictionary dictionary];
          entityMap[@"className"] = className;
          entityMap[@"notifyModified"] = notifyModified;
          
          NSMutableArray *toOnes = [NSMutableArray array];
          
          NSEnumerator *relationshipEnumerator = [description.relationshipsByName keyEnumerator];
          NSString *relationshipKey;
          
          while ((relationshipKey = [relationshipEnumerator nextObject])) {
              
              NSRelationshipDescription *relationship = description.relationshipsByName[relationshipKey];
              
              if (!relationship.isToMany) {
                  
                  NSDictionary *relationshipDict = [self toOneRelationship:relationship
                                                               description:description];
                  if (relationshipDict != nil) [toOnes addObject:relationshipDict];
              }
              
          }
          
          entityMap[@"toOnes"] = toOnes;
#if DEBUG_API > 1
          DDLogVerbose(@"toOnes: %@", toOnes);
#endif
          self.entitiesMap[classKey] = entityMap;
      }
      
    });

}

// Map keys property attributes to JSON in case schema doesn't match
- (NSDictionary *)attributeMapForDescription:(NSEntityDescription *)description {

    NSMutableDictionary *map = [NSMutableDictionary dictionary];

    for (NSPropertyDescription *property in description.properties) {

        // ignore relationships
        if (![property isKindOfClass:[NSAttributeDescription class]]) continue;

        // map app pk
        if ([property.name isEqualToString:PGApp.app.configs.apiAppPK]) {
            map[property.name] = PGApp.app.configs.apiPK;
            continue;
        }

        map[property.name] = (property.userInfo[@"key"])
                                ? (property.userInfo[@"key"])
                                : property.name;

    }

    return map;

}

- (NSDictionary *)attributeMapForObject:(NSManagedObject *)object {
    return _classAttributesMap[NSStringFromClass([object class])];
}

- (NSDictionary *)toOneRelationship:(NSRelationshipDescription *)relationship
                        description:(NSEntityDescription *)description {

    if (relationship == nil) {

        DDLogVerbose(@"Relationship nil: %@", description.description);
        return nil;
    }

	NSMutableDictionary *config = [NSMutableDictionary dictionary];
	NSString *relatedKey; //the key that will load the object from _loadedObjects
	NSString *valueKey; //the key that will load the value from the JSON object
	//Check for user info
	if (relationship.userInfo.count > 0) {

		if ([relationship.userInfo[@"key"] isEqualToString:@"skip"]) return nil;

		NSString *assertionErrorMessageRelated = [NSString stringWithFormat:@"related key for relationship %@ is unknown for entity: %@.", relationship.name, description.name];
		NSString *assertionErrorMessageValue = [NSString stringWithFormat:@"value key for relationship %@ is unknown for entity: %@.", relationship.name, description.name];
		NSAssert(relationship.userInfo[@"relatedKey"], assertionErrorMessageRelated);
		NSAssert(relationship.userInfo[@"valueKey"], assertionErrorMessageValue);

		relatedKey = relationship.userInfo[@"relatedKey"];
		valueKey = relationship.userInfo[@"valueKey"];

	} else { //Check for value in description following naming convention

		valueKey = [NSString stringWithFormat:@"%@%@", relationship.name, PGApp.app.configs.apiFK];
        NSString *attributeValueKey = [NSString stringWithFormat:@"%@%@", relationship.name, PGApp.app.configs.apiFK];
		NSString *assertionErrorMessage = [NSString stringWithFormat:@"value key for relationship %@ is unknown for entity: %@.", relationship.name, description.name];
		NSAssert(description.attributesByName[attributeValueKey], assertionErrorMessage);

		relatedKey = relationship.name;

	}

	// TODO: Assert that the related key exists
	//NSString *relatedKeyErrorMessage = [NSString stringWithFormat:@"related key for relationship %@ is doesn't exist for entity: %@.", relationship.name, description.name];

	config[@"relatedKey"] = relatedKey;
	config[@"valueKey"] = valueKey;
	config[@"selector"] = [NSString stringWithFormat:@"set%@:", [relationship.name capitalizedString]];
	config[@"inverseName"] = relationship.inverseRelationship.name;

	return config;
}

- (void)setupFormatters {

	_dateFormatter = [[NSDateFormatter alloc] init];
	[_dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss+0000"];
	[_dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSLocale *twentyFour = [[NSLocale alloc] initWithLocaleIdentifier:@"en_GB"];
    [_dateFormatter setLocale:twentyFour];
    
    _dateOnlyFormatter = [[NSDateFormatter alloc] init];
	[_dateOnlyFormatter setDateFormat:@"yyyy-MM-dd"];
	[_dateOnlyFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];

	_numberFormatter = [[NSNumberFormatter alloc] init];
	[_numberFormatter setNumberStyle:NSNumberFormatterScientificStyle];

}

- (void)loadObjects:(NSDictionary *)JSON
            success:(void (^)(void))success
            failure:(void (^)(void))failure {

    if (JSON[@"timestamp"]) [PGApp.app setObject:JSON[@"timestamp"]
                                          forKey:kPG_APP_Timestamp];

    NSManagedObjectContext *context = [NSManagedObjectContext MR_defaultContext];

    [self loadExistingObjectsInContext:context];

    BOOL objectsEmpty = NO;
    BOOL deletionsEmpty = NO;

    if (JSON[@"objects"] != nil) [self loadJSONObjects:JSON[@"objects"]
                                             inContext:context];
    objectsEmpty = ([JSON[@"objects"] count] == 0);

    if (JSON[@"deletions"] != nil) [self loadJSONDeletions:JSON[@"deletions"]
                                                 inContext:context];
    deletionsEmpty = ([JSON[@"deletions"] count] == 0);

    [context MR_saveToPersistentStoreWithCompletion:^(BOOL contextDidSave, NSError *error) {

        if (contextDidSave) {

            DDLogInfo(@"Models saved.");
            if (success != nil) success();

        } else if (error) {

            DDLogError(@"Error saving context: %@", error.description);
            if (failure != nil) failure();
            
        } else {

            DDLogVerbose(@"-- loaded API resource without change -- ");
            if (success != nil) success();

        }

    }];

	// Update app strings
	if (JSON[@"appstrings"] != nil)
		[PGApp.app.strings updateStrings:JSON[@"appstrings"]];

	[PGApp.app.menu reloadTable];

	PGApp.app.loadedJSON = YES;

    if (objectsEmpty && deletionsEmpty && success != nil) success();

}

/**
 * Loop over existing entities and load existing models
 */
- (void)loadExistingObjectsInContext:(NSManagedObjectContext *)context {

	_loadedObjects = [NSMutableDictionary dictionary];

	NSEnumerator *modelEnumerator = [_entitiesMap keyEnumerator];
	NSString *modelMapKey;

	while ((modelMapKey = [modelEnumerator nextObject])) {

		NSMutableDictionary *modelsById = [NSMutableDictionary dictionary];
		Class modelClass = NSClassFromString(_entitiesMap[modelMapKey][@"className"]);

		NSArray *models = [modelClass MR_findAllInContext:context];

		for (NSManagedObject *model in models) {
            
			NSString *modelPKAsString = [[model valueForKey:PGApp.app.configs.apiAppPK] stringValue];
			modelsById[modelPKAsString] = model;
		}

		_loadedObjects[modelMapKey] = modelsById;
	}

}

- (void)loadJSONObjects:(NSDictionary *)JSON
              inContext:(NSManagedObjectContext *)context {

	NSEnumerator *jsonModelEnumerator = [JSON keyEnumerator];
	NSString *modelMapKey;

	while ((modelMapKey = [jsonModelEnumerator nextObject])) {

		// ignore objects we don't know to deal with
		if (_entitiesMap[modelMapKey] == nil) {
#if DEBUG_API > 0
                DDLogWarn(@"unknown key: %@", modelMapKey);
#endif
			continue;
		}
#if DEBUG_API > 0
		DDLogVerbose(@"loading: %@", modelMapKey);
#endif
		//Only interested in array of objects to parse
		if ([JSON[modelMapKey] isKindOfClass:[NSArray class]])
			[self parseJSONModel:JSON[modelMapKey]
                         withKey:modelMapKey
                       inContext:context];
        else {

#if DEBUG_API > 0
            DDLogVerbose(@"not array for key: %@", modelMapKey);
#endif
        }

	}

	jsonModelEnumerator = [JSON keyEnumerator];

	while ((modelMapKey = [jsonModelEnumerator nextObject])) {

		// ignore objects we don't know to deal with
		if (_entitiesMap[modelMapKey] == nil) continue;

		//Only interested in array of objects to parse
		if ([JSON[modelMapKey] isKindOfClass:[NSArray class]])
			[self parseJSONModelRelationShips:JSON[modelMapKey]
			 withKey:modelMapKey];

	}

}

// map the attributes
- (void)parseJSONModel:(NSArray *)jsonModels
               withKey:(NSString *)key
             inContext:(NSManagedObjectContext *)context {

	Class modelClass = NSClassFromString(_entitiesMap[key][@"className"]);
	BOOL notifyModified = [_entitiesMap[key][@"notifyModified"] boolValue];

	for (NSDictionary* jsonModel in jsonModels) {

		if (![jsonModel isKindOfClass:[NSDictionary class]]) {

#if DEBUG_API > 0
                DDLogError(@"expecting a dictionary: %@", key);
#endif
            continue;

		}

		if (jsonModel[PGApp.app.configs.apiPK] == nil) {

#if DEBUG_API > 0
                DDLogError(@"pk missing: %@", key);
#endif
			continue;
		}

		//convert pk to string, same as _loadedObjects' keys
		NSString *pk = [NSString stringWithFormat:@"%@", (NSNumber *)jsonModel[PGApp.app.configs.apiPK]];
		//Every model must have a primary key
		if (pk == nil) continue;

		NSManagedObject *modelInstance = _loadedObjects[key][pk];
		BOOL isModified = YES;
		if (modelInstance == nil) {
			//DDLogVerbose(@"existing %@ not found with pk:%@", key, pk);
            modelInstance = [modelClass MR_createEntityInContext:context];
			isModified = NO;
		}

		[modelInstance safeSetValuesForKeysWithDictionary:jsonModel
                                                relations:nil
                                            dateFormatter:_dateFormatter
                                          numberFormatter:_numberFormatter];

		if (notifyModified && isModified) [modelInstance setValue:@(YES)
			                           forKey:@"is_modified"];

		_loadedObjects[key][pk] = modelInstance;

	}

}

// set the relationships
- (void)parseJSONModelRelationShips:(NSArray *)jsonModels
        withKey:(NSString *)key {

	NSArray *toOnes = _entitiesMap[key][@"toOnes"];

	if (toOnes == nil
	    || toOnes.count == 0) return;

    NSString *modelClassName = _entitiesMap[key][@"className"];

	for (NSDictionary* jsonModel in jsonModels) {

		//convert pk to string, same as _loadedObjects' keys
		NSString *pk = [NSString stringWithFormat:@"%@", (NSNumber *)jsonModel[PGApp.app.configs.apiPK]];
		//Every model must have a primary key
		if (pk == nil) continue;

		NSManagedObject *modelInstance = _loadedObjects[key][pk];

		for (NSDictionary *toOne in toOnes) {

            NSString *jsonModelRelatedModelPkKey = _classAttributesMap[modelClassName][toOne[@"valueKey"]];
			NSString *relatedModelPK = [NSString stringWithFormat:@"%@", (NSNumber *)jsonModel[jsonModelRelatedModelPkKey]];

            NSString *relatedKey;
            if (_loadedObjects[toOne[@"relatedKey"]] != nil) {

                relatedKey = toOne[@"relatedKey"];

            } else if (self.entityAliases[toOne[@"relatedKey"]] != nil){

                relatedKey = self.entityAliases[toOne[@"relatedKey"]];
#if DEBUG_API > 2
                DDLogVerbose(@"renaming related key: %@ -> %@", toOne[@"relatedKey"], relatedKey);
#endif
            } else {

                relatedKey = nil;

            }


			if (relatedModelPK == nil //check that the related model pk is set
			    || [relatedModelPK isEqualToString:@"0"] //check that it has a non-zero value
                || relatedKey == nil
			    || _loadedObjects[relatedKey] == nil // check that related model exists
			    || _loadedObjects[relatedKey][relatedModelPK] == nil) {

#if DEBUG_API > 2

                DDLogDebug(@"\"%@:%@\" the pk: %@ for the relatedKey: %@ has not been found. Ensure that the related key is the same as the json key!",
                           modelClassName,
                           pk,
                           relatedModelPK,
                           relatedKey);
#endif

				// Setting the relation to nil
				[modelInstance performSelector:NSSelectorFromString(toOne[@"selector"])
                                    withObject:nil];

			} else { // Everything's ok, so set the relationship

				NSManagedObject *relatedModel = _loadedObjects[relatedKey][relatedModelPK];

				[modelInstance performSelector:NSSelectorFromString(toOne[@"selector"])
                                    withObject:relatedModel];
                if (!toOne[@"valueKey"]) {

                    // Add to inverse relation (should be a to-many)
                    @try {
                        NSMutableSet *inverseRelationSet = [relatedModel  mutableSetValueForKey:toOne[@"inverseName"]];
                        if (inverseRelationSet != nil) [inverseRelationSet addObject:modelInstance];
                    }

                    @catch (NSException *exception) {
#if DEBUG_API > 0
                        DDLogError(@"inverse relation %@ doesn't exist for %@", toOne[@"inverseName"], key);
#endif
                    }

                    @finally {
                        
                    }

                } else {

                    SEL addToRelated = NSSelectorFromString(toOne[@"selector"]);
                    [modelInstance performSelector:addToRelated
                                        withObject:relatedModel];

                }


			}


		}

	}

}

/**
 *  Delete objects from Core Data given dictionary of ids mapped by model key
 *
 *  @param deletions Dictionary of arrays
 */
- (void)loadJSONDeletions:(NSDictionary *)deletions
                inContext:(NSManagedObjectContext *)context {

	if (deletions == nil
	    || ![deletions isKindOfClass:[NSDictionary class]]) {

#if DEBUG_API > 0
            DDLogDebug(@"expecting a dictionary:");
#endif
        return;

	}

	NSEnumerator *jsonModelEnumerator = [deletions keyEnumerator];
	NSString *modelMapKey;

	while ((modelMapKey = [jsonModelEnumerator nextObject])) {

		// ignore objects we don't know to deal with
		if (_entitiesMap[modelMapKey] == nil) {

#if DEBUG_API > 0
                DDLogWarn(@"unknown key: %@", modelMapKey);
#endif
			continue;
		}

		//Only interested in array of objects to parse
		if ([deletions[modelMapKey] isKindOfClass:[NSArray class]]) {

			//Class modelClass = NSClassFromString(_entitiesMap[modelMapKey][@"className"]);

			for (NSNumber *pkAsNumber in deletions[modelMapKey]) {
				NSString *pk = [NSString stringWithFormat:@"%@", pkAsNumber];

#if DEBUG_API > 0
                DDLogVerbose(@"deleting from: %@ -> %@", modelMapKey, pk);
#endif
				NSManagedObject *modelInstance = _loadedObjects[modelMapKey][pk];
				if (modelInstance == nil) continue;

				[_loadedObjects[modelMapKey] removeObjectForKey:pk];
				[modelInstance MR_deleteEntityInContext:context];
			}
		}



	}

}

/**
 *  Load all objects from Portal
 *
 *  @param success Block performed on success
 *  @param failure Block performed on failure
 */
- (void)loadApiWithSuccess:(void (^)(void))success
        failure:(void (^)(void))failure {

    [self loadApiResource:@""
              withSuccess:success
                  failure:failure];

}

- (void)loadApiResource:(NSString *)resource
            withSuccess:(void (^)(void))success
                failure:(void (^)(void))failure {

    NSString *apiVersion = (PGApp.app.configs.apiVersion == nil)
                            ? @"/"
                            : [NSString stringWithFormat:@"/%@/", PGApp.app.configs.apiVersion];

    if (resource.length > 0) { // check for trailing slash if resource is set
        if (![resource hasSuffix:@"/"]) resource = [resource stringByAppendingString:@"/"];
    } else {
        resource = @"";
    }

    NSString *string = [NSString stringWithFormat:@"%@/api%@%@?format=json&timestamp=%@&platform=iOS&platform_version=%@",
                        PGApp.app.configs.serverRoot,
                        apiVersion,
                        resource,
                        PGApp.app.appTimestamp,
                        [[UIDevice currentDevice] systemVersion]];

    [self loadExternalApiResource:string
                      withSuccess:success
                          failure:failure];

}

- (void)loadExternalApiResource:(NSString *)resource
        withSuccess:(void (^)(void))success
            failure:(void (^)(void))failure {

    DDLogVerbose(@"-- loading API resource -- ");

    NSURL *url = [NSURL URLWithString:resource];
    NSURLRequest *request = [NSURLRequest requestWithURL:url
                                             cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                         timeoutInterval:60.0f];

    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    [mutableRequest addValue:@"XMLHttpRequest" forHTTPHeaderField:@"X-Requested-With"];

    NSURL *URL = [NSURL URLWithString:resource];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:URL.absoluteString
      parameters:nil
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {

             NSDictionary *response = (NSDictionary *)responseObject;

             DDLogVerbose(@"-- loading API response -- ");

             [self loadObjects:response
                       success:success
                       failure:failure];

    } failure:^(NSURLSessionTask *operation, NSError *error) {

        if (failure != nil) failure();

    }];

//    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
//
//    operation.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//
//        NSDictionary *response = (NSDictionary *)responseObject;
//
//        DDLogVerbose(@"-- loading API response -- ");
//
//        [self loadObjects:response
//                  success:success
//                  failure:failure];
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        if (failure != nil) failure();
//
//    }];
//
//    [operation start];

}

/**
 *  Load all objects from Portal
 *
 *  @param success Block performed on success
 *  @param failure Block performed on failure
 */
- (void)loadUserApiWithSuccess:(void (^)(void))success
                   failure:(void (^)(void))failure {

    NSString *apiVersion = (PGApp.app.configs.apiVersion == nil)
                            ? @"/"
                            : [NSString stringWithFormat:@"/%@/", PGApp.app.configs.apiVersion];

    NSString *urlString = [NSString stringWithFormat:@"%@/api%@",
                           PGApp.app.configs.serverRoot,
                           apiVersion];
#if DEBUG_API > 1
    DDLogVerbose(@"%@", urlString);
#endif

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    if (PGApp.app.configs.clientIdentifier != nil) {

        AFHTTPRequestSerializer *serializer =  [AFJSONRequestSerializer serializer];
        AFOAuthCredential *credentials = [AFOAuthCredential retrieveCredentialWithIdentifier:PGApp.app.configs.clientIdentifier];
        [serializer setValue:[NSString stringWithFormat:@"Bearer %@", credentials.accessToken]
          forHTTPHeaderField:@"Authorization"];
        [serializer setValue:@"XMLHttpRequest"
          forHTTPHeaderField:@"X-Requested-With"];
        manager.requestSerializer = serializer;

    }

    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager GET:urlString
      parameters:@{@"format": @"json",
                   @"timestamp": PGApp.app.appTimestamp,
                   @"platform": @"iOS",
                   @"plaform_version": [[UIDevice currentDevice] systemVersion]
                   }
        progress:nil
         success:^(NSURLSessionTask *task, id responseObject) {

             NSDictionary *response = (NSDictionary *)responseObject;

             [self loadObjects:response
                       success:success
                       failure:failure];

         } failure:^(NSURLSessionTask *operation, NSError *error) {

             if (failure != nil) failure();

         }];
    
}

/**
 *  Given a set of managed objects, save pk from a portal api response
 *
 *  @param objects   An NSSet of managed objects
 *  @param pkObjects An array of dictionaries containing primary keys
 */
- (void)reconcileUUIDsForManagedObjects:(NSSet *)objects
                          withPKObjects:(NSArray *)pkObjects {
    
    if (objects == nil) {

#if DEBUG_API > 0
            DDLogWarn(@"no managed objects provided");
#endif
        return;

    }
    
    if (pkObjects == nil) {

#if DEBUG_API > 0
            DDLogWarn(@"no pkObjects provided");
#endif
        return;

    }
    
    NSMutableDictionary *uuidMap = [NSMutableDictionary dictionary];
    // populate the map using UUIDs as keys
    for (NSManagedObject *object in objects) {
        
        NSString *uuid = [object valueForKeyPath:@"uuid"];
        
        if (uuid == nil) {

#if DEBUG_API > 0
                DDLogWarn(@"no uuid for: %@", object);
#endif
            continue;
            
        }
        
        uuidMap[uuid] = object;
    }
    
    for (NSDictionary *pkObject in pkObjects) {
        
        NSNumber *pk = [pkObject valueForKeyPath:PGApp.app.configs.apiPK];
        NSString *uuid = [pkObject valueForKeyPath:@"uuid"];
        
        if (pk == nil) {

#if DEBUG_API > 0
                DDLogWarn(@"no pk for %@", pkObject);
#endif
            continue;
        }
        
        if (uuid == nil) {

#if DEBUG_API > 0
                DDLogWarn(@"no uuid for %@", pkObject);
#endif
            continue;

        }
        
        NSManagedObject *object = uuidMap[uuid];
        
        if (object == nil) {

#if DEBUG_API > 0
                DDLogWarn(@"uuid %@ not found in managed objects set", uuid);
#endif
            continue;
        }
        
        [object safeSetValuesForKeysWithDictionary:pkObject
                                         relations:nil
                                     dateFormatter:_dateFormatter
                                   numberFormatter:_numberFormatter];
        
    }
    
}

@end
