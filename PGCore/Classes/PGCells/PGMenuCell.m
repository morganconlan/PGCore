//
//  PGMenuCell.m
//  pgcore
//
//  Created by Morgan Conlan on 06/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGMenuCell.h"

@interface PGMenuCell()

@property (nonatomic, strong) UIImageView *icon;

@end

@implementation PGMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier {
    
    if ((self = [super initWithStyle:style
                     reuseIdentifier:kPG_Cell_Menu])) {
        
        self.opaque = YES;
        
        if (PGApp.app.configs.isMenuDividerEnabled) {
        
            [self.divider setBackgroundColor:[PGApp.app colour:kPG_Colour_Menu_Background_Selected]];
            [self.contentView addSubview:self.divider];
        }
        
        if (PGApp.app.configs.isMenuIconsEnabled) {
        
            self.icon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_competitor"]];
            [self.contentView addSubview:_icon];
        }
        
    }
    
    return self;
}

- (void)updateCellInfo:(NSMutableDictionary*)info {
    
    self.info = info;

    if (PGApp.app.configs.isMenuIconsEnabled)
        [self.icon setImage:[UIImage imageNamed:self.info[@"img"]]];
    
    [self.contentView setBackgroundColor:[UIColor whiteColor]];
    [self setNeedsDisplay];
    
}

- (void)layoutSubviews {

    [self.divider setFrame:(PGApp.app.configs.isMenuDividerEnabled)
                            ? CGRectMake(0, self.bounds.size.height - 1, self.bounds.size.width - 40, 1)
                            : CGRectZero];

    if (PGApp.app.configs.isMenuIconsEnabled)
        [_icon setFrame:CGRectMake(5,
                                   (self.bounds.size.height - _icon.image.size.height) / 2,
                                   _icon.image.size.width,
                                   _icon.image.size.height)];
    
}

+ (CGFloat)heightWithCellInfo:(NSDictionary *)info {
    
    return (PGApp.isiPad)
            ? (PGApp.app.configs.menuCellHeight * 1.5)
            : PGApp.app.configs.menuCellHeight;
    
}

- (void)drawContentView:(CGRect)rect {
    
    CGFloat useableWidth = [self.info[kPGCell_DelegateWidth] floatValue] - 40.0f;
    
    //Title
    NSString *title = self.info[@"title"];
    CGSize constraintSize = CGSizeMake(useableWidth, MAXFLOAT);
    CGSize titleSize = [title sizeWithFont:[PGApp.app font:kPG_Font_Menu]
                         constrainedToSize:constraintSize
                             lineBreakMode:NSLineBreakByWordWrapping];
    
    [(self.isSelected)
        ? [PGApp.app colour:kPG_Colour_Menu_Title_Selected]
        : [PGApp.app colour:kPG_Colour_Menu_Title] set];
    
    CGFloat insetLeft = (PGApp.app.configs.isMenuIconsEnabled)
                            ? PGApp.app.configs.menuCellInsetLeft
                            : 10.0f;
    
    [title drawInRect:CGRectMake(insetLeft,
                                 (self.bounds.size.height - titleSize.height) / 2,
                                 useableWidth,
                                 titleSize.height)
             withFont:[PGApp.app font:kPG_Font_Menu]
        lineBreakMode:NSLineBreakByWordWrapping];
    
}

- (void)setHighlighted:(BOOL)highlighted
              animated:(BOOL)animated {
    
    self.contentView.backgroundColor =
    (highlighted)
        ? [PGApp.app colour:kPG_Colour_Menu_Background_Selected]
        : (self.isSelected)
            ? [PGApp.app colour:kPG_Colour_Menu_Background_Selected]
            : [PGApp.app colour:kPG_Colour_Menu_Background];
    
    
}

- (void)selectCell:(BOOL)selected {
    
    self.isSelected = selected;
    
    self.contentView.backgroundColor =
    (self.isSelected)
        ? [PGApp.app colour:kPG_Colour_Menu_Background_Selected]
        : [PGApp.app colour:kPG_Colour_Menu_Background];
    
    [self setNeedsDisplay];
    
}

- (void)prepareForReuse {
    
    self.isSelected = NO;
    self.contentView.backgroundColor = [PGApp.app colour:kPG_Colour_Menu_Background];
    
}

@end
