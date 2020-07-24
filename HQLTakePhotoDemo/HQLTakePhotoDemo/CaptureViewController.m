//
//  CaptureViewController.m
//  HQLTakePhotoDemo
//
//  Created by ToninTech on 2017/2/24.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import "CaptureViewController.h"

@interface CaptureViewController (){
    AGSimpleImageEditorView *editorView;
}

@end

@implementation CaptureViewController
@synthesize delegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加导航栏和完成按钮
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [self.view addSubview:navigationBar];
    
    UINavigationItem *navigationItem = [[UINavigationItem alloc] initWithTitle:@"图片裁剪"];
    [navigationBar pushNavigationItem:navigationItem animated:YES];
    
    //保存按钮
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(saveButton)];
    navigationItem.rightBarButtonItem = barBtnItem;
    
    // image为上一个界面传过来的图片资源
    editorView = [[AGSimpleImageEditorView alloc] initWithImage:self.image];
    editorView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    editorView.center = self.view.center;
    
    //外边框的宽度及颜色
    editorView.borderWidth = 1.f;
    editorView.borderColor = [UIColor blackColor];
    
    //截取框的宽度及颜色
    editorView.ratioViewBorderWidth = 5.f;
    editorView.ratioViewBorderColor = [UIColor orangeColor];
    
    //截取比例
    editorView.ratio = 1;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 完成截图
- (void)saveButton {
    //output为截取后的图片
    UIImage *resultImage = editorView.output;
    
    //通过代理回传给上一个界面显示
    [self.delegate passImage:resultImage];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
