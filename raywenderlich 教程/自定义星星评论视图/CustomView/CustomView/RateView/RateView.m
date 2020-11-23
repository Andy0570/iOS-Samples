//
//  RateView.m
//  CustomView
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import "RateView.h"

//@interface RateView ()
//
//// 此处可以放不必要暴露的属性
//
//@end

@implementation RateView

#pragma mark - Init

- (void)baseInit {
    _notSelectedImage = nil;
    _halfSelectedImage = nil;
    _fullSelectedImage = nil;
    _rating = 0;
    _editable = NO;
    _imageViews = [[NSMutableArray alloc] init];
    _maxRating = 5;
    _midMargin = 5;
    _leftMargin = 0;
    _minImageSize = CGSizeMake(5, 5);
    _delegate = nil;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
        [self baseInit];
    }
    return self;
}

// 设置合适的子视图大小
- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.notSelectedImage) {
        return;
    }
    
    /*
     设置每个五角星的尺寸大小
     这里，教程中的计算方法如下，请仔细看，他的数学估计是体育老师教的吧。😂😂😂
     float desiredImageWidth = (self.frame.size.width - (self.leftMargin*2) - (self.midMargin*self.imageViews.count)) / self.imageViews.count;
     */
    float desiredImageWidth = (self.frame.size.width - self.leftMargin*2 -(self.midMargin*(self.imageViews.count-1))) / self.imageViews.count;
    float imageWidth = MAX(self.minImageSize.width, desiredImageWidth);
    float imageHeight = MAX(self.minImageSize.height, desiredImageWidth);
    for (int i = 0; i < self.imageViews.count; i++) {
        
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        CGRect imageFrame = CGRectMake(self.leftMargin + i*(self.midMargin+imageWidth), 0, imageWidth, imageHeight);
        imageView.frame = imageFrame;
    
    }
}

#pragma mark - Custom Accessors

/*
 设置最大评分数，它决定了我们会有多少个 UIImageView 子视图
 做了两件事：
 1.添加图片：根据最大评分数初始化图片数量，移除旧图片，添加新图片。
 2.刷新UI，设置图片大小：调用 setNeedsLayout 方法后，系统会调用 layoutSubviews 方法来设置每个图片的位置和大小。
 */
- (void)setMaxRating:(int)maxRating {
    _maxRating = maxRating;
    
    // Remove old image views
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = (UIImageView *)[self.imageViews objectAtIndex:i];
        [imageView removeFromSuperview];
    }
    [self.imageViews removeAllObjects];
    
    // Add new image view
    for (int i = 0; i < maxRating; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.imageViews addObject:imageView];
        [self addSubview:imageView];
    }
    
    // Relayout and refresh
    [self setNeedsLayout];
    [self refresh];
}

- (void)setNotSelectedImage:(UIImage *)notSelectedImage {
    _notSelectedImage = notSelectedImage;
    [self refresh];
}

- (void)setHalfSelectedImage:(UIImage *)halfSelectedImage {
    _halfSelectedImage = halfSelectedImage;
    [self refresh];
}

- (void)setFullSelectedImage:(UIImage *)fullSelectedImage {
    _fullSelectedImage = fullSelectedImage;
    [self refresh];
}

- (void)setRating:(float)rating {
    _rating = rating;
    [self refresh];
}

#pragma mark - Private

// 刷新视图，根据当前评分修改对应的五角星图片
- (void)refresh {
    for (int i = 0; i < self.imageViews.count; i++) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        if (self.rating >= i+1) {
            imageView.image = self.fullSelectedImage;
        }else if (self.rating > i) {
            imageView.image = self.halfSelectedImage;
        }else {
            imageView.image = self.notSelectedImage;
        }
    }
}

#pragma mark - Touch Method

// 根据手指触摸位置，计算当前评分值
- (void)handleTouchAtLocation:(CGPoint)touchLocation {
    if (!self.editable) {
        return;
    }
    
    float newRating = 0;
    for (NSInteger i = self.imageViews.count - 1; i >= 0 ; i--) {
        UIImageView *imageView = [self.imageViews objectAtIndex:i];
        CGFloat originValue = imageView.frame.origin.x;
        CGFloat midValue = originValue + imageView.frame.size.width / 2;
                
        if (touchLocation.x > midValue) {
            newRating = i+1;
            break;
        }else if ((touchLocation.x > originValue) && (touchLocation.x <= midValue)) {
            newRating = i + 0.5;
            break;
        }else {
            continue;
        }
    }
    
    self.rating = newRating;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    [self handleTouchAtLocation:touchLocation];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.delegate rateView:self ratingDidChange:self.rating];
}

@end
