//
//  HQLTableViewCellGroupedModel.h
//  HQLTakePhotoDemo
//
//  Created by Qilin Hu on 2018/4/2.
//  Copyright © 2018年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 UITableViewStyleGrouped 数据源模型
 
 模型数据源文件：mainTableViewTitleModel.plist
 */
@interface HQLTableViewCellGroupedModel : NSObject

@property (nonatomic, copy) NSString *headerTitle;
@property (nonatomic, copy) NSArray *cells; // NSArray<HQLTableViewCellStyleDefaultModel>

@end
