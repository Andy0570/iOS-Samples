//
//  Story.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface Story : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *imageHue; // 图像色调
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSString *hint; // 暗示
@property (nonatomic, copy, readonly) NSString *gaPrefix;
@property (nonatomic, copy, readonly) NSArray *images;
@property (nonatomic, copy, readonly) NSNumber *type;
@property (nonatomic, copy, readonly) NSNumber *storyID;

@end

NS_ASSUME_NONNULL_END
