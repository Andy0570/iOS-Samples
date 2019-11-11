//
//  Item+CoreDataClass.m
//  HQLHomepwner
//
//  Created by ToninTech on 2017/5/25.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "Item+CoreDataClass.h"
#import "HQLAssetType+CoreDataClass.h"

@implementation Item

- (void) awakeFromInsert {
    [super awakeFromInsert];
    self.dateCreated = [NSDate date];
    // 创建 NSUUID 对象，获取其 UUID 字符串
    NSUUID *uuid = [[NSUUID alloc] init];
    NSString *key = [uuid UUIDString];
    self.itemKey = key;
}

// 生成缩略图
- (void)setThumbnailFromImage:(UIImage *)image {
    CGSize origImageSize = image.size;
    // 缩略图的大小
    CGRect newRect = CGRectMake(0, 0, 40, 40);
    // 确定缩放倍数并保持宽高比不变
    float ratio = MAX(newRect.size.width / origImageSize.width,
                      newRect.size.height/origImageSize.height);
    
    // 根据当前设备的屏幕 scailing factor 创建透明的位图上下文
    UIGraphicsBeginImageContextWithOptions(newRect.size, NO, 0.0);
    // 创建表示圆角矩形的 UIBezierPath
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:newRect
                                                    cornerRadius:5.0];
    // 根据 UIBezierPath 对象裁剪图形上下文
    [path addClip];
    // 让图片在缩略图绘制范围内居中
    CGRect projectRect;
    projectRect.size.width = ratio * origImageSize.width;
    projectRect.size.height = ratio * origImageSize.height;
    projectRect.origin.x = (newRect.size.width - projectRect.size.width) / 2.0;
    projectRect.origin.y = (newRect.size.height - projectRect.size.height) / 2.0;
    // 在上下文中绘制图片
    [image drawInRect:projectRect];
    // 通过图形上下文得到 UIImage 对象，并将其赋给 thumbnail 属性
    UIImage *smallImage = UIGraphicsGetImageFromCurrentImageContext();
    self.thumbnail = smallImage;
    
    // 清理图形上下文
    UIGraphicsEndImageContext();
}

@end
