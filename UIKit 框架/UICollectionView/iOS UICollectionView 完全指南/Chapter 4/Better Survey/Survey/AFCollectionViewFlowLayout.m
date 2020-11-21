//
//  AFCollectionViewFlowLayout.m
//  Survey
//
//  Created by Ash Furrow on 2013-01-12.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewFlowLayout.h"
#import "AFDecorationView.h"

NSString * const AFCollectionViewFlowLayoutBackgroundDecoration = @"DecorationIdentifier";

@implementation AFCollectionViewFlowLayout
{
    NSMutableSet *insertedSectionSet;
}

-(instancetype)init {
    if (!(self = [super init])) return nil;
    
    // 在初始化方法中设置默认布局参数
    self.sectionInset = UIEdgeInsetsMake(15.0f, 5.0f, 15.0f, 5.0f);
    self.minimumInteritemSpacing = 5.0f;
    self.minimumLineSpacing = 5.0f;
    self.itemSize = kMaxItemSize;
    self.headerReferenceSize = CGSizeMake(60, 70);
    
    // !!!: 注册装饰视图
    [self registerClass:[AFDecorationView class] forDecorationViewOfKind:AFCollectionViewFlowLayoutBackgroundDecoration];
    
    /**
     当我们插入一个新的 section 时，其他 section 也会被重新加载。这会导致不仅仅是出现的 secion 有动画。
     我们还需要限制哪些 section 会执行动画。
     
     因此，该实例变量用来记录正在插入的 section
     */
    insertedSectionSet = [NSMutableSet set];
    
    return self;
}

#pragma mark - Private

// 修改并更新每一个 item 的位置
-(void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes {
    
    // 对于一个普通的 UICollectionViewCell 来说，它的 representedElementKind 值为 nil
    // 检查 representedElementKind 是否为 nil，表明这是一个单元格，而不是一个 header view 或装饰视图。
    if (!attributes.representedElementKind) {
        CGFloat width = [self collectionViewContentSize].width;
        CGFloat leftMargin = [self sectionInset].left;
        CGFloat rightMargin = [self sectionInset].right;
        
        NSUInteger itemsInSection = [[self collectionView] numberOfItemsInSection:attributes.indexPath.section];
        // xPosition 指单元格的 centerX
        CGFloat firstXPosition = (width - (leftMargin + rightMargin)) / (2 * itemsInSection);
        CGFloat xPosition = firstXPosition + (2*firstXPosition*attributes.indexPath.item);
        
        attributes.center = CGPointMake(leftMargin + xPosition, attributes.center.y);
        attributes.frame = CGRectIntegral(attributes.frame);
    }
}

#pragma mark - Override

#pragma mark Cell 布局

/**
 该方法返回一个包含所有布局信息 UICollectionViewLayoutAttributes 的数组。

 我们通过父类方法 [super layoutAttributesForElementsInRect:rect] 先创建了一个正常情况下的所有属性的数组。
 这个父类方法默认情况下，只会创建在 rect 范围内的视图的布局属性。
 所以，如果你想把原来不会被显示的视图也显示出来的话，你就不得不自己把所有布局属性都创建出来，放入数组中。
*/
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect {
    
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
    
    // 该数组中存放我们在每个 section 中新增的「装饰视图」布局参数
    NSMutableArray *newAttributesArray = [NSMutableArray array];
    for (UICollectionViewLayoutAttributes *attributes in attributesArray) {
        // 更新布局，修改并更新每一个 item 的位置
        [self applyLayoutAttributes:attributes];
        
        // 默认情况下，「装饰视图」不会被显示，所以需要创建并添加「装饰视图」的布局属性
        // MARK: 添加自定义的装饰视图
        if (attributes.representedElementCategory == UICollectionElementCategorySupplementaryView) {
            UICollectionViewLayoutAttributes *newAttributes = [self layoutAttributesForDecorationViewOfKind:AFCollectionViewFlowLayoutBackgroundDecoration atIndexPath:attributes.indexPath];
            [newAttributesArray addObject:newAttributes];
        }
    }
    
    attributesArray = [attributesArray arrayByAddingObjectsFromArray:newAttributesArray];
    
    return attributesArray;
}

// 布局 item
-(UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForItemAtIndexPath:indexPath];
    // 更新布局，修改并更新每一个 item 的位置
    [self applyLayoutAttributes:attributes];
    return attributes;
}

