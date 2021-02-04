//
//  AFCollectionHeaderView.m
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionHeaderView.h"

@implementation AFCollectionHeaderView
{
    UILabel *textLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    textLabel = [[UILabel alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 30, 10)];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:textLabel];
    
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setText:@""];
}

-(void)setText:(NSString *)text
{
    _text = [text copy];
    
    [textLabel setText:text];
}

@end
