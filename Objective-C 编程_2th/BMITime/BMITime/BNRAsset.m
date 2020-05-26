//
//  BNRAsset.m
//  BMITime
//
//  Created by ToninTech on 2017/3/27.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "BNRAsset.h"
#import "BNREmployee.h"

@implementation BNRAsset

- (NSString *)description {
//    return [NSString stringWithFormat:@"<%@:$%u>",self.label,self.resaleValue];
    
    // holder 是否为非 nil
    if (self.holder) {
        return [NSString stringWithFormat:@"<%@: $%d>, assigned to %@",self.label,self
                .resaleValue,self.holder];
    }else {
        return [NSString stringWithFormat:@"<%@:$%u>",self.label,self.resaleValue];
    }
}

- (void)dealloc {
    NSLog(@"deallocaing %@",self);
}

@end
