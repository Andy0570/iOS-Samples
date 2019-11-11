//
//  HPMailCompositeCell.h
//  HighPerformanceUI
//
//  Created by Qilin Hu on 2017/12/5.
//  Copyright © 2017年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 复合视图,nib 方式创建
 */
@interface HPMailCompositeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *emailLabel;
@property (weak, nonatomic) IBOutlet UILabel *subjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *snippetLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *sectionButton;

@end
