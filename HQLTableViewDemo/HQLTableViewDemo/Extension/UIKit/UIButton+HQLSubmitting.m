//
//  UIButton+HQLSubmitting.m
//  SeaTao
//
//  Created by Qilin Hu on 2020/6/6.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "UIButton+HQLSubmitting.h"
#import  <objc/runtime.h>

@interface UIButton ()

@property(nonatomic, strong) UIView *hql_modalView;
@property(nonatomic, strong) UIActivityIndicatorView *hql_spinnerView;
@property(nonatomic, strong) UILabel *hql_spinnerTitleLabel;

@end

@implementation UIButton (HQLSubmitting)

- (void)hql_beginSubmitting:(NSString *)title {
    [self hql_endSubmitting];
    
    self.hql_submitting = @YES;
    self.hidden = YES;
    
    self.hql_modalView = [[UIView alloc] initWithFrame:self.frame];
    // MARK: 背景颜色设置为主题色
    // self.hql_modalView.backgroundColor = [self.backgroundColor colorWithAlphaComponent:0.6];
    UIColor *themeColor = [UIColor colorWithRed:83/255.0 green:202/255.0 blue:195/255.0 alpha:1.0];
    self.hql_modalView.backgroundColor = [themeColor colorWithAlphaComponent:0.6];
    self.hql_modalView.layer.cornerRadius = self.layer.cornerRadius;
    self.hql_modalView.layer.borderWidth = self.layer.borderWidth;
    self.hql_modalView.layer.borderColor = self.layer.borderColor;
    
    CGRect viewBounds = self.hql_modalView.bounds;
    self.hql_spinnerView = [[UIActivityIndicatorView alloc]
                            initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    self.hql_spinnerView.tintColor = self.titleLabel.textColor;
    
    CGRect spinnerViewBounds = self.hql_spinnerView.bounds;
    self.hql_spinnerView.frame = CGRectMake(
                                        15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                        spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    self.hql_spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.hql_spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.hql_spinnerTitleLabel.text = title;
    self.hql_spinnerTitleLabel.font = self.titleLabel.font;
    self.hql_spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.hql_modalView addSubview:self.hql_spinnerView];
    [self.hql_modalView addSubview:self.hql_spinnerTitleLabel];
    [self.superview addSubview:self.hql_modalView];
    [self.hql_spinnerView startAnimating];
}

- (void)hql_endSubmitting {
    if (!self.isHQLSubmitting.boolValue) {
        return;
    }
    
    self.hql_submitting = @NO;
    self.hidden = NO;
    
    [self.hql_modalView removeFromSuperview];
    self.hql_modalView = nil;
    self.hql_spinnerView = nil;
    self.hql_spinnerTitleLabel = nil;
}

- (NSNumber *)isHQLSubmitting {
    return objc_getAssociatedObject(self, @selector(setHql_submitting:));
}

- (void)setHql_submitting:(NSNumber *)submitting {
    objc_setAssociatedObject(self, @selector(setHql_submitting:), submitting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIActivityIndicatorView *)hql_spinnerView {
    return objc_getAssociatedObject(self, @selector(setHql_spinnerView:));
}

- (void)setHql_spinnerView:(UIActivityIndicatorView *)spinnerView {
    objc_setAssociatedObject(self, @selector(setHql_spinnerView:), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)hql_modalView {
    return objc_getAssociatedObject(self, @selector(setHql_modalView:));
}

- (void)setHql_modalView:(UIView *)modalView {
    objc_setAssociatedObject(self, @selector(setHql_modalView:), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)hql_spinnerTitleLabel {
    return objc_getAssociatedObject(self, @selector(setHql_spinnerTitleLabel:));
}

- (void)setHql_spinnerTitleLabel:(UILabel *)spinnerTitleLabel {
    objc_setAssociatedObject(self, @selector(setHql_spinnerTitleLabel:), spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end
