//
//  PGLineNumberLogFormatter.h
//  pgcore
//
//  Created by Morgan Conlan on 02/02/2016.
//  Copyright © 2016 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CocoaLumberjack/CocoaLumberjack.h>

@interface PGLineNumberLogFormatter : NSObject<DDLogFormatter>

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage;

@end
