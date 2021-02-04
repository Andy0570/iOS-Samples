//
//  AFCollectionViewCell.m
//  Chapter 2 Project 6
//
//  Created by Ash Furrow on 2012-12-17.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"

@implementation AFCollectionViewCell
{
    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectInset(self.bounds, 10, 10)];
    [self.contentView addSubview:imageView];
    
    // !!!: 设置 cell 选中时的背景视图
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.selectedBackgroundView = selectedBackgroundView;
    
    return self;
}

#pragma mark - Overriden UICollectionViewCell methods

-(void)prepareForReuse {
    [super prepareForReuse];
    
    self.backgroundColor = [UIColor whiteColor];
    self.image = nil; //also resets imageView’s image
}

// !!!: 设置“高亮”状态改变时的 cell 样式
-(void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    
    imageView.alpha = (self.highlighted ? 0.8f : 1.0f);
}

#pragma mark - Overridden Properties

-(void)setImage:(UIImage *)image {
    _image = image;
    
    imageView.image = image;
}

@end
