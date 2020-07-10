//
//  HQLTableViewCellStyleDefaultModel.h
//  Xcode Project
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Mantle.h>
#import "UITableViewCell+ConfigureModel.h"

/**
 UITableViewCell 数据源模型
 
 默认样式 UITableViewCellStyleDefault
 */
@interface HQLTableViewCellStyleDefaultModel : MTLModel <MTLJSONSerializing, HQLTableViewCellConfigureDelegate>

@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *image;

@end
