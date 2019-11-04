//
//  HQLPasswordInputView.h
//  XuZhouSS
//
//  Created by ToninTech on 2017/3/6.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^ReturnPasswordStringBlock)(NSString *password);

/**
 支付密码方格
 */
@interface HQLPasswordInputView : UIView

@property (nonatomic,copy) ReturnPasswordStringBlock returnPasswordStringBlock;

@end
