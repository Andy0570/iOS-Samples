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

static inline void addRoundedRectToPath(CGContextRef context, CGRect rect, float ovalWidth, float ovalHeight)
{
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight == 0) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM (context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM (context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth (rect) / ovalWidth;
    fh = CGRectGetHeight (rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh, 1);
    CGContextAddArcToPoint(context, 0, fh, 0, fh/2, 1);
    CGContextAddArcToPoint(context, 0, 0, fw/2, 0, 1);
    CGContextAddArcToPoint(context, fw, 0, fw, fh/2, 1);
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

@implementation AFCollectionViewCell
{
    UIColor *realBackgroundColor;
}

-(id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    
    return self;
}

-(void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    [realBackgroundColor set];

    addRoundedRectToPath(context, self.bounds, 10, 10);
    CGContextClip(context);

    CGContextFillRect(context, self.bounds);
    
    CGContextRestoreGState(context);
    
    [[UIColor whiteColor] set];
    
    [self.text drawInRect:CGRectInset(self.bounds, 10, 10) withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:NSLineBreakByWordWrapping alignment:NSTextAlignmentCenter];
}

#pragma mark - Overridden Properties

-(void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:[UIColor clearColor]];
    
    realBackgroundColor = backgroundColor;
    
    [self setNeedsDisplay];
}

-(UIColor *)backgroundColor
{
    return realBackgroundColor;
}

-(void)setText:(NSString *)text
{
    _text = [text copy];
    
    [self setNeedsDisplay];
}

@end
