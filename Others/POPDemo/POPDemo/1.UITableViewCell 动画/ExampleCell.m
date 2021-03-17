//
//  ExampleCell.m
//  POPDemo
//
//  Created by Simon Ng on 19/12/14.
//  Copyright (c) 2014 AppCoda. All rights reserved.
//

#import "ExampleCell.h"

// Frameworks
#import <POP.h>


@implementation ExampleCell


#pragma mark - View life cycle

- (void)awakeFromNib {
    [super awakeFromNib];
    
    // Initialization code
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.textLabel.font = [UIFont fontWithName:@"Avenir-Light" size:24];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - Override

/**
 用户点击时，添加放大效果，手放开时，使用 spring 动画返回
 */
- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated {
    [super setHighlighted:highlighted animated:animated];
    
    if (self.highlighted) {
        // 添加放大效果
        POPBasicAnimation *scaleAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        scaleAnimation.duration = 0.1;
        scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(1, 1)];
        [self.textLabel pop_addAnimation:scaleAnimation forKey:@"scalingUp"];
    } else {
        // 添加 spring 弹簧动画
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        springAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.9, 0.9)];
        // 当前速度
        springAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(2, 2)];
        /**
         有效弹力
         
         与'springSpeed'配合使用，可以改变弹簧动画效果。
         值被转换为相应的动态常数。较高的值会增加弹簧的运动范围，从而产生更多的振荡和弹力。
         定义为 [0, 20] 范围内的值。默认值为 4。
         */
        springAnimation.springBounciness = 20.f;
        [self.textLabel pop_addAnimation:springAnimation forKey:@"springAnimation"];
    }
}

@end
