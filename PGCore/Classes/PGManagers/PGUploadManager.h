//
//  PGUploadManager.h
//  pgcore
//
//  Created by Morgan Conlan on 04/08/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking/AFNetworkActivityIndicatorManager.h>

@interface PGUploadManager : NSObject

- (void)submitModelData:(id)data
                   path:(NSString *)path
                success:(void (^)(NSDictionary *responseData))success
                failure:(void (^)(void))failure;

- (void)deleteModelWithPK:(NSNumber *)pk
                     path:(NSString *)path
                  success:(void (^)(NSDictionary *responseData))success
                  failure:(void (^)(void))failure;

#warning //FIXME: reimplement to make compatible with AFNetworking 3.x (https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-3.0-Migration-Guide#afnetworking-3x-1)
//- (AFHTTPRequestOperation *)submitPhotoData:(NSData *)photoData
//              modelData:(NSDictionary *)modelData
//                   path:(NSString *)path
//               fileName:(NSString *)fileName
//                success:(void (^)(NSDictionary *responseData))successBlock
//                failure:(void (^)(void))failureBlock
//    uploadProgressBlock:(void (^)(NSUInteger __unused bytesWritten,
//                                  long long totalBytesWritten,
//                                  long long totalBytesExpectedToWrite))progressBlock;

@end
