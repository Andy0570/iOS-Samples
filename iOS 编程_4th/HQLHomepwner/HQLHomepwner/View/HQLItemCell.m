//
//  HQLItemCell.m
//  HQLHomepwner
//
//  Created by ToninTech on 2017/5/18.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "HQLItemCell.h"

@interface HQLItemCell ()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint *imageViewHeightConstraint;

@end

@implementation HQLItemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self updateInterfaceForDynamicTypeSize];
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self
                      selector:@selector(updateInterfaceForDynamicTypeSize)
                          name:UIContentSizeCategoryDidChangeNotification
                        object:nil];
    // 占位符约束
    [NSLayoutConstraint constraintWithItem:self.thumbnailView
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:self.thumbnailView
                                 attribute:NSLayoutAttributeWidth
                                multiplier:1
                                  constant:0];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}


#pragma mark - IBActions

// 显示全尺寸图片
- (IBAction)showImage:(id)sender {
    // 调用 Block 对象之前要检查 Block 对象是否存在
    if (self.actionBlock) {
        self.actionBlock();
    }
}


#pragma mark - Private

- (void)updateInterfaceForDynamicTypeSize {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    static NSDictionary *imageSizeDictionary;
    if (!imageSizeDictionary) {
        imageSizeDictionary = @{
                                @"UICTContentSizeCategoryXS" : [NSNumber numberWithInt:44],
                                @"UICTContentSizeCategoryS" : [NSNumber numberWithInt:50],
                                @"UICTContentSizeCategoryM" : [NSNumber numberWithInt:55],
                                @"UICTContentSizeCategoryL" : [NSNumber numberWithInt:60],
                                @"UICTContentSizeCategoryXL" : [NSNumber numberWithInt:70],
                                @"UICTContentSizeCategoryXXL" : [NSNumber numberWithInt:80],
                                @"UICTContentSizeCategoryXXXL" : [NSNumber numberWithInt:90],
                                @"UICTContentSizeCategoryAccessibilityM" : [NSNumber numberWithInt:100],
                                @"UICTContentSizeCategoryAccessibilityL" : [NSNumber numberWithInt:105],
                                @"UICTContentSizeCategoryAccessibilityXL" : [NSNumber numberWithInt:110],
                                @"UICTContentSizeCategoryAccessibilityXXL" : [NSNumber numberWithInt:115],
                                @"UICTContentSizeCategoryAccessibilityXXXL" : [NSNumber numberWithInt:120],
                                };
                            
    }
    NSString *userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber *imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraint.constant = imageSize.floatValue;
}

@end
