//
//  PGImageCell.m
//  pgcore
//
//  Created by Morgan Conlan on 30/04/2015.
//  Copyright (c) 2015 Morgan Conlan. All rights reserved.
//

#import "PGRemoteImageCell.h"
#import "RemoteImageView.h"
//#import <FXBlurView/FXBlurView.h>

NSString *const kPG_PGRemoteImageCell = @"PGRemoteImageCell";
NSString *const kPGRemoteImage_IsPlaceholder = @"is_placeholder";
NSString *const kPGRemoteImage_Placeholder = @"placeholder";
NSString *const kPGRemoteImage_Center_Horizontally = @"centre_horizontally";
NSString *const kPGRemoteImage_Src = @"src";
NSString *const kPGRemoteImage_SrcW = @"src_w";
NSString *const kPGRemoteImage_SrcH = @"src_h";
NSString *const kPGRemoteImage_Tn = @"tn";
NSString *const kPGRemoteImage_TnW = @"tn_w";
NSString *const kPGRemoteImage_TnH = @"tn_h";

@interface PGRemoteImageCell()

@property (nonatomic, strong) RemoteImageView *image;

@end

@implementation PGRemoteImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {

    if ((self = [super initWithStyle:style
                     reuseIdentifier:kPG_PGRemoteImageCell])) {

        _image = [[RemoteImageView alloc] init];
        [self.contentView addSubview:_image];

    }

    return self;
}

+ (PGCellInfoWrapper *)infoWrapperForImageDelegate:(id<PGRemoteImageDelegate>)delegate {

    NSMutableDictionary *info = [NSMutableDictionary dictionary];

    info[kPGRemoteImage_IsPlaceholder] = @(NO);
    info[kPGRemoteImage_Src] = delegate.src;
    info[kPGRemoteImage_SrcW] = delegate.src_w;
    info[kPGRemoteImage_SrcH] = delegate.src_h;
    info[kPGRemoteImage_Tn] = delegate.tn;
    info[kPGRemoteImage_TnW] = delegate.tn_w;
    info[kPGRemoteImage_TnH] = delegate.tn_h;

    return [PGCellInfoWrapper cell:kPG_PGRemoteImageCell
                              info:info];

}

+ (PGCellInfoWrapper *)infoWrapperForImageDelegate:(id<PGRemoteImageDelegate>)delegate
                                   withPlaceholder:(NSDictionary *)placeholder {

    if (delegate != nil) return [PGRemoteImageCell infoWrapperForImageDelegate:delegate];

    NSMutableDictionary *info = [NSMutableDictionary dictionary];

    UIImage *placeholderImage = placeholder[kPGRemoteImage_Placeholder];

    info[kPGRemoteImage_IsPlaceholder] = @(YES);
    info[kPGRemoteImage_Placeholder] = placeholderImage;
    info[kPGRemoteImage_SrcW] = [NSNumber numberWithFloat:placeholderImage.size.width];
    info[kPGRemoteImage_SrcH] = [NSNumber numberWithFloat:placeholderImage.size.height];

    if (placeholder[kPGRemoteImage_Center_Horizontally])
        info[kPGRemoteImage_Center_Horizontally] = placeholder[kPGRemoteImage_Center_Horizontally];


    return [PGCellInfoWrapper cell:kPG_PGRemoteImageCell
                              info:info];
    
}

+ (CGFloat)heightWithCellInfo:(NSDictionary *)info {

    CGFloat padding = 0;

    if (info[@"padding"] != nil) padding += 10.0f;

    return [PGRemoteImageCell frameForImageWithInfo:info].size.height + padding;
}

+ (CGRect)frameForImageWithInfo:(NSDictionary *)info {

    CGFloat insetLeft, insetTop, width, height;

    BOOL isPlaceholder = [info[kPGRemoteImage_IsPlaceholder] boolValue];

    width = [info[kPGRemoteImage_SrcW] floatValue];
    height = [info[kPGRemoteImage_SrcH] floatValue];

    insetLeft = 0.0f;
    insetTop = 0.0f;

    if (isPlaceholder
        && ![info[kPGRemoteImage_Center_Horizontally] boolValue])
        return CGRectMake(insetLeft, insetTop, width, height);

    // Try to fill width
    insetLeft =  (width < [info[kPGCell_DelegateWidth] floatValue])
                    ? (([info[kPGCell_DelegateWidth] floatValue] - width) / 2)
                    : 0;

    if (info[@"align"] != nil) {
        insetLeft = 10.0f;
    }

    if (width > [info[kPGCell_DelegateWidth] floatValue]) {

        CGFloat ratio = width / [info[kPGCell_DelegateWidth] floatValue];
        height /= ratio;
        width = [info[kPGCell_DelegateWidth] floatValue];

    }

    if (info[@"padding"] != nil) {
        insetTop = 10.0f;
    }

    return CGRectMake(insetLeft, insetTop, width, height);
}

- (void)updateCellInfo:(NSMutableDictionary *)info {

    self.info = info;

    if ([info[kPGRemoteImage_IsPlaceholder] boolValue]) {

        [_image setImage:self.info[kPGRemoteImage_Placeholder]];
        [_image setContentMode:UIViewContentModeScaleAspectFill];

    } else {

        NSString *urlString;

        // Check if src is already formed
        if ([self.info[kPGRemoteImage_Src] rangeOfString:PGApp.app.configs.s3assetsRoot].location != NSNotFound
            || [self.info[kPGRemoteImage_Src] rangeOfString:@"http://"].location != NSNotFound
            || [self.info[kPGRemoteImage_Src] rangeOfString:@"https://"].location != NSNotFound) {

            urlString = self.info[kPGRemoteImage_Src];

        } else {

            urlString = [NSString stringWithFormat:@"%@%@",
                         PGApp.app.configs.s3assetsRoot,
                         self.info[kPGRemoteImage_Src]];

        }

        DDLogVerbose(@"%@", urlString);
        [_image setImageURL:[NSURL URLWithString:urlString]];

    }
}

- (void)layoutSubviews {

    [_image setFrame:[PGRemoteImageCell frameForImageWithInfo:self.info]];
}


@end
