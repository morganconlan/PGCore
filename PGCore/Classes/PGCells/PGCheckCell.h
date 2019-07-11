//
//  PGCheckCell.h
//  pgcore
//
//  Created by Morgan Conlan on 09/07/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGSwipeCell.h"

@interface PGCheckCell : PGSwipeCell

@property (nonatomic, strong) UIImage *inactiveCheckIcon;
@property (nonatomic, strong) UIImage *activeCheckIcon;
@property (nonatomic, strong) UIImage *selectedCheckIcon;
@property (nonatomic, strong) UIImageView *checkmarkGreyImageView;
@property (nonatomic, strong) UIImageView *checkmarkGreenImageView;
@property (nonatomic, strong) UIImageView *checkmarkItemImageView;

@property (nonatomic, assign) BOOL isChecked;

- (void)setChecked:(BOOL)checked
          animated:(BOOL)animated;

@end
