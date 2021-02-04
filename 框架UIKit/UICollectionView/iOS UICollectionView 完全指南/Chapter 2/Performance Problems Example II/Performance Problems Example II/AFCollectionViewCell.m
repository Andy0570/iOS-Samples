//
//  AFCollectionViewCell.m
//  Performance Problems Example II
//
//  Created by Ash Furrow on 2012-12-28.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"

//We need QuartzCore for CALayer
#import <QuartzCore/QuartzCore.h>

@implementation AFCollectionViewCell

-(void)awakeFromNib
{
    [super awakeFromNib];
    
    self.label.textColor = [UIColor whiteColor];
    
    self.backgroundColorView.layer.cornerRadius = 10.0f;
    self.backgroundColorView.layer.masksToBounds = YES;
}

-(void)prepareForReuse
{
    [super layoutSubviews];
    
    self.backgroundColorView.backgroundColor = [UIColor clearColor];
    self.label.text = @"";
    
    /*
     Maybe we're conflating preparation for reuse with no longer
     displaying our old content, so we want to tell our API that we
     are no longer displaying it. This is a pedagogical example, after all.
     */
    [self performLongRunningTask];
}

-(void)performLongRunningTask
{
    /*
     Let's run some long-running task. Maybe it's some complicated view 
     hierarchy math that could be simplified with Autolayout.
     */
    for (int i = 0; i < 5000000; i++);
}

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
}

@end
