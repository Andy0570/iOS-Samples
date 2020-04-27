//
//  NSDictionary+Extension.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extension)

/**
 填充 value 为空造成的 crash

 @return 修改后的NSDictionary
 */
- (NSDictionary *)deleteAllNULLValue;

@end

NS_ASSUME_NONNULL_END
