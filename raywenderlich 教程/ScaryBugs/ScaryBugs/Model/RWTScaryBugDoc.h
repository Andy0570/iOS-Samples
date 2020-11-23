//
//  RWTScaryBugDoc.h
//  ScaryBugs
//
//  Created by Qilin Hu on 2020/11/22.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class RWTScaryBugData;

/// 模型类，包含全尺寸的图片、缩略图，HQLScaryBugData。
@interface RWTScaryBugDoc : NSObject

@property (nonatomic, strong) RWTScaryBugData *data;
@property (nonatomic, strong) UIImage *_Nullable thumbImage;
@property (nonatomic, strong) UIImage *_Nullable fullImage;
@property (nonatomic, copy) NSString *docPath;

- (instancetype)init;
- (instancetype)initWithDocPath:(NSString *)docPath;

- (void)saveData;
- (void)saveImages;
- (void)deleteDoc;

- (instancetype)initWithTitle:(NSString *)title
                       rating:(float)rating
                   thumbImage:(UIImage *_Nullable)thumbImage
                    fullImage:(UIImage *_Nullable)fullImage;

@end

NS_ASSUME_NONNULL_END
