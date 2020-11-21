//
//  AFCollectionViewLayoutAttributes.h
//  Cover Flow
//
//  Created by Ash Furrow on 2013-01-17.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCollectionViewLayoutAttributes : UICollectionViewLayoutAttributes

@property (nonatomic, assign) BOOL shouldRasterize;
@property (nonatomic, assign) CGFloat maskingValue;

@end
