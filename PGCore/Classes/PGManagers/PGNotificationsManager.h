//
//  PGNotificationsManager.h
//  pgcore
//
//  Created by Morgan Conlan on 01/03/2016.
//  Copyright © 2016 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGApp.h"

@protocol PGNotificationsDelegate <NSObject>
@optional

- (void)tokenRegistrationDidFailWithError:(NSError *)error;
- (void)tokenUnregistrationDidFailWithError:(NSError *)error;
- (void)subscribeDidFailWithError:(NSError *)error;
- (void)unsubscribeDidFailWithError:(NSError *)error;
- (void)setBadgeDidFailWithError:(NSError *)error;

@end

@interface PGNotificationsManager : NSObject

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, strong)NSString *deviceToken;

@property (nonatomic, weak) id<PGNotificationsDelegate> delegate;

/**
 * Get the shared ZeroPush instance
 */
+ (PGNotificationsManager *)shared;

/**
 * Set the shared ZeroPush instance's apiKey
 */
+ (void)engageWithAPIKey:(NSString *)apiKey;

/**
 * Set the shared ZeroPush instance's apiKey and specify a ZeroPushDelegate
 */
+ (void)engageWithAPIKey:(NSString *)apiKey delegate:(id<PGNotificationsDelegate>)delegate;

/**
 * Parse a device token given the raw data returned by Apple from registering for notifications
 */
+ (NSString *)deviceTokenFromData:(NSData *)tokenData;

/**
 * A convenience wrapper for [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
 * deprecated in iOS7
 */
- (void)registerForRemoteNotificationTypes:(UIRemoteNotificationType)types NS_DEPRECATED_IOS(3_0, 8_0, "Please use registerForRemoteNotifications instead");

/**
 * Preferred method for registering for notifications. Backwards compatible with iOS7
 */
- (void)registerForRemoteNotifications;

/**
 * Register the device's token with ZeroPush
 */
- (void)registerDeviceToken:(NSData *)deviceToken;

/**
 * Register the device's token with ZeroPush and subscribe the device's token to a broadcast channel
 */
- (void)registerDeviceToken:(NSData *)deviceToken channel:(NSString *)channel;

/**
 * Unregister the previously registered device token from ZeroPush
 */
- (void)unregisterDeviceToken;

/**
 * Subscribe the device's token to a broadcast channel
 */
- (void)subscribeToChannel:(NSString *)channel;

/**
 * Unsubscribe the device's token from a broadcast channel
 */
- (void)unsubscribeFromChannel:(NSString *)channel;

- (void)unsubscribeFromAllChannels;


- (void)getDevice:(void (^)(NSDictionary *device, NSError *error)) callback;

/**
 * return a list of all the channels to which the device is subscribed
 */
- (void)getChannels:(void (^)(NSArray *channels, NSError *error)) callback;
/**
 * set a list of the channels to which a device is subscribed
 */
- (void)setChannels:(NSArray*)channels;

/**
 * Set the device's badge number to the given value
 */
- (void)setBadge:(NSInteger)badge;

/**
 * Set the device's badge number to zero
 */
- (void)resetBadge;

@end
