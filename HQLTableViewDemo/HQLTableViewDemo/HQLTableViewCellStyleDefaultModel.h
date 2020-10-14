//
//  HQLTableViewCellStyleDefaultModel.h
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2018/4/2.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UITableViewCell+ConfigureModel.h"

/**
  UITableViewCell 数据源模型类
 
  默认样式 UITableViewCellStyleDefault
 */
@interface HQLTableViewCellStyleDefaultModel : NSObject <HQLTableViewCellConfigureDelegate>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;

@end
