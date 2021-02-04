//
//  HQLTabBarItem.m
//  HQLRiseTabBarDemo
//
//  Created by Qilin Hu on 2021/1/20.
//  Copyright © 2021 Tonintech. All rights reserved.
//

#import "HQLTabBarItem.h"

@interface HQLTabBarItem ()

@property (nonatomic, readwrite, copy, nonnull) NSString *normalTitle;
@property (nonatomic, readwrite, copy, nonnull) NSString *selectedTitle;

@property (nonatomic, readwrite, strong, nonnull) UIColor *normalTitleColor;
@property (nonatomic, readwrite, strong, nonnull) UIColor *selectedTitleColor;

@property (nonatomic, readwrite, copy, nonnull) NSString *normalImageName;
@property (nonatomic, readwrite, copy, nonnull) NSString *selectedImageName;

@end

@implementation HQLTabBarItem

- (instancetype)initWithNormalTitle:(NSString *)normalTitle
                      selectedTitle:(NSString *)selectedTitle
                   normalTitleColor:(UIColor *)normalTitleColor
                 selectedTitleColor:(UIColor *)selectedTitleColor
                    normalImageName:(NSString *)normalImageName
                  selectedImageName:(NSString *)selectedImageName {
    self = [super init];
    if (!self) { return nil; }
    
    self.normalTitle = normalTitle;
    self.selectedTitle = selectedTitle;
    self.normalTitleColor = normalTitleColor;
    self.selectedTitleColor = selectedTitleColor;
    self.normalImageName = normalImageName;
    self.selectedImageName = selectedImageName;
    
    return self;
}

@end
