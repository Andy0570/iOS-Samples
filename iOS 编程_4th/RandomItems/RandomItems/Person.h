//
//  Person.h
//  RandomItems
//
//  Created by Qilin Hu on 2019/11/7.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 属性合成（synthesized）示例
@interface Person : NSObject

// 配偶
@property (nonatomic, strong) Person *spouse;
// 姓氏
@property (nonatomic, copy) NSString *lastNamel;
// 配偶的姓氏
@property (nonatomic, copy) NSString *lastNameOfSpouse;

@end

NS_ASSUME_NONNULL_END

/*
 解读：
 在这个例子中， spouse 和 lastName 属性需要生成实例变量，因为配偶和姓氏是个人基本信息。
 而 lastNameOfSpouse 属性则不用生成实例变量，因为可以通过 spouse 的 lastName 属性知道配偶的姓氏，所以不需要在两个 Person 对象中都生成实例变量，既浪费内存也容易出错。
 我们可以为 lastNameOfSpouse 属性自定义存取方法。

 */
