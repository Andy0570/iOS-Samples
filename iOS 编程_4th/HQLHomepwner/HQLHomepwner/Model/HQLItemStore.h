//
//  HQLItemStore.h
//  HQLHomepwner
//
//  Created by ToninTech on 16/8/30.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

// @class 指令的含义：只需要使用类的声明，无需知道具体的实现细节
@class HQLItem;

@interface HQLItemStore : NSObject

/*
 * allItems 属性对外部公开使用，用于保存 HQLItem
 *
 * 设置内部数据的访问权限：某个对象中有一种可修改的数据，但是除该对象之外，其他对象只能访问该数据而不能修改它
 * allItems 属性被声明为 NSArray（不可变数组），且设置为 readonly，
 * 这样其他类既无法将一个新的数组赋给 allItems，也无法修改 allItems
 */
@property (nonatomic, readonly, copy) NSArray *allItems;

// 将此类设置为单例对象
+ (instancetype)sharedStore;

// 创建Item
- (HQLItem *)createItem;

// 删除Item
- (void)removeItem:(HQLItem *)item;

// 移动位置
- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex;

// 保存数据
- (BOOL) saveChanges;

@end
