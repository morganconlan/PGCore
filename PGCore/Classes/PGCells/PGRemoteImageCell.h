//
//  PGRemoteImageCell.h
//  pgcore
//
//  Created by Morgan Conlan on 30/04/2015.
//  Copyright (c) 2015 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCell.h"

extern NSString *const kPG_PGRemoteImageCell;
extern NSString *const kPGRemoteImage_IsPlaceholder;
extern NSString *const kPGRemoteImage_Placeholder;
extern NSString *const kPGRemoteImage_Center_Horizontally;
extern NSString *const kPGRemoteImage_Src;
extern NSString *const kPGRemoteImage_SrcW;
extern NSString *const kPGRemoteImage_SrcH;
extern NSString *const kPGRemoteImage_Tn;
extern NSString *const kPGRemoteImage_TnW;
extern NSString *const kPGRemoteImage_TnH;

@protocol PGRemoteImageDelegate;

@interface PGRemoteImageCell : PGCell

+ (PGCellInfoWrapper *)infoWrapperForImageDelegate:(id<PGRemoteImageDelegate>)delegate;
/**
 Creates a PGInfoWrapper from a PGRemoteImageDelegate.
 If the delegate doesn't exist, the placeholder image is used instead.
 The placeholder image should be a UIImage added to the placeholder dictionary with the kPGRemoteImage_Placeholder key.
 */
+ (PGCellInfoWrapper *)infoWrapperForImageDelegate:(id<PGRemoteImageDelegate>)delegate
                                   withPlaceholder:(NSDictionary *)placeholder;

@end

@protocol PGRemoteImageDelegate

- (NSString *)src;
- (NSNumber *)src_w;
- (NSNumber *)src_h;
- (NSString *)tn;
- (NSNumber *)tn_w;
- (NSNumber *)tn_h;

@optional
- (UIImage *)loadingImage;
- (NSString *)caption;
- (BOOL)withBorder;

@end
