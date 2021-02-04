//
//  SimpleModel.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/5/11.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "SimpleModel.h"

@implementation SimpleModel

- (instancetype)init {
    self = [super init];
    if (self) {
        NSMutableArray *section1 = [NSMutableArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6", nil];
        NSMutableArray *section2 = [NSMutableArray arrayWithObjects:@"A",@"B",@"C",@"D",@"E",@"F", nil];
        _model = [NSMutableArray arrayWithObjects:section1,section2, nil];
    }
    return self;
}

@end
