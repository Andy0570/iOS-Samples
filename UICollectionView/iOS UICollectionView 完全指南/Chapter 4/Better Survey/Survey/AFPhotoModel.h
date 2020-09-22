//
//  AFPhotoModel.h
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFPhotoModel : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) UIImage *image;

+ (instancetype)photoModelWithName:(NSString *)name image:(UIImage *)image;

@end
