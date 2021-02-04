//
//  AFCollectionViewCell.m
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"

@implementation AFCollectionViewCell
{
    UIImageView *imageView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self.contentView addSubview:imageView];
    
    UIView *selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    selectedBackgroundView.backgroundColor = [UIColor orangeColor];
    self.selectedBackgroundView = selectedBackgroundView;
    
    self.backgroundColor = [UIColor whiteColor];
    
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setImage:nil];
    [self setSelected:NO];
}

-(void)layoutSubviews
{
    imageView.frame = CGRectInset(self.bounds, 10, 10);
}

-(void)setImage:(UIImage *)image
{
    _image = image;
    
    imageView.image = image;
}

-(void)setDisabled:(BOOL)disabled
{
    self.contentView.alpha = disabled ? 0.5f : 1.0f;
    self.backgroundColor = disabled ? [UIColor grayColor] : [UIColor whiteColor];
}

@end
