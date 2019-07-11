//
//  SCNetworkReachabilityFlagsParser.m
//  SCNetworkReachability
//
//  Created by Alexey Belkevich on 12/05/13
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "SCNetworkReachabilityFlagsParser.h"

@interface SCNetworkReachabilityFlagsParser ()

- (BOOL)isReachable;
#if TARGET_OS_IPHONE
- (BOOL)isCellular;
#endif

@end

@implementation SCNetworkReachabilityFlagsParser

#pragma mark -
#pragma mark main routine

- (id)initWithReachabilityFlags:(SCNetworkReachabilityFlags)aFlags
{
    self = [super init];
    if (self)
    {
        flags = aFlags;
#ifdef DEBUG
        NSLog(@"Reachability Flag Status: %c%c %c%c%c%c%c%c%c\n",
#if TARGET_OS_IPHONE
              (flags & kSCNetworkReachabilityFlagsIsWWAN) ? 'W' : '-',
#else
              '-',
#endif
              (flags & kSCNetworkReachabilityFlagsReachable) ? 'R' : '-',
              (flags & kSCNetworkReachabilityFlagsTransientConnection) ? 't' : '-',
              (flags & kSCNetworkReachabilityFlagsConnectionRequired) ? 'c' : '-',
              (flags & kSCNetworkReachabilityFlagsConnectionOnTraffic) ? 'C' : '-',
              (flags & kSCNetworkReachabilityFlagsInterventionRequired) ? 'i' : '-',
              (flags & kSCNetworkReachabilityFlagsConnectionOnDemand) ? 'D' : '-',
              (flags & kSCNetworkReachabilityFlagsIsLocalAddress) ? 'l' : '-',
              (flags & kSCNetworkReachabilityFlagsIsDirect) ? 'd' : '-');
#endif
    }
    return self;
}


#pragma mark -
#pragma mark actions

- (SCNetworkStatus)status
{
    if ([self isReachable])
    {
#if TARGET_OS_IPHONE
        return [self isCellular] ? SCNetworkStatusReachableViaCellular :
               SCNetworkStatusReachableViaWiFi;
#else
        return SCNetworkStatusReachable;
#endif
    }
    else
    {
        return SCNetworkStatusNotReachable;
    }
}

#pragma mark -
#pragma mark private

- (BOOL)isReachable
{
    return (flags & kSCNetworkReachabilityFlagsReachable) != 0;
}

#if TARGET_OS_IPHONE
- (BOOL)isCellular
{
    return (flags & kSCNetworkReachabilityFlagsIsWWAN) != 0;
}
#endif

@end
