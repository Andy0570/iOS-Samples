//
//  AFCollectionViewCell.m
//  Dimensions
//
//  Created by Ash Furrow on 2013-01-13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"
#import "AFCollectionViewLayoutAttributes.h"

@implementation AFCollectionViewCell
{
    UIImageView *imageView;
    UIView *maskView;
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    
    // Set up our image view
    imageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 10, 10)];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    imageView.clipsToBounds = YES;
    [self.contentView addSubview:imageView];
    
    // 遮罩视图
    maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    maskView.alpha = 0.0f;
    [self.contentView insertSubview:maskView aboveSubview:imageView];
    
    // This will make the rest of our cell, outside the image view, appear transparent against a black background.
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

#pragma mark - Overridden Methods

-(void)prepareForReuse {
    [super prepareForReuse];
    
    [self setImage:nil];
}

/**
 当布局类通过 -layoutAttributesForItem: 或 layoutAttributesForHeader/Footer
 方法返回自定义的 UICollectionViewLayoutAttributes 子类时。
 此方法允许视图与布局类协同工作。
 
 以支持特定于给定 UICollectionViewLayout 子类的自定义布局属性类
 */
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    [super applyLayoutAttributes:layoutAttributes];
    
    maskView.alpha = 0.0f;
    self.layer.shouldRasterize = NO;
    
    // Important! Check to make sure we're actually this special subclass.
    // Failing to do so could cause the app to crash!
    if (![layoutAttributes isKindOfClass:[AFCollectionViewLayoutAttributes class]])
    {
        return;
    }
    
    AFCollectionViewLayoutAttributes *castedLayoutAttributes = (AFCollectionViewLayoutAttributes *)layoutAttributes;
    
    self.layer.shouldRasterize = castedLayoutAttributes.shouldRasterize;
    maskView.alpha = castedLayoutAttributes.maskingValue;
}

#pragma mark - Public Methods

-(void)setImage:(UIImage *)image {
    [imageView setImage:image];
}

@end
