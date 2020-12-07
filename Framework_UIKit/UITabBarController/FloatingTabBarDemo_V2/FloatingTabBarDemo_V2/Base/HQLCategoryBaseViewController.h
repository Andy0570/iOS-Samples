//
//  HQLCategoryBaseViewController.h
//  FloatingTabBarDemo
//
//  Created by Qilin Hu on 2020/8/14.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <JXCategoryView.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLCategoryBaseViewController : UIViewController <JXCategoryListContainerViewDelegate>

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) JXCategoryBaseView *categoryBaseView;
@property (nonatomic, strong) JXCategoryListContainerView *categoryListContainerView;

- (JXCategoryBaseView *)preferredCategoryView;
- (CGFloat)preferredCategoryViewHeight;

@end

NS_ASSUME_NONNULL_END
