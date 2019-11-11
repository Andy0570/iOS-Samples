//
//  RateView.h
//  CustomView
//
//  Created by Qilin Hu on 2017/12/27.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 参考教程：
https://www.raywenderlich.com/1768/uiview-tutorial-for-ios-how-to-make-a-custom-uiview-in-ios-5-a-5-star-rating-view
**/

@class RateView;

@protocol RateViewDelegate
// 代理协议：评分改变时，通知视图控制器
- (void)rateView:(RateView *)rateView ratingDidChange:(float)rating;
@end

@interface RateView : UIView

@property (nonatomic, strong) UIImage *notSelectedImage;
@property (nonatomic, strong) UIImage *halfSelectedImage;
@property (nonatomic, strong) UIImage *fullSelectedImage;
@property (nonatomic, assign) float rating;
@property (nonatomic, assign) BOOL editable;
@property (nonatomic, strong) NSMutableArray *imageViews;
@property (nonatomic, assign) int maxRating;
@property (nonatomic, assign) int midMargin;
@property (nonatomic, assign) int leftMargin;
@property (nonatomic, assign) CGSize minImageSize;
@property (nonatomic, weak) id <RateViewDelegate> delegate;

@end
