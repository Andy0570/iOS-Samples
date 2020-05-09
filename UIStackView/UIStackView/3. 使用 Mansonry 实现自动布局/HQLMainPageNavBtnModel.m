//
//  HQLMainPageNavBtnModel.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/5/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMainPageNavBtnModel.h"

@implementation HQLMainPageNavBtnModel

#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"title" : @"title",
        @"image" : @"image",
        @"tag"   : @"tag"
    };
}

@end
