//
//  AFCollectionViewCell.m
//  Chapter 2 Project 4
//
//  Created by Ash Furrow on 2012-12-17.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"

@implementation AFCollectionViewCell
{
    UILabel *textLabel;
}

#pragma mark - Initialization

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    textLabel = [[UILabel alloc] initWithFrame:self.bounds];
    textLabel.textAlignment = NSTextAlignmentCenter;
    textLabel.font = [UIFont boldSystemFontOfSize:20];
    [self.contentView addSubview:textLabel];
    
    return self;
}

#pragma mark - Overriden UICollectionViewCell methods

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    self.text = @"";
}

#pragma mark - Overriden properties

-(void)setText:(NSString *)text
{
    _text = [text copy];
    
    textLabel.text = self.text;
}

@end
