//
//  BNRAsset.h
//  BMITime
//
//  Created by ToninTech on 2017/3/27.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNREmployee;

@interface BNRAsset : NSObject

@property (nonatomic, weak) BNREmployee *holder; //   物品属于谁？
@property (nonatomic, copy) NSString *label;
@property (nonatomic) unsigned int resaleValue;

@end
