//
//  AFModel.h
//  Performance Problems Example II
//
//  Created by Ash Furrow on 2012-12-28.
//  Copyright (c) 2012 Ash Furrow. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AFModel : NSObject

+(instancetype)modelWithComment:(NSString *)comment color:(UIColor *)color;

@property (nonatomic, copy) NSString *comment;
@property (nonatomic, strong) UIColor *color;

@end
