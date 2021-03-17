//
//  HQLGoodsSpecificationModel.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLGoodsSpecificationModel.h"

@interface HQLGoodsSpecificationModel ()
@property (nonatomic, readwrite, copy) NSString *title;
@property (nonatomic, readwrite, copy) NSSet<NSString *> *specifications;
@end

@implementation HQLGoodsSpecificationModel

- (instancetype)initWithTitle:(NSString *)title specifications:(NSSet *)specifications {
    self = [super init];
    if (self) {
        _title = [title copy];
        _specifications = specifications;
    }
    return self;
}

- (NSString *)description {
    return [self modelDescription];
}

@end
