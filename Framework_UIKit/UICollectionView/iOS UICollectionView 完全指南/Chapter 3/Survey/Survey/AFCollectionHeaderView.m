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

#pragma mark - Initialize

-(void)prepareForReuse {
    [super prepareForReuse];
    
    [self setText:@""];
}

- (id)initWithFrame:(CGRect)frame {
    if (!(self = [super initWithFrame:frame])) return nil;
    
    // CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 30, 10)
    textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    textLabel.backgroundColor = [UIColor clearColor];
    textLabel.textColor = [UIColor whiteColor];
    textLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:textLabel];
    
    return self;
}

#pragma mark - Custom Accessors

-(void)setText:(NSString *)text {
    _text = [text copy];
    
    [textLabel setText:text];
}

@end
