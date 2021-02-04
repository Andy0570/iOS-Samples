//
//  AFSelectionModel.m
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFSelectionModel.h"

const NSUInteger AFSelectionModelNoSelectionIndex = -1;

@interface AFSelectionModel ()

@property (nonatomic, strong) NSArray *photoModels;

@end

@implementation AFSelectionModel

+ (instancetype)selectionModelWithPhotoModels:(NSArray *)photoModels {
    AFSelectionModel *model = [[AFSelectionModel alloc] init];
    model.photoModels = photoModels;
    model.selectedPhotoModelIndex = AFSelectionModelNoSelectionIndex;
    return model;
}

/**
 初始化时，默认索引值为 -1，如果当前索引值 != -1，则表明该 section 已经选中了某一个 cell
 */
- (BOOL)hasBeenSelected {
    return self.selectedPhotoModelIndex != AFSelectionModelNoSelectionIndex;
}

@end
