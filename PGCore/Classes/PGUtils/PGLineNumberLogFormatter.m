//
//  PGLineNumberLogFormatter.m
//  pgcore
//
//  Created by Morgan Conlan on 02/02/2016.
//  Copyright © 2016 Morgan Conlan. All rights reserved.
//

#import "PGLineNumberLogFormatter.h"
#import <CocoaLumberjack/CocoaLumberjack.h>

@implementation PGLineNumberLogFormatter

- (NSString *)formatLogMessage:(DDLogMessage *)logMessage {

    NSString *fileName = [logMessage.file lastPathComponent];
    return [NSString stringWithFormat:@"%@:%d %@", fileName, logMessage.line, logMessage.message];

}

@end
