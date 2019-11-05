//
//  QuizViewController.m
//  1.1 Quiz
//
//  Created by ToninTech on 16/8/11.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "QuizViewController.h"

@interface QuizViewController ()

// 【视图对象】
// 属性：声明了一个插座变量（OutLet）questionLable，可以指向 UILabel 对象。
// IBOutlet：告诉 Xcode 之后会使用 Interface Builder 关联该插座变量。
@property(nonatomic, weak) IBOutlet UILabel *questionLable;
// 属性：answerLabel
@property(nonatomic, weak) IBOutlet UILabel *answerLabel;

// 【模型对象】
// 整形变量：用于跟踪用户正在回答的问题
@property(nonatomic, assign) int currentQuestionIndex;
// 属性：存储问题
@property(nonatomic, copy) NSArray *questions;
// 属性：存储答案
@property(nonatomic, copy) NSArray *answers;

@end


@implementation QuizViewController

#pragma mark - Lifecycle

// QuizViewController 对象创建完毕之后会收到消息：initWithNibName:bundle:
- (instancetype) initWithNibName:(NSString *)nibNameOrNil
                          bundle:(NSBundle *)nibBundleOrNil {
    // 调用父类实现的初始化方法
    self = [super initWithNibName:nibNameOrNil
                           bundle:nibBundleOrNil];
    if (self) {
        
        // 创建两个数组对象，存储所需要的问题和答案
        // 同时，将 questions 和 answers 分别指向问题数组和答案数组
        self.questions = @[@"From what is cognan made?",
                           @"What is 7+7?",
                           @"What is the capitabl of Vermont"];
        self.answers = @[@"Grapes",
                         @"14",
                         @"Montpelier"];
    }
    
    //返回新对象的地址
    return self;
}


#pragma mark - IBAction

// 方法：实现 Botton 动作
// IBAction：告诉 Xcode 之后会使用 Interface Builder 关联该动作。
- (IBAction)showQuestion:(id)sender{
    
    //进入下一个问题
    self.currentQuestionIndex++;
    
    //是否已经回答完了所有问题？索引==数组对象数量？；
    if (self.currentQuestionIndex == [self.questions count]) {
        
        //回到第一个问题
        self.currentQuestionIndex = 0;
    }
    
    //根据正在回答的问题序号从数组中取出问题字符串
    NSString *question = self.questions[self.currentQuestionIndex];
    
    //将问题字符串显示在标签上
    self.questionLable.text = question;
    
    //重置答案字符串
    self.answerLabel.text = @"???";
}

- (IBAction)showAnswer:(id)sender{
    //如果问题还没有显示，就不显示答案
    BOOL isQuestionLabelNull = [self.questionLable.text isEqualToString:@""];
    if (isQuestionLabelNull) {
        return;
    }
    //当前问题的答案是什么?
    NSString *answer = self.answers[self.currentQuestionIndex];
    
    //在答案标签上显示相应的内容
    self.answerLabel.text = answer;
}

@end
