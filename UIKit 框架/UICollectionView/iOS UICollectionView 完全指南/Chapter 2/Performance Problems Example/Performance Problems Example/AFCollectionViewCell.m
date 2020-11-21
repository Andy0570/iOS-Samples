//
//  AFCollectionViewCell.m
//  Performance Problems Example
//
//  Created by Ash Furrow on 2012-12-28.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"

//We need QuartzCore for CALayer
#import <QuartzCore/QuartzCore.h>

@implementation AFCollectionViewCell
{
    UIImageView *imageBackgroundView;
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    imageBackgroundView = [[UIImageView alloc] initWithFrame:frame];
    self.backgroundView = imageBackgroundView;
    
    self.layer.cornerRadius = 10.0f;
    self.layer.masksToBounds = YES;
    
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setImage:nil];
}

-(void)setImage:(UIImage *)image
{
    [imageBackgroundView setImage:image];
}

@end
