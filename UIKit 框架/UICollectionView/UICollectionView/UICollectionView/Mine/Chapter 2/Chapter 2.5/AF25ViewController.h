//
//  AF25ViewController.h
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 关注 UICollectionViewCell 的视图层级：
 - UICollectionViewCell
     - backgroundView
         - selectedBackgroundView
             - contentView
 */
@interface AF25ViewController : UICollectionViewController

@end

NS_ASSUME_NONNULL_END
