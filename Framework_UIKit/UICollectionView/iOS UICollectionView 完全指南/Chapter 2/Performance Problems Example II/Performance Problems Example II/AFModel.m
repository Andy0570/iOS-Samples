//
//  AFModel.m
//  Performance Problems Example II
//
//  Created by Ash Furrow on 2012-12-28.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import "AFModel.h"

@implementation AFModel

+(instancetype)modelWithComment:(NSString *)comment color:(UIColor *)color;
{
    AFModel *model;
    
    if (!(model = [[AFModel alloc] init])) return nil;
    
    model.comment = comment;
    model.color = color;
    
    return model;
}

@end
