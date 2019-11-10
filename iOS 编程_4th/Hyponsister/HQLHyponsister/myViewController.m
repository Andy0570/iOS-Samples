//
//  myViewController.m
//  HQLHyponsister
//
//  Created by ToninTech on 16/8/15.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "myViewController.h"
#import "HQLHypnosisView.h"
#import "HQLPictureView.h"

@implementation myViewController

- (void)viewDidLoad {
    
    /*
    //----------------------创建一个超大视图--------------------------
    // 根视图控制器 中放 UIScrollView ,UIScrollView 中放 HyponsisView
    
    // UIScrollView
    CGRect screenRect = self.view.frame;
    
    // HyponsisView
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;
    bigRect.size.height *= 2.0;
    
    //创建一个 UIScrollView 对象，将其尺寸设置为窗口大小
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    
    self.view = scrollView;
    
    //创建一个有着超大尺寸的 HQLHypnosisView 对象并将其加入 UIScrollView 对象
    HQLHypnosisView *hyponsisView = [[HQLHypnosisView alloc] initWithFrame:bigRect];
    
    [scrollView addSubview:hyponsisView];
    
    //告诉 UIScrollView 对象“取景”范围有多大
    scrollView.contentSize = bigRect.size;
     
     */
    
    
    //---------------------拖动与分页------------------------
    /**
     *  UIScrollView对象的分页实现原理是：UIScrollView 对象会根据其 bounds 的尺寸，将contentSize 分割为尺寸相同的多个区域。拖动结束后，UIScrollView 实例会自动滚动并只显示其中的一个区域。
     */
    
    //创建两个 CGRect 结构分别作为 UIScrollView 对象和 HQLHypnosisView 对象的 frame
    
    CGRect screenRect = self.view.frame;
    
    //设置 UIScrollView 对象的 contentSize 的宽度是屏幕宽度的2倍，高度不变
    CGRect bigRect = screenRect;
    bigRect.size.width *= 2.0;

    //创建一个 UIScrollView 对象，将其尺寸设置为窗口大小
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:screenRect];
    
    //设置UIScrollView 对象的“镜头”的边和其显示的某个视图的边对齐
    [scrollView setPagingEnabled:YES];
    
    self.view = scrollView;
    
    //创建第一个大小与屏幕相同的 HQLPictureView 对象并将其加入 UIScrollView 对象
    HQLPictureView *pictureView = [[HQLPictureView alloc] initWithFrame:screenRect];
    [scrollView addSubview:pictureView];
    
    //创建第二个大小与屏幕相同的 HQLHypnosisView 对象并放置在第一个 HQLPictureView 对象的右侧，使其刚好移除屏幕外
    screenRect.origin.x +=screenRect.size.width;
    
    HQLHypnosisView *anotherView = [[HQLHypnosisView alloc] initWithFrame:screenRect];
    
    [scrollView addSubview:anotherView];
    
    //告诉 UIScrollView 对象“取景”范围有多大
    scrollView.contentSize = bigRect.size;

}


@end
