//
//  AFCollectionViewCell.m
//  One Hundred Pixels
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewCell.h"
#import "AFCollectionViewLayoutAttributes.h"

@interface AFCollectionViewCell ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIView *maskView;

@end

@implementation AFCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    if (!(self = [super initWithFrame:frame])) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectInset(CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame)), 10, 10)];
    self.imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.imageView.clipsToBounds = YES;
    [self.contentView addSubview:self.imageView];
    
    self.maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(frame), CGRectGetHeight(frame))];
    self.maskView.backgroundColor = [UIColor blackColor];
    self.maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.maskView.alpha = 0.0f;
    [self.contentView insertSubview:self.maskView aboveSubview:self.imageView];
    
    
    return self;
}

-(void)prepareForReuse
{
    [super prepareForReuse];
    
    [self setImage:nil];
}

-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes
{
    [super applyLayoutAttributes:layoutAttributes];
    
    self.layer.shouldRasterize = YES;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOffset = CGSizeMake(0, 3);
    self.maskView.alpha = 0.0f;
    if ([layoutAttributes isKindOfClass:[AFCollectionViewLayoutAttributes class]])
    {
        self.layer.shadowOpacity = [(AFCollectionViewLayoutAttributes *)layoutAttributes shadowOpacity];
        self.maskView.alpha = [((AFCollectionViewLayoutAttributes *)layoutAttributes) maskingValue];
    }
}

#pragma mark - Public Methods

-(void)setImage:(UIImage *)image
{
    [self.imageView setImage:image];
}


@end
