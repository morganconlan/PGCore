//
//  PGCellInfoWrapper.m
//  pgcore
//
//  Created by Morgan Conlan on 10/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGCellInfoWrapper.h"

#define imgIconEmail (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_email"]; \
        		NSAssert(image, @"Image icon_email not found"); \
        		return image; \
        }()

#define imgIconTel (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_tel"]; \
        		NSAssert(image, @"Image icon_tel not found"); \
        		return image; \
        }()

#define imgIconWeb (UIImage *)^{ \
        		UIImage *image = [UIImage imageNamed:@"icon_web"]; \
        		NSAssert(image, @"Image icon_web not found"); \
        		return image; \
        }()

@implementation PGCellInfoWrapper

- (instancetype)initWithId:(NSString *)identifier
                      info:(NSDictionary *)info {
    
    if ((self = [super init])) {
        
        _isSelectable = NO;
        _isPerformingSelectorWithModel = NO;
        _isShowingAccessory = NO;
        _isDividerDisabled = NO;
        _cellIdentifier = identifier;
        _info = [info mutableCopy];
        
    }
    
    return self;
}

- (void)setIsShowingAccessory:(BOOL)isShowingAccessory {
    _info[kPGCell_IsShowingAccessory] = @(isShowingAccessory);
    _isShowingAccessory = isShowingAccessory;
}

+ (PGCellInfoWrapper *)plainCell:(NSString *)title {
    
    if (title == nil) return nil;
    
    return [[PGCellInfoWrapper alloc] initWithId:kPG_Cell_Plain
                                            info:@{@"title": title}];
}

+ (PGCellInfoWrapper *)cell:(NSString *)identifier {
    
    return  [[PGCellInfoWrapper alloc] initWithId:identifier
                                             info:@{}];
}

+ (PGCellInfoWrapper *)cell:(NSString *)identifier info:(NSDictionary *)info {

    return [[PGCellInfoWrapper alloc] initWithId:identifier info:info];
}

+ (PGCellInfoWrapper *)email:(NSString *)email {
    
    PGCellInfoWrapper *emailInfo = [PGCellInfoWrapper cell:kPG_PGIconCell
                                   info:(email != nil
                                         && email.length > 0)
                                            ? @{@"title": @"Email",
                                                @"img": imgIconEmail,
                                                @"detail": email}
                                            : @{@"title": @"Email",
                                               @"img": imgIconEmail,
                                               @"detail": @"No email address set",
                                               @"is_not_set": @(YES)}];
    
    emailInfo.isSelectable = (email.length > 0);
    emailInfo.selector = @"didPressEmail:";
    emailInfo.object = (email != nil
                        && email.length > 0)
                        ? @[email] : nil;
    emailInfo.isShowingAccessory = (email.length > 0);
    
    return emailInfo;
}

+ (PGCellInfoWrapper *)tel:(NSString *)tel {
    
    PGCellInfoWrapper *telInfo = [PGCellInfoWrapper cell:kPG_PGIconCell
                                   info:(tel != nil
                                         && tel.length > 0)
                                            ? @{@"title": @"Telephone",
                                                @"img": imgIconTel,
                                                @"detail": tel}
                                            : @{@"title": @"Telephone",
                                               @"img": imgIconTel,
                                               @"detail": @"No telephone number set",
                                               @"is_not_set": @(YES)}];
    
    telInfo.isSelectable = (tel.length > 0);
    telInfo.selector = @"didPressTel:";
    telInfo.object = (tel != nil
                        && tel.length > 0)
                        ? @[tel] : nil;
    telInfo.isShowingAccessory = (tel.length > 0);
    
    return telInfo;
    
}

+ (PGCellInfoWrapper *)web:(NSString *)web {
    
    PGCellInfoWrapper *webInfo = [PGCellInfoWrapper cell:kPG_PGIconCell
                                   info:(web != nil
                                         && web.length > 0)
                                            ? @{@"title": @"Website",
                                                @"img": imgIconWeb,
                                                @"detail": web}
                                            : @{@"title": @"Website",
                                               @"img": imgIconEmail,
                                               @"detail": @"No website set",
                                               @"is_not_set": @(YES)}];
    
    webInfo.isSelectable = (web.length > 0);
    webInfo.selector = @"didPressWeb:";
    webInfo.object = (web != nil
                        && web.length > 0)
                        ? @[web] : nil;
    webInfo.isShowingAccessory = (web.length > 0);
    
    return webInfo;
    
}

- (void)addStringInfo:(NSString *)value
               forKey:(NSString *)key {
    
    if (value.length == 0
        || key == nil) return;
    
    
    self.info[key] = value;
}

- (void)addInfo:(id)value
         forKey:(NSString *)key {

    if (value == nil
        || key == nil) return;


    self.info[key] = value;
}

@end
