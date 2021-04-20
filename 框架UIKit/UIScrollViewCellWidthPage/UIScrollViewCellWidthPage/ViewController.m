//
//  ViewController.m
//  UIScrollViewCellWidthPage
//
//  Created by 王顺 on 2017/3/10.
//  Copyright © 2017年 shun wang. All rights reserved.
//

#import "ViewController.h"
#import "EHPracticeWordCardScrollView.h"
@interface ViewController ()
@property (nonatomic, strong) EHPracticeWordCardScrollView *wordCardView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.wordCardView];
    self.wordCardView.frame = CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (EHPracticeWordCardScrollView *)wordCardView {
    if(_wordCardView == nil) {
        _wordCardView = [[[NSBundle mainBundle] loadNibNamed:@"EHPracticeWordCardScrollView" owner:nil options:nil] firstObject];
    }
    return _wordCardView;
}
@end
