//
//  DemoLayout.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "DemoLayout.h"

@implementation DemoLayout

- (TangramLayoutType *)layoutType {
    return [NSString stringWithFormat:@"xxxxx_%lu", self.index];
}

@end
