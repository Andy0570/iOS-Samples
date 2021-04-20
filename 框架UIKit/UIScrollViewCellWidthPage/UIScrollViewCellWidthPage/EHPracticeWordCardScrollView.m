//
//  EHPracticeWordCardScrollView.m
//  UICollectionViewCellWidthPage
//
//  Created by 王顺 on 2017/3/10.
//  Copyright © 2017年 shun. All rights reserved.
//

#import "EHPracticeWordCardScrollView.h"
#import "EHPracticeWordCardScrollViewCell.h"

#define CellWidth [UIScreen mainScreen].bounds.size.width - 40
#define CellSpace 10
#define dataScourceCount 9
#define CellCount 10
#define MainScreenWidh [UIScreen mainScreen].bounds.size.width
@interface EHPracticeWordCardScrollView () <UIScrollViewDelegate>

@end
@implementation EHPracticeWordCardScrollView


- (void)awakeFromNib {
    [super awakeFromNib];
    self.scorllView.contentSize = CGSizeMake(MainScreenWidh * (CellCount-1), self.scorllView.bounds.size.height);
    self.scorllView.pagingEnabled = YES;
    self.scorllView.clipsToBounds = NO;
    self.scorllView.delegate = self;
    for (int i = 0; i < CellCount; i++) {
        EHPracticeWordCardScrollViewCell *cell = [EHPracticeWordCardScrollViewCell getWordCardCellWithIndex:i];
        [self.scorllView addSubview:cell];
        cell.frame = CGRectMake(self.scorllView.frame.size.width * i, 0, self.scorllView.frame.size.width , self.scorllView.frame.size.height);
    }
    self.scorllView.contentOffset = CGPointMake(-20, 0);
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    if ([self pointInside:point withEvent:event]) {
        return self.scorllView;
    }
    return nil;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    double pageDouble = scrollView.contentOffset.x / self.scorllView.frame.size.width;
    NSInteger page = round(pageDouble);
    // 第一页和最后一页，自定义偏移量
    if (page == 0) {
        [self.scorllView setContentOffset:CGPointMake(15, 0) animated:YES];
    } else if (page == CellCount -1) {
        [self.scorllView setContentOffset:CGPointMake(self.scorllView.frame.size.width * (CellCount -1) - 15, 0) animated:YES];
    }
    NSLog(@"scrollViewDidEndDeceleratingpage : %zd", page);
}

@end
