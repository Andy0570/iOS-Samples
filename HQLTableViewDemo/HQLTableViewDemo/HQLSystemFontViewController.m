//
//  HQLSystemFontViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/11/28.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLSystemFontViewController.h"
#import <Chameleon.h>

@interface HQLSystemFontViewController ()
@property (nonatomic, strong) UITextView *textView;
@end

@implementation HQLSystemFontViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.textView = [[UITextView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.textView];
    
    [self showSystemFont];
}

// 循环遍历系统所有字体
- (void)showSystemFont {
    NSMutableAttributedString *fontString = [[NSMutableAttributedString alloc] init];
    
    for (NSString *familyName in UIFont.familyNames) {
        // 输出字体族科名字
        NSString *familyNameString = [NSString stringWithFormat:@"Font Family:%@\n", familyName];
        NSDictionary *attributes = @{
            NSFontAttributeName: [UIFont boldSystemFontOfSize:18],
            NSForegroundColorAttributeName: UIColor.flatWatermelonColorDark
        };
        NSAttributedString *familyNameAttrsString = [[NSAttributedString alloc] initWithString:familyNameString attributes:attributes];
        [fontString appendAttributedString:familyNameAttrsString];
        
        for (NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
            // 输出字体族科下字样名字
            NSString *fontNameString = [NSString stringWithFormat:@"Font Name:%@\n",fontName];
            NSDictionary *attributes = @{
                NSFontAttributeName: [UIFont boldSystemFontOfSize:14],
                NSForegroundColorAttributeName: UIColor.flatWatermelonColor
            };
            NSAttributedString *fontNameAttributedString = [[NSAttributedString alloc] initWithString:fontNameString attributes:attributes];
            [fontString appendAttributedString:fontNameAttributedString];
        }
    }
    
    self.textView.attributedText = fontString;
}


@end
