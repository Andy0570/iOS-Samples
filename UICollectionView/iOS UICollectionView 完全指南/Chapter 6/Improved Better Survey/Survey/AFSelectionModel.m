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

+(instancetype)selectionModelWithPhotoModels:(NSArray *)photoModels
{
    AFSelectionModel *model = [[AFSelectionModel alloc] init];
    
    model.photoModels = photoModels;
    model.selectedPhotoModelIndex = AFSelectionModelNoSelectionIndex;
    
    return model;
}

-(BOOL)hasBeenSelected
{
    return self.selectedPhotoModelIndex != AFSelectionModelNoSelectionIndex;
}

@end
