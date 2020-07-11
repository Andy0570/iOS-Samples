//
//  AnimalsViewController.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLShoppingCartGoodsModel.h"
#import <YYKit.h>
#import <JKCategories.h>

@implementation HQLShoppingCartGoodsModel


#pragma mark - Initialize

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (!self) return nil;

    // 初始化所有商品默认未选中！
    _checked = NO;

    return self;
}


#pragma mark - MTLJSONSerializing

// 模型和 JSON 字典之间的映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"memberId"       : @"memberId",
        @"memberNickName" : @"memberNickname",
        @"storeId"        : @"storeId",
        @"storeName"      : @"storeName",
        @"productId"      : @"productId",
        @"productSkuCode" : @"productSkuCode",
        @"productSn"      : @"productSn",
        @"productName"    : @"productName",
        @"imageURL"       : @"productPic",
        @"quantity"       : @"quantity",
        @"price"          : @"price",
        @"specification1" : @"sp1",
        @"specification2" : @"sp2",
        @"specification3" : @"sp3",
        @"checked"        : @"checked"
    };
}

// url
// MARK: JSON String <——> NSURL
//+ (NSValueTransformer *)imageURLJSONTransformer {
//    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
//}

// imageURL
// MARK: JSON String <——> NSURL
+ (NSValueTransformer *)imageURLJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if ([value isKindOfClass:[NSString class]]) {
            NSString *formattedStr = [value jk_stringByEscapingForAsciiHTML];
            return [formattedStr isNotBlank] ? [NSURL URLWithString:formattedStr] : nil;
        } else if ([value isKindOfClass:[NSURL class]]) {
            NSURL *url = (NSURL *)value;
            return [url.absoluteString jk_isValidUrl] ? url : nil;
        } else {
            return nil;
        }
    }];
}

@end
