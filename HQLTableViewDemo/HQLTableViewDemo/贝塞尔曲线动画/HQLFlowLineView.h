//
//  HQLFlowLineView.h
//  HQLTableViewDemo
//
//  Created by huqilin on 2025/8/13.
//  Copyright © 2025 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLFlowLineView : UIView

- (instancetype)initWithFrame:(CGRect)frame withSvgFile:(NSString *)fileName;

- (void)configWithCount:(NSInteger)count
                  delay:(double)delay
              direction:(NSInteger)direction
                isNight:(BOOL)isNight;

- (void)configWithLineColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
