//
//  AFCollectionViewFlowLayout.m
//  Dimensions
//
//  Created by Ash Furrow on 2013-01-13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewFlowLayout.h"

@implementation AFCollectionViewFlowLayout

-(instancetype)init {
    if (!(self = [super init])) return nil;
    
    // Some basic setup. 140x140 + 3*13 ~= 320, so we can get a two-column grid in portrait orientation.
    CGFloat itemWidth = ([UIScreen mainScreen].bounds.size.width - 40) / 2;
    self.itemSize = CGSizeMake(itemWidth, itemWidth);
    self.sectionInset = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    self.minimumInteritemSpacing = 13.0f;
    self.minimumLineSpacing = 13.0f;
    self.layoutMode = AFCollectionViewFlowLayoutModeAspectFit;
    
    return self;
}

// !!!: 返回自定义布局属性对象类
+(Class)layoutAttributesClass {
    // 默认情况下，返回 UICollectionViewLayoutAttributes
    // 重要的是让 UICollectionView 知道要使用什么样的属性。
    return [AFCollectionViewLayoutAttributes class];
}

#pragma mark - Private Helper Methods

-(void)applyLayoutAttributes:(AFCollectionViewLayoutAttributes *)attributes {
    // Check for representedElementKind being nil, indicating this is a cell and not a header or decoration view
    if (!attributes.representedElementKind) {
        // Pass our layout mode onto the layout attributes
        attributes.layoutMode = self.layoutMode;
        
        if ([self.collectionView.delegate respondsToSelector:@selector(collectionView:layout:layoutModeForItemAtIndexPath:)])
        {
            attributes.layoutMode = [(id<AFCollectionViewDelegateFlowLayout>)self.collectionView.delegate collectionView:self.collectionView layout:self layoutModeForItemAtIndexPath:attributes.indexPath];
        }
    }
}

#pragma mark - Overridden Methods

#pragma mark Cell Layout

-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    for (AFCollectionViewLayoutAttributes *attributes in attributesArray) {
        [self applyLayoutAttributes:attributes];
    }

    return attributesArray;
}

-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    AFCollectionViewLayoutAttributes *attributes = (AFCollectionViewLayoutAttributes *)[super layoutAttributesForItemAtIndexPath:indexPath];
    [self applyLayoutAttributes:attributes];
    
    return attributes;
}

#pragma mark - Overridden Properties

-(void)setLayoutMode:(AFCollectionViewFlowLayoutMode)layoutMode {
    _layoutMode = layoutMode;
    
    // !!!: 使得先前的布局无效，强制系统重新布局
    [self invalidateLayout];
}

@end
