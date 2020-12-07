//
//  AFSelectionModel.h
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSUInteger AFSelectionModelNoSelectionIndex;

// AFSelectionModel 类用于指定一组单元格，以及哪个单元格被选中了
@interface AFSelectionModel : NSObject

@property (nonatomic, strong, readonly) NSArray *photoModels;
@property (nonatomic, assign) NSUInteger selectedPhotoModelIndex;
@property (nonatomic, readonly) BOOL hasBeenSelected;

+ (instancetype)selectionModelWithPhotoModels:(NSArray *)photoModels;

@end
