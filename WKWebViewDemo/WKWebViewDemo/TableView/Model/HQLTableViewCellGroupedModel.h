//
//  HQLTableViewCellGroupedModel.h
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Mantle.h>

/**
 UITableViewStyleGrouped 数据源模型
 
 模型数据源文件：mainTableViewTitleModel.plist
 */
@interface HQLTableViewCellGroupedModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *headerTitle;
@property (nonatomic, copy, readonly) NSArray *cells; // NSArray<HQLTableViewCellStyleDefaultModel>

@end
