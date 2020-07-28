//
//  ChooseLocationView.h
//  ChooseLocation
//
//  Created by Sekorm on 16/8/22.
//  Copyright © 2016年 HY. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 UIScrollView 做成了分页选择器，每一页都是一个 UITableView，
 */
@interface ChooseLocationView : UIView

@property (nonatomic, copy) NSString *address;  // 地址
@property (nonatomic, copy) NSString *areaCode; // 地址代码
// 选择完成后的执行的回调 Block
@property (nonatomic, copy) dispatch_block_t chooseFinish;

@end
