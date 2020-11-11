//
//  HQLTableViewGroupedModel.m
//  iOS Project
//
//  Created by Qilin Hu on 2020/11/07.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLTableViewGroupedModel.h"

@implementation HQLTableViewModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"image"  : @"image",
        @"title"  : @"title",
        @"detail" : @"detail",
        @"tag"    : @"tag"
    };
}

#pragma mark - HQLTableViewCellConfigureDelegate

- (NSString *)imageName {
    return _image;
}

- (NSString *)titleLabelText {
    return _title;
}

- (NSString *)detailLabelText {
    return _detail;
}

@end

@implementation HQLTableViewGroupedModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"headerTitle" : @"headerTitle",
        @"cells"       : @"cells"
    };
}

// JSON Array <——> NSArray<HQLTableViewModel>
+ (NSValueTransformer *)cellsJSONTransformer {
    return [MTLJSONAdapter arrayTransformerWithModelClass:HQLTableViewModel.class];
}

@end
