//
//  HQLActivityDetailDataSource.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/5/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLActivityDetailDataSource.h"

@implementation HQLActivityDetailDataSource

- (instancetype)init {
    self = [super init];
    if (self) {
        _model = [NSMutableArray arrayWithObjects:@"activityImage_1",@"activityImage_2",@"activityImage_3",@"activityImage_4",@"activityImage_5",@"activityImage_6", nil];
    }
    return self;
}

@end
