//
//  HQLGoodsSpecificationModel.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLGoodsSpecificationModel : NSObject

@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSSet<NSString *> *specifications;
@property (nonatomic, readwrite, copy, nullable) NSString *selectedSpecification;

- (instancetype)initWithTitle:(NSString *)title specifications:(NSSet *)specifications;

@end

NS_ASSUME_NONNULL_END
