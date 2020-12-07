//
//  HQLTableViewCellStyleDefaultModel.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright (c) 2020 独木舟的木 All rights reserved.
//

#import "HQLTableViewCellStyleDefaultModel.h"


@implementation HQLTableViewCellStyleDefaultModel


#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"title": @"title",
        @"image": @"image"
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
