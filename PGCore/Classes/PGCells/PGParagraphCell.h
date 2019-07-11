//
//  PGParagraphCell.h
//  pgcore
//
//  Created by Morgan Conlan on 24/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCell.h"

extern NSString *const kPG_Paragraph_Bold_Tag;
extern NSString *const kPG_Paragraph_Padding_Horizontal;
extern NSString *const kPG_Paragraph_Padding_Vertical;
extern NSString *const kPG_Paragraph_IsCentered;

@interface PGParagraphCell : PGCell

@property (nonatomic, strong) UILabel *lbl;

@end
