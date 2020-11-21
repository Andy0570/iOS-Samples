//
//  HQLTableViewCellStyleDefaultModel.m
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2018/4/2.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import "HQLTableViewCellStyleDefaultModel.h"

// Framework
#import <YYKit/NSObject+YYModel.h>

@implementation HQLTableViewCellStyleDefaultModel

#pragma mark - NSObject

- (NSString *)description {
    return [self modelDescription];
}

#pragma mark - HQLTableViewCellConfigureDelegate

- (NSString *)imageName {
    return _image;
}

- (NSString *)titleLabelText {
    return _title;
}

@end
