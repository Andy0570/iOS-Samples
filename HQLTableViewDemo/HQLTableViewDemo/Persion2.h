//
//  Persion2.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/31.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Persion2 : NSObject <NSCoding>

// 基础数据类型：int、float、double、CGFloat、NSInteger 等
@property (nonatomic, assign, readwrite) int num;
@property (nonatomic, assign, readwrite) float latitude;
@property (nonatomic, assign, readwrite) float longtitude;

// 指定 Bool 类型的 getter 方法名
@property (nonatomic, getter=isOn) BOOL isLogin;

// NSString
@property (nonatomic, copy, readwrite) NSString *identifier;
@property (nonatomic, copy, readwrite) NSString *title;

// NSArray
@property (nonatomic, copy) NSArray *array;

- (void)setNum:(int)num
      latitude:(float)latitude
    longtitude:(float)longtitude
    loginState:(BOOL)islogin
    identifier:(NSString *)identifier
         title:(NSString *)title;

@end

NS_ASSUME_NONNULL_END
