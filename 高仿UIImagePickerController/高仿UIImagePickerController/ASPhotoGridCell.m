//
//  ASPhotoGridCell.m
//  高仿UIImagePickerController
//
//  Created by alan on 9/12/16.
//  Copyright © 2016 AlanSim. All rights reserved.
//

#import "ASPhotoGridCell.h"

@interface ASPhotoGridCell ()

@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) CALayer *maskLayer;

@end

@implementation ASPhotoGridCell

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    if (selected) {
        [self.contentView.layer addSublayer:self.maskLayer];
    } else {
        [self.maskLayer removeFromSuperlayer];
    }
}

- (void)setThumbnailImage:(UIImage *)thumbnailImage {
    _thumbnailImage = thumbnailImage;
    self.imageView.image = thumbnailImage;
}

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
        _imageView.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_imageView];
    }
    return _imageView;
}

- (CALayer *)maskLayer {
    if (!_maskLayer) {
        _maskLayer = [CALayer layer];
        _maskLayer.frame = self.bounds;
        _maskLayer.contents = (id)[UIImage imageNamed:@"mask"].CGImage;
        _maskLayer.backgroundColor = [UIColor colorWithRed:1.f green:1.f blue:1.f alpha:.2f].CGColor;
    }
    return _maskLayer;
}

@end
