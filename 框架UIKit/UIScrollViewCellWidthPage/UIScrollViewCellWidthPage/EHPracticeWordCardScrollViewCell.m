//
//  EHPracticeWordCardViewCell.m
//  toeflWord
//
//  Created by shun on 2016/12/14.
//  Copyright © 2016年 enhance. All rights reserved.
//

#import "EHPracticeWordCardScrollViewCell.h"

#ifndef HexRGBAlpha
#define HexRGBAlpha(rgbValue, a) [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16))/255.0 green: ((float)((rgbValue & 0xFF00) >> 8))/255.0 blue: ((float)(rgbValue & 0xFF))/255.0 alpha: (a)]
#endif

@interface EHPracticeWordCardScrollViewCell ()
@property (weak, nonatomic) IBOutlet UIView *CollectionContentView;
@property (weak, nonatomic) IBOutlet UILabel *wordCurrentIndexLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *pronLabel;
@property (weak, nonatomic) IBOutlet UILabel *wordCategoryLabel;
@property (nonatomic, assign) NSInteger unitCount;
@property (nonatomic, assign) NSInteger index;
@end
@implementation EHPracticeWordCardScrollViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    /// 阴影圆角
    self.CollectionContentView.backgroundColor = [UIColor colorWithRed:36/255.0 green:186/255.0 blue:168/255.0 alpha:1];
    self.CollectionContentView.layer.shadowOffset = CGSizeMake(0, 2);
    self.CollectionContentView.layer.shadowOpacity = 1;
    self.CollectionContentView.layer.shadowRadius = 4;
    self.CollectionContentView.layer.shadowColor = HexRGBAlpha(0x000000, 0.3).CGColor;
    self.CollectionContentView.layer.cornerRadius = 5;
}
- (void)setIndex:(NSInteger)index {
    _index = index;
    self.wordCurrentIndexLabel.text = [NSString stringWithFormat:@"%zd ",index +1];
}

+ (instancetype)getWordCardCellWithIndex:(NSInteger)index {
    EHPracticeWordCardScrollViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"EHPracticeWordCardScrollViewCell" owner:self options:nil] firstObject];
    cell.index = index;
    return cell;
}
@end
