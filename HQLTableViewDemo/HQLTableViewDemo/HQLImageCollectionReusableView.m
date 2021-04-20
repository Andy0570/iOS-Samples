//
//  HQLImageCollectionReusableView.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/9/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLImageCollectionReusableView.h"
#import <JKCategories/NSString+JKNormalRegex.h>
#import <SDWebImage.h>
#import <YYKit.h>

@implementation HQLImageCollectionReusableView

#pragma mark - Initialize

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.imageView.image = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    [self addSubview:self.imageView];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) { return nil; }
    [self addSubview:self.imageView];
    return self;
}

#pragma mark - Custom Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageView;
}

- (void)setImageURL:(NSURL *)imageURL {
    _imageURL = imageURL;
    
    UIImage *defaultImage = [UIImage imageNamed:@"placeholder_150*150"];
    if ([_imageURL.absoluteString jk_isValidUrl]) {
        [self.imageView sd_setImageWithURL:_imageURL placeholderImage:defaultImage];
    } else {
        self.imageView.image = defaultImage;
    }
}

- (void)setImageName:(NSString *)imageName {
    _imageName = imageName;
    
    if ([_imageName isNotBlank]) {
        self.imageView.image = [UIImage imageNamed:imageName];
    } else {
        self.imageView.image = [UIImage imageNamed:@"placeholder_150*150"];
    }
}

@end
