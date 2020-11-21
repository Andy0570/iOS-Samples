//
//  AFPhotoModel.m
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFPhotoModel.h"

@implementation AFPhotoModel

+(instancetype)photoModelWithName:(NSString *)name image:(UIImage *)image
{
    AFPhotoModel *model = [[AFPhotoModel alloc] init];
    
    model.name = name;
    model.image = image;
    
    return model;
}

@end
