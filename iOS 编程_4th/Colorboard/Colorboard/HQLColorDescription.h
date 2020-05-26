//
//  HQLColorDescription.h
//  Colorboard
//
//  Created by ToninTech on 16/10/18.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 用户选择的颜色
 */
@interface HQLColorDescription : NSObject

@property (nonatomic) UIColor *color;
@property (nonatomic,copy) NSString *name;

@end
