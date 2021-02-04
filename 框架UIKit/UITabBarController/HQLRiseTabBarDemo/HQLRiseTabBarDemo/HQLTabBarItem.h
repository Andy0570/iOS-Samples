//
//  HQLTabBarItem.h
//  HQLRiseTabBarDemo
//
//  Created by Qilin Hu on 2021/1/20.
//  Copyright © 2021 Tonintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HQLTabBarItem : NSObject

@property (nonatomic, readonly, copy, nonnull) NSString *normalTitle;
@property (nonatomic, readonly, copy, nonnull) NSString *selectedTitle;

@property (nonatomic, readonly, strong, nonnull) UIColor *normalTitleColor;
@property (nonatomic, readonly, strong, nonnull) UIColor *selectedTitleColor;

@property (nonatomic, readonly, copy, nonnull) NSString *normalImageName;
@property (nonatomic, readonly, copy, nonnull) NSString *selectedImageName;

@property (nonatomic, copy) NSString *markText;
@property (nonatomic, assign, getter=shouldShowMarkText) BOOL showMarkText;
@property (nonatomic, copy) NSString *tabIdentifier;

- (instancetype)initWithNormalTitle:(NSString *)normalTitle
                      selectedTitle:(NSString *)selectedTitle
                   normalTitleColor:(UIColor *)normalTitleColor
                 selectedTitleColor:(UIColor *)selectedTitleColor
                    normalImageName:(NSString *)normalImageName
                  selectedImageName:(NSString *)selectedImageName;

@end

NS_ASSUME_NONNULL_END
