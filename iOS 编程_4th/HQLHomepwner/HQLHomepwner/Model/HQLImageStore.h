//
//  HQLImageStore.h
//  HQLHomepwner
//
//  Created by ToninTech on 2016/12/2.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 保存用户所拍的所有照片
 */
@interface HQLImageStore : NSObject

+ (instancetype)sharedStore;

- (void)setImage:(UIImage *)image forKey:(NSString *)key;
- (UIImage *)imageForKey:(NSString *)key;
- (void)deleteImageForKey:(NSString *)key;

@end
