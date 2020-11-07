//
//  HQLTableViewGroupedModel.h
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2018/4/2.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import <Mantle.h>
#import "UITableViewCell+ConfigureModel.h"

/**
 UITableViewCell 数据源模型
 
 默认样式 UITableViewCellStyleDefault
 */
@interface HQLTableViewModel : MTLModel <MTLJSONSerializing, HQLTableViewCellConfigureDelegate>
@property (nonatomic, readonly, copy) NSString *image;
@property (nonatomic, readonly, copy) NSString *title;
@property (nonatomic, readonly, copy) NSString *detail;
@property (nonatomic, readonly, copy) NSNumber *tag;
@end

/**
 UITableViewStyleGrouped 数据源模型
 
 模型数据源文件：mainTableViewTitleModel.plist
 */
@interface HQLTableViewGroupedModel : MTLModel <MTLJSONSerializing>
@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSArray *cells; // NSArray<HQLTableViewModel>
@end
