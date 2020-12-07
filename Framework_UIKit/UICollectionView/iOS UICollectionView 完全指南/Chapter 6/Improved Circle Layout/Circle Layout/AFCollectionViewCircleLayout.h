//
//  AFCollectionViewCircleLayout.h
//  Circle Layout
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFCollectionViewCircleLayout;

@protocol AFCollectionViewDelegateCircleLayout <NSObject>

-(CGFloat)rotationAngleForSupplmentaryViewInCircleLayout:(AFCollectionViewCircleLayout *)circleLayout;

@end

@interface AFCollectionViewCircleLayout : UICollectionViewLayout

@property (nonatomic, assign) CGPoint center;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) NSInteger cellCount;

@end
