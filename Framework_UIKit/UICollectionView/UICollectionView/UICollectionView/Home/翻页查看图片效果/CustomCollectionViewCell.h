//
//  CustomCollectionViewCell.h
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/25.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

/// 自定义集合元素，是 UICollectionViewCell 的子类
@interface CustomCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end
