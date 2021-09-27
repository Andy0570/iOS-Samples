//
//  HQLImageCompositionViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2021/9/18.
//  Copyright © 2021 Qilin Hu. All rights reserved.
//

#import "HQLImageCompositionViewController.h"
#import "UIImage+Composition.h"

@interface HQLImageCompositionViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet UIImageView *imageView3;
@end

@implementation HQLImageCompositionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

// 直接绘图合成
- (IBAction)imageComopressMethod1:(id)sender {
    UIImage *frontImage = [UIImage imageNamed:@"Icon-2.png"];
    UIImage *backImage = [UIImage imageNamed:@"flower.jpg"];
    
    UIImage *compositionImage = [UIImage compositionWithBackImage:backImage frontImage:frontImage];
    self.imageView3.image = compositionImage;
}

// CoreGraphic
- (IBAction)imageComopressMethod2:(id)sender {
    UIImage *frontImage = [UIImage imageNamed:@"Icon-2.png"];
    UIImage *backImage = [UIImage imageNamed:@"flower.jpg"];
    
    UIImage *compositionImage = [UIImage compositionCoreGraphicsWithBackImage:backImage frontImage:frontImage];
    self.imageView3.image = compositionImage;
}

// GPUImage
- (IBAction)imageComopressMethod3:(id)sender {
    
}

// CoreImage
- (IBAction)imageComopressMethod4:(id)sender {
    
}

@end
