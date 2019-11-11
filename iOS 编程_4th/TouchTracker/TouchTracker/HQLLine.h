//
//  HQLLine.h
//  TouchTracker
//
//  Created by ToninTech on 2016/10/20.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>

/**
 描述线条的模型对象：起点 begin（x,y）、终点 end（x,y）
 */
@interface HQLLine : NSObject

@property (nonatomic) CGPoint begin;
@property (nonatomic) CGPoint end;

@end
