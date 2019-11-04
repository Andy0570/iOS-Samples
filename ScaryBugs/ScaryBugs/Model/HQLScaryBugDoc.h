//
//  HQLScaryBugDoc.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class HQLScaryBugData;

/**
 模型类
 包含全尺寸的图像，缩略图，HQLScaryBugData。
 */
@interface HQLScaryBugDoc : NSObject

@property (nonatomic, strong) HQLScaryBugData *data;
@property (nonatomic, strong) UIImage *thumbImage;
@property (nonatomic, strong) UIImage *fullImage;
@property (nonatomic, copy) NSString *docPath;

- (instancetype)init;
- (instancetype)initWithDocPath:(NSString *)docPath;

- (void)saveData;
- (void)saveImages;
- (void)deleteDoc;

- (instancetype)initWithTitle:(NSString *)title
                       rating:(float)rating
                   thumbImage:(UIImage *)thumbImage
                    fullImage:(UIImage *)fullImage;

@end
