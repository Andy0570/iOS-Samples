//
//  HQLWebFooterView.h
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/14.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^WebFooterViewHeightUpdateBlock)(CGFloat webViewHeight);

@interface HQLWebFooterView : UIView

@property (nonatomic, copy) NSString *HTMLString;
@property (nonatomic, copy) WebFooterViewHeightUpdateBlock heightUpdateBlock;

@end

NS_ASSUME_NONNULL_END
