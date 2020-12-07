//
//  AFCollectionViewFlowLayout.m
//  Circle Layout
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewFlowLayout.h"

@interface AFCollectionViewFlowLayout ()

@property (nonatomic, strong) NSMutableSet *insertedRowSet;
@property (nonatomic, strong) NSMutableSet *deletedRowSet;

@end

@implementation AFCollectionViewFlowLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(200, 200);
    self.sectionInset = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    self.minimumInteritemSpacing = 13.0f;
    self.minimumLineSpacing = 13.0f;
    
    // Must instantiate these in init or else they'll always be empty
    self.insertedRowSet = [NSMutableSet set];
    self.deletedRowSet = [NSMutableSet set];
    
    return self;
}

#pragma mark - Overridden Methods

-(void)prepareForCollectionViewUpdates:(NSArray *)updateItems
{
    [super prepareForCollectionViewUpdates:updateItems];
    
    [updateItems enumerateObjectsUsingBlock:^(UICollectionViewUpdateItem *updateItem, NSUInteger idx, BOOL *stop) {
        if (updateItem.updateAction == UICollectionUpdateActionInsert)
        {
            [self.insertedRowSet addObject:@(updateItem.indexPathAfterUpdate.item)];
        }
        else if (updateItem.updateAction == UICollectionUpdateActionDelete)
        {
            [self.deletedRowSet addObject:@(updateItem.indexPathBeforeUpdate.item)];
        }
    }];
}

-(void)finalizeCollectionViewUpdates
{
    [super finalizeCollectionViewUpdates];
    
    [self.insertedRowSet removeAllObjects];
    [self.deletedRowSet removeAllObjects];
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingItemAtIndexPath:itemIndexPath];
    
    if ([self.insertedRowSet containsObject:@(itemIndexPath.item)])
    {
        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attributes.alpha = 0.0;
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
        attributes.transform3D = CATransform3DRotate(attributes.transform3D, -M_PI_4, 0, 0, 1);
        return attributes;
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingItemAtIndexPath:(NSIndexPath *)itemIndexPath
{
    // The documentation says that this returns nil. It is lying.
    UICollectionViewLayoutAttributes *attributes = [super finalLayoutAttributesForDisappearingItemAtIndexPath:itemIndexPath];
    
    if ([self.deletedRowSet containsObject:@(itemIndexPath.item)])
    {
        attributes = [self layoutAttributesForItemAtIndexPath:itemIndexPath];
        attributes.alpha = 0.0;
        attributes.transform3D = CATransform3DMakeScale(0.1, 0.1, 1.0);
        attributes.transform3D = CATransform3DRotate(attributes.transform3D, M_PI_4, 0, 0, 1);
        
        return attributes;
    }
    
    return attributes;
}

@end
