//
//  Story.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface Story : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *imageHue; // 图像色调
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *hint; // 暗示
@property (nonatomic, copy, readonly) NSString *gaPrefix;
@property (nonatomic, copy, readonly) NSArray *images;
@property (nonatomic, copy, readonly) NSNumber *type;
@property (nonatomic, copy, readonly) NSNumber *storyID;
@property (nonatomic, readonly, copy) NSString *testString; // 假设模型比 JSON 多几个参数

/**
 Model -> JSON:
 testString = "<null>";
 */
@end

NS_ASSUME_NONNULL_END

/**
 JSON:
 stories = [
     {
     url = https://daily.zhihu.com/story/9724086,
     images = [
                https://pic2.zhimg.com/v2-7ce02720c43284ca57bf1c56df62b9e9.jpg
              ],
     ga_prefix = 052207,
     id = 9724086,
     title = 为什么公鸡早上要打鸣？,
     hint = 苏澄宇 · 2 分钟阅读,
     type = 0,
     image_hue = 0xb38d3d
     }
 
 Model
 <Story: 0x28263d810> {
     images = [
     https://pic3.zhimg.com/v2-ecca98b2d84935190637b4cec2027086.jpg
 ],
     imageHue = 0xa69074,
     storyID = 9724089,
     gaPrefix = 052207,
     title = 大数据时代下，如何保护隐私？,
     hint = 甜草莓 · 2 分钟阅读,
     type = 0,
     url = https://daily.zhihu.com/story/9724089
 }
 */
