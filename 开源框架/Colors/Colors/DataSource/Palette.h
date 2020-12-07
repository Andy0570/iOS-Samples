//
//  Palette.h
//  Colors
//
//  Created by Qilin Hu on 2020/7/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Color;

NS_ASSUME_NONNULL_BEGIN

@interface Palette : NSObject

@property (nonatomic, readonly) NSMutableArray *colors;

+ (instancetype)sharedPalette;

- (void)reloadAll;
- (void)removeColor:(Color *)color;
- (void)removeAll;

@end

NS_ASSUME_NONNULL_END
