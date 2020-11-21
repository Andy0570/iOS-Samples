//
//  AFCollectionViewCell.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AFCollectionViewCell.h"

@interface AFCollectionViewCell ()
@property (nonatomic, strong) UILabel *textLabel;
@end

@implementation AFCollectionViewCell

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        self.textLabel.textAlignment = NSTextAlignmentCenter;
        self.textLabel.font = [UIFont boldSystemFontOfSize:20];
        [self.contentView addSubview:self.textLabel];
    }
    return self;
}

#pragma mark - Overriden UICollectionViewCell methods

- (void)prepareForReuse {
    [super prepareForReuse];
    
    self.text = @"";
}

#pragma mark - Overriden properties

-(void)setText:(NSString *)text {
    _text = [text copy];
    
    self.textLabel.text = self.text;
}

@end
