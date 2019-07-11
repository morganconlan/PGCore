//
//  PGCore.h
//  PGCore
//
//  Created by Morgan Conlan on 11/07/2019.
//  Copyright © 2019 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for PGCore.
FOUNDATION_EXPORT double PGCoreVersionNumber;

//! Project version string for PGCore.
FOUNDATION_EXPORT const unsigned char PGCoreVersionString[];

#import "PGConstants.h"
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import <MagicalRecord/MagicalRecord.h>
//#import <MagicalRecord/CoreData+MagicalRecord.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import <AFNetworking/AFNetworking.h>
#import <AFNetworkActivityLogger/AFNetworkActivityLogger.h>
#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import "PGCategories.H"
#import "PGApp.h"
#import "PGVendorImports.h"
#import "PGVCImports.h"
#import "PGCellImports.h"


#ifndef ddLogLevel
#if DEBUG
static const int ddLogLevel = DDLogLevelVerbose;
#else
static const int ddLogLevel = DDLogLevelInfo;
#endif //DEBUG
#endif //ddLogLevel


