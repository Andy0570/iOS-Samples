//
//  HQLCollectionCycleScrollView.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/12.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLCollectionCycleScrollView.h"

// Frameworks
#import <SDCycleScrollView.h>

const CGFloat HQLCollectionCycleScrollViewHeight = 130;

@interface HQLCollectionCycleScrollView () <SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleScrollView;
@end

@implementation HQLCollectionCycleScrollView


#pragma mark - View life cycle

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.cycleScrollView];
    }
    return self;
}

#pragma mark - Custom Accessors

- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        // UIImage *defaultImage = [UIImage imageNamed:@"banner_empty"];
        _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:self.bounds
                                                              delegate:self
                                                      placeholderImage:nil];
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        _cycleScrollView.autoScrollTimeInterval = 5.0; // 自动滚动间隔时间，5s
    }
    return _cycleScrollView;
}

- (void)setImageGroupArray:(NSArray<NSURL *> *)imageGroupArray {
    _imageGroupArray = imageGroupArray;
    
    if (imageGroupArray.count == 0)  return;
    self.cycleScrollView.imageURLStringsGroup = imageGroupArray;
}

#pragma mark - SDCycleScrollViewDelegate

- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    // 导航 banner 图片点击处理事件
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedScrollViewItemAtIndex:)]) {
        [self.delegate selectedScrollViewItemAtIndex:index];
    }
}

@end
