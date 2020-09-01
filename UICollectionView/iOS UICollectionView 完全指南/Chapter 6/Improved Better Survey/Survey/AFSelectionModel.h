//
//  AFSelectionModel.h
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSUInteger AFSelectionModelNoSelectionIndex;

@interface AFSelectionModel : NSObject

+(instancetype)selectionModelWithPhotoModels:(NSArray *)photoModels;

@property (nonatomic, strong, readonly) NSArray *photoModels;
@property (nonatomic, assign) NSUInteger selectedPhotoModelIndex;
@property (nonatomic, readonly) BOOL hasBeenSelected;

@end
