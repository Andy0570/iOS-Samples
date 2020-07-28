//
//  AddressView.m
//  ChooseLocation
//
//  Created by Sekorm on 16/8/25.
//  Copyright © 2016年 HY. All rights reserved.
//

#import "AddressView.h"
#import "UIView+Frame.h"

static const CGFloat HYBarItemMargin = 20;

@interface AddressView ()

@property (nonatomic, strong) NSMutableArray *btnArray;

@end

@implementation AddressView

#pragma mark - Lifecycle

- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 遍历数组容器，设置按钮边距
    for (NSInteger i = 0; i < self.btnArray.count; i++) {
        UIView *view = self.btnArray[i]; // 取出来的是 UIButton
        // 如果只有一个按钮
        if (i == 0) {
            // |-20-当前按钮
            view.left = HYBarItemMargin;
        }
        // 如果有多个按钮
        if (i > 0) {
            // |-20-上个按钮-20-当前按钮
            UIView * preView = self.btnArray[i - 1];
            view.left = HYBarItemMargin  + preView.right;
        }
      
    }
}

#pragma mark - Custom Accessors

// 每次 get 方法都会执行一遍遍历查询
- (NSMutableArray *)btnArray{
    NSMutableArray * mArray  = [NSMutableArray array];
    // 遍历此视图中的子视图，如果它是一个 UIButton，则把它加入到数组中
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIButton class]]) {
            [mArray addObject:view];
        }
    }
    _btnArray = mArray;
    return _btnArray;
}

@end
