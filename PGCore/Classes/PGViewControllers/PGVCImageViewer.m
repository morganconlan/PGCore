//
//  PGVCImageViewer.m
//  gaa_fixtures
//
//  Created by Morgan Conlan on 16/04/2014.
//  Copyright (c) 2014 Morgan Conlan. All rights reserved.
//

#import "PGApp.h"
#import "PGVCImageViewer.h"
#import "RemoteImageView.h"

@interface PGVCImageViewer ()

@property (nonatomic, strong) NSDictionary *args;
@property (nonatomic, strong) RemoteImageView *img;
@property (nonatomic, strong) UITapGestureRecognizer *tapPhoto;

@end

@implementation PGVCImageViewer

- (instancetype)initWithPhotoConfig:(NSDictionary *)args {
    
    
    if ((self = [super init])) {
        
        _args = args;
        
    }
    
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.contentView.bounds;
    gradient.colors = @[(id)[PGApp.app hex:0x666666].CGColor,
                        (id)[PGApp.app hex:0x444444].CGColor];
    
    [self.contentView.layer addSublayer:gradient];
    
    _tapPhoto = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedPhoto)];
    _tapPhoto.numberOfTapsRequired = 1;
    
    _img = [[RemoteImageView alloc] initWithFrame:[self imageFrame]];
    
    NSURL *imageURL = _args[@"url"];
    
    [_img loadImageURL:imageURL
     withCompleteBlock:^(UIImage *image) {

         [self resizeImageFrameForImage:image];
    
     } withErrorBlock:^(NSError *error) {
        
         DDLogVerbose(@"Error loading image");
         
    }];
    
    self.contentView.userInteractionEnabled = YES;
    [self.contentView addGestureRecognizer:_tapPhoto];
    [self.contentView addSubview:_img];
    
}

- (CGRect)imageFrame {
    
    CGFloat imgW = [_args[@"size"][@"w"] floatValue];
    CGFloat imgH = [_args[@"size"][@"h"] floatValue];
    CGFloat ratio = 1.0f;
    CGSize scaledSize;
    
    BOOL isPortrait = (imgH > imgW);
    
    if (isPortrait) {
        
        if (imgH > (self.contentView.frame.size.height - 10)) {
            
            ratio = imgH / (self.contentView.frame.size.height - 10);
            
        }
        
    } else {
        
        if (imgW > (self.contentView.frame.size.width - 10)) {
            
            ratio = imgW / (self.contentView.frame.size.width - 10);
            
        }
        
    }
    
    scaledSize = CGSizeMake(floorf(imgW / ratio), floorf(imgH / ratio));
    
    return CGRectMake(((self.contentView.frame.size.width - scaledSize.width) / 2),
                      ((self.contentView.frame.size.height - scaledSize.height) / 2),
                      scaledSize.width,
                      scaledSize.height);

}

- (void)resizeImageFrameForImage:(UIImage *)image {

}

- (void)tappedPhoto {

    [self dismissViewControllerAnimated:NO
                             completion:nil];
}

- (CGFloat)backgroundAlpha { return 0.0f; }

@end
