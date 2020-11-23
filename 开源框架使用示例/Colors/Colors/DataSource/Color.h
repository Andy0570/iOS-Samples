//
//  Color.h
//  Colors
//
//  Created by Qilin Hu on 2020/7/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface Color : NSObject

@property (nonatomic, strong) NSString *hex;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *rgb;

@property (nonatomic, weak) UIColor *color;

- (instancetype)initWithDictionary:(NSDictionary *)dict;

// 通过 color 生成图片
+ (UIImage *)roundThumbWithColor:(UIColor *)color;
+ (UIImage *)roundImageForSize:(CGSize)size withColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
