//
//  CaptureViewController.h
//  HQLTakePhotoDemo
//
//  Created by ToninTech on 2017/2/24.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AGSimpleImageEditorView.h"
#import "PassImageDelegate.h"

@interface CaptureViewController : UIViewController

@property (nonatomic,strong) UIImage *image;
@property (nonatomic,strong) NSObject <PassImageDelegate> *delegate;

@end
