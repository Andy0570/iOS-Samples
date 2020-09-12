//
//  AFDecorationView.m
//  Survey
//
//  Created by Ash Furrow on 2013-01-13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFDecorationView.h"

@implementation AFDecorationView
{
    UIImageView *binderImageView;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    
    binderImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"binder"]];
    binderImageView.frame = CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame));
    binderImageView.contentMode = UIViewContentModeScaleToFill;
    binderImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    [self addSubview:binderImageView];
    
    return self;
}

@end
