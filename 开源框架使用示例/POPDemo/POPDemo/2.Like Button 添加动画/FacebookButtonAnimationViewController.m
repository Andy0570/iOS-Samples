//
//  FacebookButtonAnimationViewController.m
//  POPDemo
//
//  Created by Qilin Hu on 2020/5/9.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "FacebookButtonAnimationViewController.h"

// Frameworks
#import <POP.h>

@interface FacebookButtonAnimationViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet UITextField *msgTextField;

@end

@implementation FacebookButtonAnimationViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.msgTextField.delegate = self;
    // 初始化时，隐藏发送按钮
    self.sendButton.hidden = YES;
    self.likeButton.hidden = NO;
}


#pragma mark - Private

// 显示「发送」按钮
- (void)showSendButton {
    if (self.sendButton.isHidden) {
        self.likeButton.hidden = YES;
        self.sendButton.hidden = NO;
        
        // 给 Send 按钮添加一个属性为 kPOPViewScaleXY 属性的 spring 动画
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewScaleXY];
        springAnimation.velocity = [NSValue valueWithCGPoint:CGPointMake(8, 8)];
        springAnimation.springBounciness = 20.0f;
        [self.sendButton pop_addAnimation:springAnimation forKey:@"sendAnimation"];
    }
}

// 显示「喜欢」按钮
- (void)showLikeButton {

    if (self.likeButton.isHidden) {
        self.sendButton.hidden = YES;
        self.likeButton.hidden = NO;
        
        // 给 Like 按钮的 layer 添加旋转动画，Like 按钮会从 45 度 (M_PI/4) 翻转到 0 度
        POPSpringAnimation *springAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerRotation];
        springAnimation.fromValue = @(M_PI_4);
        springAnimation.toValue = @(0);
        springAnimation.springBounciness = 20.0f;
        springAnimation.velocity = @(10);
        [self.likeButton.layer pop_addAnimation:springAnimation forKey:@"likeAnimation"];
    }
}


#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString *comment;
    
    if (range.length == 0) {
        comment = [NSString stringWithFormat:@"%@%@", textField.text, string];
    } else {
        comment = [textField.text substringToIndex:textField.text.length - range.length];
    }
    
    // 如果 text field 为空，将显示 Like 按钮，如果不为空，则显示 Send 按钮
    if (comment.length == 0) {
        // Show Like
        [self showLikeButton];
    } else  {
        // Show Send
        [self showSendButton];
    }
    
    return YES;
}

@end
