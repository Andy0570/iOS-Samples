//
//  HQLDataModel.h
//  HQLTableViewDemo
//
//  Created by ToninTech on 2016/12/21.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 数据模型
 */
@interface HQLDataModel : NSObject

/** 分组状态标记*/
@property (nonatomic,assign) BOOL isOpen;
/** 分组名*/
@property (nonatomic,copy) NSString *groupName;
/** 每组数组*/
@property (nonatomic, assign)NSInteger groupCount;
/** 分组各行数据*/
@property (nonatomic,retain) NSArray *modelArray;

/** 指定初始化方法*/
- (instancetype)initWithState:(BOOL *)isOpen
                    groupName:(NSString *)groupName
                   groupCount:(NSInteger )groupCount 
                   modelArray:(NSArray *)modelArray;

@end
