//
//  AFDecorationView.m
//  Circle Layout
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFDecorationView.h"

@implementation AFDecorationView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor]];
    gradientLayer.backgroundColor = [[UIColor clearColor] CGColor];
    gradientLayer.frame = self.bounds;
    
    self.layer.mask = gradientLayer;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    
    return self;
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(id)[[UIColor blackColor] CGColor], (id)[[UIColor clearColor] CGColor]];
    gradientLayer.backgroundColor = [[UIColor clearColor] CGColor];
    gradientLayer.frame = self.bounds;
    
    self.layer.mask = gradientLayer;
}

@end
