//
//  PGUploadManager.m
//  pgcore
//
//  Created by Morgan Conlan on 04/08/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGApp.h"
#import "PGUploadManager.h"
#import <AFOAuth2Manager/AFOAuth2Manager.h>

@implementation PGUploadManager

- (instancetype)init {
    
    if ((self = [super init])) {
        
        [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
        
    }
    
    return self;
}

- (void)submitModelData:(id)data
                   path:(NSString *)path
                success:(void (^)(NSDictionary *responseData))success
                failure:(void (^)(void))failure {
    
    AFOAuthCredential *credentials = [AFOAuthCredential retrieveCredentialWithIdentifier:PGApp.app.configs.clientIdentifier];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *serializer =  [AFJSONRequestSerializer serializer];
    [serializer setValue:[NSString stringWithFormat:@"Bearer %@", credentials.accessToken]
      forHTTPHeaderField:@"Authorization"];
    [serializer setValue:@"XMLHttpRequest"
      forHTTPHeaderField:@"X-Requested-With"];
    manager.requestSerializer = serializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

    [manager POST:path
       parameters:data
         progress:^(NSProgress * _Nonnull uploadProgress) {

           // TODO: pass progress as an argmument

       } success:^(NSURLSessionDataTask * _Nonnull task,
                   id  _Nullable responseObject) {

           if (success != nil) success((NSDictionary *)responseObject);

       } failure:^(NSURLSessionDataTask * _Nullable task,
                   NSError * _Nonnull error) {

           if (failure != nil) failure();
           DDLogWarn(@"%@", error.localizedDescription);

       }];
}

- (void)deleteModelWithPK:(NSNumber *)pk
                     path:(NSString *)path
                  success:(void (^)(NSDictionary *))success
                  failure:(void (^)(void))failure {
    
    AFOAuthCredential *credentials = [AFOAuthCredential retrieveCredentialWithIdentifier:PGApp.app.configs.clientIdentifier];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    AFHTTPRequestSerializer *serializer =  [AFJSONRequestSerializer serializer];
    [serializer setValue:[NSString stringWithFormat:@"Bearer %@", credentials.accessToken]
      forHTTPHeaderField:@"Authorization"];
    [serializer setValue:@"XMLHttpRequest"
      forHTTPHeaderField:@"X-Requested-With"];

    manager.requestSerializer = serializer;
    manager.responseSerializer = [AFJSONResponseSerializer serializer];

#warning //FIXME: what if this is "id"?
    [manager POST:path
       parameters:@{@"pk":pk}
         progress:^(NSProgress * _Nonnull uploadProgress) {

             // TODO: pass progress as an argmument

         } success:^(NSURLSessionDataTask * _Nonnull task,
                     id  _Nullable responseObject) {

             if (success != nil) success((NSDictionary *)responseObject);

         } failure:^(NSURLSessionDataTask * _Nullable task,
                     NSError * _Nonnull error) {

             if (failure != nil) failure();
             DDLogWarn(@"%@", error.localizedDescription);

         }];
    
}

#warning //FIXME: see header
//- (AFHTTPRequestOperation *)submitPhotoData:(NSData *)photoData
//              modelData:(NSDictionary *)modelData
//                   path:(NSString *)path
//               fileName:(NSString *)fileName
//                success:(void (^)(NSDictionary *responseData))successBlock
//                failure:(void (^)(void))failureBlock
//    uploadProgressBlock:(void (^)(NSUInteger __unused bytesWritten,
//                                  long long totalBytesWritten,
//                                  long long totalBytesExpectedToWrite))progressBlock {
//
//    AFOAuthCredential *credentials = [AFOAuthCredential retrieveCredentialWithIdentifier:PGApp.app.configs.clientIdentifier];
//
//    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//    AFHTTPRequestSerializer *serializer =  [AFJSONRequestSerializer serializer];
//    [serializer setValue:[NSString stringWithFormat:@"Bearer %@", credentials.accessToken]
//      forHTTPHeaderField:@"Authorization"];
//
//    NSError *error;
//
//    NSMutableURLRequest *request =
//        [serializer multipartFormRequestWithMethod:@"POST"
//                                         URLString:path
//                                        parameters:modelData
//                         constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
//    {
//
//         [formData appendPartWithFileData:photoData
//                                     name:@"photo"
//                                 fileName:fileName
//                                 mimeType:@"image/jpeg"];
//
//
//    } error:&error];
//
//
//
//    manager.requestSerializer = serializer;
//    manager.responseSerializer = [AFJSONResponseSerializer serializer];
//
//    AFHTTPRequestOperation *operation =
//     [manager HTTPRequestOperationWithRequest:request
//                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//                                          DDLogInfo(@"Sucess: %@", responseObject);
//                                          if (successBlock != nil) successBlock((NSDictionary *)responseObject);
//
//                                      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//                                          if (failureBlock != nil) failureBlock();
//                                          DDLogWarn(@"%@", error.localizedDescription);
//
//                                      }];
//
//    if (progressBlock != nil) {
//        [operation setUploadProgressBlock:progressBlock];
//    }
//
//    [operation start];
//
//    return operation;
//}

@end
