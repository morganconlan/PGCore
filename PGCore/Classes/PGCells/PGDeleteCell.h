//
//  PGDeleteCell.h
//  pgcore
//
//  Created by Morgan Conlan on 09/07/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGSwipeCell.h"

@interface PGDeleteCell : PGSwipeCell

@property (nonatomic, strong) UIImage *inactiveDeleteIcon;
@property (nonatomic, strong) UIImage *activeDeleteIcon;
@property (nonatomic, strong) UIImageView *deleteGreyImageView;
@property (nonatomic, strong) UIImageView *deleteRedImageView;

@end
