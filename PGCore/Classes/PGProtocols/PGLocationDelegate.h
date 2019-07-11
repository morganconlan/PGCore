//
//  PGLocationProtocol.h
//  pgcore
//
//  Created by Morgan Conlan on 26/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGLocationDelegate

@required

- (double)pglatitude;
- (double)pglongitude;
- (NSString *)name;

@optional

- (NSString *)address;
- (UIImageView *)thumbnail;
- (UIImage *)annotationImage;

@end
