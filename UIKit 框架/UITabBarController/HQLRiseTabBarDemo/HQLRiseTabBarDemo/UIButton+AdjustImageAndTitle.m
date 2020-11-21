//
//  UIButton+AdjustImageAndTitle.m
//  XuZhouSS
//
//  Created by ToninTech on 2017/7/11.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "UIButton+AdjustImageAndTitle.h"

static const CGFloat KDefaultSpacing = 6.0f;

@interface UIButton ()

@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;

@property (nonatomic) CGRect imageRect;
@property (nonatomic) CGRect titleRect;

@property (nonatomic) CGSize imageSize;
@property (nonatomic) CGSize titleSize;

@end

@implementation UIButton (AdjustImageAndTitle)

#pragma mark - Custom Accessors

- (CGFloat)width {
    return self.frame.size.width;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (CGRect)imageRect {
    return self.imageView.frame;
}

- (CGRect)titleRect {
    return self.titleLabel.frame;
}

- (CGSize)imageSize {
    return self.imageView.frame.size;
}

- (CGSize)titleSize {
    return self.titleLabel.frame.size;
}

#pragma mark - Public

#pragma mark 上下居中，图片在上，文字在下
- (void)hql_verticalCenterImageAndTitle:(CGFloat)spacing {
    // 图文上下布局时所占用的总高度
    CGFloat totalHeight = self.imageSize.height + spacing + self.titleSize.height;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                            - self.imageSize.width,
                                            - (self.imageSize.height + spacing),
                                            0.0);
    
    self.imageEdgeInsets = UIEdgeInsetsMake(
        ((self.height - totalHeight)/2 - self.imageRect.origin.y),
        ((self.width - self.imageRect.size.width)/2 - self.imageRect.origin.x ),
        -((self.height - totalHeight)/2 - self.imageRect.origin.y),
        -((self.width - self.imageRect.size.width)/2 - self.imageRect.origin.x ));
}

- (void)hql_verticalCenterImageAndTitle {
    [self hql_verticalCenterImageAndTitle:KDefaultSpacing];
}

#pragma mark 左右居中，文字在左，图片在右
- (void)hql_horizontalCenterTitleAndImage:(CGFloat)spacing {
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0,
                                            - self.imageSize.width,
                                            0.0,
                                            self.imageSize.width + spacing/2);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0,
                                            self.titleSize.width + spacing/2,
                                            0.0,
                                            - self.titleSize.width);
}

- (void)hql_horizontalCenterTitleAndImage {
    [self hql_horizontalCenterTitleAndImage:KDefaultSpacing];
}

#pragma mark 左右居中，图片在左，文字在右
- (void)hql_horizontalCenterImageAndTitle:(CGFloat)spacing {
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, spacing/2, 0.0, - spacing/2);
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing/2, 0.0, spacing/2);
}

- (void)hql_horizontalCenterImageAndTitle {
    [self hql_horizontalCenterImageAndTitle:KDefaultSpacing];
}

#pragma mark 文字居中，图片在左边
- (void)hql_horizontalCenterTitleAndImageLeft:(CGFloat)spacing {

    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, - spacing, 0.0, 0.0);
}

- (void)hql_horizontalCenterTitleAndImageLeft {
    [self hql_horizontalCenterTitleAndImageLeft:KDefaultSpacing];
}

#pragma mark 文字居中，图片在右边
- (void)hql_horizontalCenterTitleAndImageRight:(CGFloat)spacing {
    
    // lower the text and push it left to center it
    self.titleEdgeInsets = UIEdgeInsetsMake(0.0, - self.imageSize.width, 0.0, 0.0);
    
    // raise the image and push it right to center it
    self.imageEdgeInsets = UIEdgeInsetsMake(0.0, self.titleSize.width + self.imageSize.width + spacing, 0.0, - self.titleSize.width);
}

- (void)hql_horizontalCenterTitleAndImageRight {
    
    [self hql_horizontalCenterTitleAndImageRight:KDefaultSpacing];
}

@end
