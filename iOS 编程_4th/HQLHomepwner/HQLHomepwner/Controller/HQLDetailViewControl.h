//
//  HQLDetailViewControl.h
//  HQLHomepwner
//
//  Created by ToninTech on 16/9/9.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HQLItem;

@interface HQLDetailViewControl : UIViewController <UITextFieldDelegate, UIViewControllerRestoration>

@property (nonatomic, strong) HQLItem *item;
// 使用 Block 对象实现刷新列表
@property (nonatomic, copy) void(^dismissBlock)(void);

- (instancetype)initForNewItem:(BOOL)isNew;

@end
