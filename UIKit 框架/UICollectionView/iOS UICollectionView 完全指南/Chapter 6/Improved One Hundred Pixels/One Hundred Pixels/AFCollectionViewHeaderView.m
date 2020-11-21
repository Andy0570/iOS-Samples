//
//  AFCollectionViewHeaderView.m
//  One Hundred Pixels
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewHeaderView.h"

static NSString *kind = @"AFCollectionViewHeaderView";

@interface AFCollectionViewHeaderView ()

@property (nonatomic, strong) UILabel *label;

@end

@implementation AFCollectionViewHeaderView

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor orangeColor];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    self.label.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.label.backgroundColor = [UIColor clearColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.label];
    
    return self;
}

-(void)setText:(NSString *)text
{
    self.label.text = text;
}

+(NSString *)kind
{
    return kind;
}

@end
