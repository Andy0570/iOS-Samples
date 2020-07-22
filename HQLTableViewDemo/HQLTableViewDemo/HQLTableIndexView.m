//
//  HQLTableIndexView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/7/21.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTableIndexView.h"
#import <YYKit.h>

const NSInteger HQLTableIndexViewTag = 1024;
const CGFloat HQLTableIndexViewAnimationRadius = 80.0;
const CGFloat HQLTableIndexViewAlphaRate = 1/80;

@interface HQLTableIndexView ()

@property (nonatomic, strong) UIImageView *slideIndicateImageView;
@property (nonatomic, strong) UILabel *slideIndicateLabel;

@end

@implementation HQLTableIndexView

#pragma mark - Custom Accessors

- (UIImageView *)slideIndicateImageView {
    if (!_slideIndicateImageView) {
        UIImage *image = [UIImage imageNamed:@"search_slide"]; // 61*50
        _slideIndicateImageView = [[UIImageView alloc] initWithImage:image];
        _slideIndicateImageView.frame = CGRectMake(-image.size.width + 4, 100, image.size.width, image.size.height);
        _slideIndicateImageView.alpha = 0;
    }
    return _slideIndicateImageView;
}

- (UILabel *)slideIndicateLabel {
    if (!_slideIndicateLabel) {
        CGRect frame = CGRectMake(self.slideIndicateImageView.frame.origin.x + 16, 100, 60, 60);
        _slideIndicateLabel = [[UILabel alloc] initWithFrame:frame];
        _slideIndicateLabel.centerY = self.slideIndicateImageView.centerY;
        _slideIndicateLabel.textAlignment = NSTextAlignmentCenter;
        _slideIndicateLabel.backgroundColor = [UIColor clearColor];
        _slideIndicateLabel.font = [UIFont systemFontOfSize:30];
        _slideIndicateLabel.textColor = [UIColor whiteColor];
        _slideIndicateLabel.alpha = 0;
    }
    return _slideIndicateLabel;
}

- (void)setIndexNames:(NSArray *)indexNames {
    _indexNames = [indexNames copy];
    
    [self setupUI];
}

#pragma mark - Private

- (void)setupUI {
    CGFloat height = 17;
    [self.indexNames enumerateObjectsUsingBlock:^(NSString *indexName, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UILabel *label = [[UILabel alloc] init];
        if (idx == 0) {
            label.frame = CGRectMake(0, idx * height, self.frame.size.width, 14);
        } else {
            label.frame = CGRectMake((self.frame.size.width - 14) / 2, idx * height, 14, 14);
        }
        
        label.layer.cornerRadius = 7.0f;
        label.layer.masksToBounds = YES;
        
        label.text = indexName;
        // FIXME: 设置文本字体颜色
        label.textColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
        label.font = [UIFont boldSystemFontOfSize:10.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.tag = HQLTableIndexViewTag + idx;
        [self addSubview:label];
    }];
    
    [self addSubview:self.slideIndicateImageView];
    [self addSubview:self.slideIndicateLabel];
}

// 中心视图的数据源方法
- (void)showSearchSildeImageViewInSection:(NSInteger)section {
    self.selectedBlock(section);
    
    self.slideIndicateLabel.text = self.indexNames[section];
    self.slideIndicateLabel.alpha = 1.0;
    self.slideIndicateImageView.alpha = 1.0;
}

- (void)panAnimationBegan:(NSSet<UITouch *> *)touches {
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    
    // CGFloat height = 17;
    [self.indexNames enumerateObjectsUsingBlock:^(NSString *indexName, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *currentLabel = (UILabel *)[self viewWithTag:HQLTableIndexViewTag + idx];
        
        if (fabs(currentLabel.center.y - point.y) <= HQLTableIndexViewAnimationRadius) {
            

            
            [UIView animateWithDuration:0.2 animations:^{
                if (fabs(currentLabel.center.y - point.y) * HQLTableIndexViewAlphaRate <= 0.08) {
                    self.slideIndicateImageView.centerY = currentLabel.centerY;
                    self.slideIndicateLabel.centerY = self.slideIndicateImageView.centerY;
                    currentLabel.alpha = 1.0;
                    
                    if (idx != 0) {
                        [self showSearchSildeImageViewInSection:idx];
                    }
                }
            }];
            
            [self.indexNames enumerateObjectsUsingBlock:^(NSString *indexName, NSUInteger idxj, BOOL * _Nonnull stop) {
                
                UILabel *currentLabel = (UILabel *)[self viewWithTag:HQLTableIndexViewTag + idxj];
                if (idx == idxj) {
                    if (idx == 0) {
                        currentLabel.backgroundColor = [UIColor clearColor];
                        currentLabel.textColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];;
                    } else {
                        currentLabel.backgroundColor = [UIColor clearColor];
                        // FIXME: 设置文本字体颜色
                        currentLabel.textColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];;
                    }
                } else {
                    currentLabel.backgroundColor = [UIColor clearColor];
                    currentLabel.textColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];;
                }
            }];
        }
    }];
}

- (void)panAnimationEnded {
    [UIView animateWithDuration:1.0 animations:^{
        self.slideIndicateImageView.alpha = 0;
        self.slideIndicateLabel.alpha = 0;
    }];
}

#pragma mark Touch Event

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self panAnimationBegan:touches];
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self panAnimationBegan:touches];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self panAnimationEnded];
}

- (void)touchesCancelled:(NSSet<UITouch *> *)touches withEvent:(nullable UIEvent *)event {
    [self panAnimationEnded];
}

@end