#pragma mark 装饰视图布局

-(UICollectionViewLayoutAttributes *)layoutAttributesForDecorationViewOfKind:(NSString *)decorationViewKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *layoutAttributes = [UICollectionViewLayoutAttributes layoutAttributesForDecorationViewOfKind:decorationViewKind withIndexPath:indexPath];
    
    if ([decorationViewKind isEqualToString:AFCollectionViewFlowLayoutBackgroundDecoration]) {
        
        // 最高 item 的垂直中心
        UICollectionViewLayoutAttributes *tallestCellAttributes;
        NSInteger numberOfCellsInSection = [self.collectionView numberOfItemsInSection:indexPath.section];
        
        for (NSInteger i = 0; i < numberOfCellsInSection; i++) {
            
            NSIndexPath *cellIndexPath = [NSIndexPath indexPathForItem:i inSection:indexPath.section];
            
            UICollectionViewLayoutAttributes *cellAttribtes = [self layoutAttributesForItemAtIndexPath:cellIndexPath];
            
            if (CGRectGetHeight(cellAttribtes.frame) > CGRectGetHeight(tallestCellAttributes.frame)) {
                tallestCellAttributes = cellAttribtes;
            }
        }
        
        CGFloat decorationViewHeight = CGRectGetHeight(tallestCellAttributes.frame) + self.headerReferenceSize.height;
        
        layoutAttributes.size = CGSizeMake([self collectionViewContentSize].width, decorationViewHeight);
        layoutAttributes.center = CGPointMake([self collectionViewContentSize].width / 2.0f, tallestCellAttributes.center.y);
        layoutAttributes.frame = CGRectIntegral(layoutAttributes.frame);
        
        /**
         默认情况下，单元格的 zIndex 值为 0，
         将装饰视图的 zIndex 值设置为 -1，可以将「装饰视图」显示在单元格的视图层次后面。
         */
        layoutAttributes.zIndex = -1;
    }
    
    return layoutAttributes;
}

#pragma mark 自定义动画支持

-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems {
    [super prepareForCollectionViewUpdates:updateItems];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        // 如果当前的 item 动作为 Insert，则记录到 NSMutableSet 集合中
        if (updateItem.updateAction == UICollectionUpdateActionInsert) {
            [insertedSectionSet addObject:@(updateItem.indexPathAfterUpdate.section)];
        }
    }];
}

-(void)finalizeCollectionViewUpdates {
    [super finalizeCollectionViewUpdates];
    
    // 当更新完成后，从可变集中删除所有项目，将其重置为空状态，以便进行下一批更新。
    [insertedSectionSet removeAllObjects];
}

// 自定义「装饰视图」添加动画
-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingDecorationElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)decorationIndexPath {
    // 返回 nil 则执行默认的 crossfade 动画
    
    UICollectionViewLayoutAttributes *layoutAttributes;
    if ([elementKind isEqualToString:AFCollectionViewFlowLayoutBackgroundDecoration]) {
        if ([insertedSectionSet containsObject:@(decorationIndexPath.section)]) {
            layoutAttributes = [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:decorationIndexPath];
            layoutAttributes.alpha = 0.0f;
            // 装饰视图向左移动
            layoutAttributes.transform3D = CATransform3DMakeTranslation(-CGRectGetWidth(layoutAttributes.frame), 0, 0);
        }
    }
    
    return layoutAttributes;
}

// 自定义 item 添加动画，设置初始布局属性
// 当一个新的 item 被添加或更新到集合视图中时，此方法就会被调用
-(UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath {
    // 返回 nil 则执行默认的 crossfade 动画
    
    UICollectionViewLayoutAttributes *layoutAttributes;
    if ([insertedSectionSet containsObject:@(itemIndexPath.section)]) {
        layoutAttributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        // 单元格向右移动
        layoutAttributes.transform3D = CATransform3DMakeTranslation([self collectionViewContentSize].width, 0, 0);
    }
    
    return layoutAttributes;
}

@end
