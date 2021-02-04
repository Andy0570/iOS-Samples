//
//  HQLTableViewCellStyleDefaultModel.m
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTableViewCellStyleDefaultModel.h"


@implementation HQLTableViewCellStyleDefaultModel

#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"title" : @"title",
        @"image" : @"image"
    };
}

#pragma mark - HQLTableViewCellConfigureDelegate

- (NSString *)imageName {
    return _image;
}

- (NSString *)titleLabelText {
    return _title;
}

@end
