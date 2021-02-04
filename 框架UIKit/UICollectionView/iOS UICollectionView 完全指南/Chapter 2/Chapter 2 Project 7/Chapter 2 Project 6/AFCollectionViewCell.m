//
//  AFCollectionViewCell.m
//  Chapter 2 Project 6
//
//  Created by Ash Furrow on 2012-12-17.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"

@implementation AFCollectionViewCell

#pragma mark - Overriden UICollectionViewCell methods

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.8f];
    self.selectedBackgroundView = selectedBackgroundView;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.backgroundColor = [UIColor whiteColor];
    self.image = nil; //also resets imageView’s image
}

-(void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];
    
    if (self.highlighted)
    {
        imageView.alpha = 0.8f;
    }
    else
    {
        imageView.alpha = 1.0f;
    }
}

#pragma mark - Overridden Properties

-(void)setImage:(UIImage *)image
{
    _image = image;
    
    imageView.image = image;
}

@end
