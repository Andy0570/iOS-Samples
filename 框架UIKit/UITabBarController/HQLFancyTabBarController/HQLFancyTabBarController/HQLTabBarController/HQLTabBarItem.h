//
//  HQLTabBarItem.h
//  HQLTabBarController
//
//  Created by Qilin Hu on 2021/3/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLTabBarItem : UIControl

/// itemHeight 是一个可选属性，可以使用它来代替 tabBar 的 height
@property (nonatomic, assign) CGFloat itemHeight;

#pragma mark - 标题

@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) UIOffset titlePositionAdjustment;
@property (nonatomic, copy) NSDictionary *unselectedTitleAttributes;
@property (nonatomic, copy) NSDictionary *selectedTitleAttributes;

#pragma mark - 图片

@property (nonatomic, assign) UIOffset imagePositionAdjustment;
@property (nonatomic, strong) UIImage *selectedImage;
@property (nonatomic, strong) UIImage *unselectedImage;

- (void)setSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage;

#pragma mark - 背景图片

@property (nonatomic, strong) UIImage *backgroundSelectedImage;
@property (nonatomic, strong) UIImage *backgroundUnselectedImage;

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage;

#pragma mark - Badge 角标

@property (nonatomic, copy) NSString *badgeValue;
@property (strong) UIColor *badgeTextColor;
@property (nonatomic) UIFont *badgeTextFont;
@property (strong) UIImage *badgeBackgroundImage;
@property (strong) UIColor *badgeBackgroundColor;
@property (nonatomic) UIOffset badgePositionAdjustment;

@end

NS_ASSUME_NONNULL_END
