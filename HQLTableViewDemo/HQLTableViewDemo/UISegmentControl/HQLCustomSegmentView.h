//
//  HQLCustomSegmentView.h
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/3/28.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CustomSegmentViewSelectBlock)(NSInteger buttonIndex);

@interface HQLCustomSegmentView : UIView
@property (nonatomic, copy) CustomSegmentViewSelectBlock selectBlock;

- (instancetype)initWithLeftTitle:(NSString *)leftTitle rightTitle:(NSString *)rightTitle;
- (instancetype)init NS_UNAVAILABLE;

- (void)selectItemAtIndex:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
