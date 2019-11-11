//
//  FourthCollectionViewController.h
//  CollectionViewDemo
//
//  Created by Qilin Hu on 2018/1/29.
//  Copyright © 2018年 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 使用代理方式设置布局参数，UICollectionViewDelegateFlowLayout
 
 这种方式可以动态地设置集合元素的布局参数、但是显示的集合元素是呈网格状分布的，和瀑布流还是有区别的。
 */
@interface FourthCollectionViewController : UICollectionViewController

@end

/**
 
 @protocol UICollectionViewDelegateFlowLayout <UICollectionViewDelegate>
 @optional
 
 // 集合元素大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath;
 
 // 边缘插入量
 - (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section;
 
 // 最小行距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section;
 
 // 最小列距
 - (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section;
 
 // 表头视图大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section;
 
 // 表尾视图大小
 - (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section;
 
 @end
 
 **/
