//
//  TopStory.h
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/26.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

@interface TopStory : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSString *imageHue; // 图像色调
@property (nonatomic, copy, readonly) NSString *hint; // 暗示
@property (nonatomic, copy, readonly) NSURL *url;
@property (nonatomic, copy, readonly) NSURL *imageURL;
@property (nonatomic, copy, readonly) NSString *title;
@property (nonatomic, copy, readonly) NSString *gaPrefix;
@property (nonatomic, copy, readonly) NSNumber *type;
@property (nonatomic, copy, readonly) NSNumber *topStoryID;

@end

NS_ASSUME_NONNULL_END
