//
//  LatestModel.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//


// Frameworks
#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/**
 编写一个知乎 API 接口返回的模型
 
 参考：https://www.jianshu.com/p/d9e66beedb8f
 API：http://news-at.zhihu.com/api/4/news/latest
 */
@interface LatestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSDate *date;
@property (nonatomic, copy, readonly) NSArray *stories;
@property (nonatomic, copy, readonly) NSArray *topStories;

@end

NS_ASSUME_NONNULL_END


/**
JSON 模型示例：

{
    "date": "20200426",
    "stories": [{
        "image_hue": "0x3b2e42",
        "title": "如果当时钟南山没说话，武汉确诊人数可能就翻倍了",
        "url": "https:\/\/daily.zhihu.com\/story\/9723102",
        "hint": "杨书航 · 11 分钟阅读",
        "ga_prefix": "042607",
        "images": ["https:\/\/pic2.zhimg.com\/v2-89434353c979af839ce84190317b0d51.jpg"],
        "type": 0,
        "id": 9723102
    }, {
       ...
    }, {
       ...
    }, {
       ...
    }, {
       ...
    }, {
       ...
    }],
    "top_stories": [{
        "image_hue": "0x687854",
        "hint": "作者 \/ 时间规划局",
        "url": "https:\/\/daily.zhihu.com\/story\/9723139",
        "image": "https:\/\/pic4.zhimg.com\/v2-976e6c061aed1a39998992f3dbc8b71b.jpg",
        "title": "小事 · 博士生学历真的很重要吗？",
        "ga_prefix": "042507",
        "type": 0,
        "id": 9723139
    }, {
       ...
    }, {
       ...
    }, {
       ...
    }, {
       ...
    }]
}


*/
