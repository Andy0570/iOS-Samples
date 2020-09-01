//
//  CHTCollectionViewController.h
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/20.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 使用开源框架实现瀑布流布局
 
 GitHub: <https://github.com/chiahsien/CHTCollectionViewWaterfallLayout>
 */
@interface CHTCollectionViewController : UIViewController

@end

NS_ASSUME_NONNULL_END


/**
 遇到的问题
 
 *** Assertion failure in -[UICollectionView _createPreparedSupplementaryViewForElementOfKind:atIndexPath:withLayoutAttributes:applyAttributes:], /Library/Caches/com.apple.xbs/Sources/UIKitCore/UIKit-3920.31.102/UICollectionView.m:2421
 the view returned from -collectionView:viewForSupplementaryElementOfKind:atIndexPath (CHTCollectionElementKindSectionHeader,<NSIndexPath: 0x9de43ee5ba418cd9> {length = 2, path = 0 - 0}) was not retrieved by calling -dequeueReusableSupplementaryViewOfKind:withReuseIdentifier:forIndexPath: or is nil ((null))
 
 默认情况下，注册重用 header view 和 footer view：
 
 [self.collectionView registerClass:[CollectionReusableView class]
         forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                withReuseIdentifier:headerReuseIdentifier];
 [self.collectionView registerClass:[CollectionReusableView class]
         forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
                withReuseIdentifier:footerReuseIdentifier];
 
 表头和表尾的元素类型分别是 UICollectionElementKindSectionHeader 和 UICollectionElementKindSectionFooter
 
 但是，当你使用了 CHTCollectionViewWaterfallLayout 框架之后，元素类型要修改为：
 CHTCollectionElementKindSectionHeader 和 CHTCollectionElementKindSectionFooter
 
 即：
 [self.collectionView registerClass:[CollectionReusableView class]
         forSupplementaryViewOfKind:CHTCollectionElementKindSectionHeader
                withReuseIdentifier:headerReuseIdentifier];
 [self.collectionView registerClass:[CollectionReusableView class]
         forSupplementaryViewOfKind:CHTCollectionElementKindSectionFooter
                withReuseIdentifier:footerReuseIdentifier];
 */
