//
//  StacksLayout.h
//  IntroducingCollectionViews
//
//  Created by Mark Pospesel on 10/12/12.
//  Modified by Ash Furrow on 01/30/2013.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCollectionViewStackedLayout : UICollectionViewLayout

@property (nonatomic, assign) NSInteger pinchedStackIndex;
@property (nonatomic, assign) CGFloat pinchedStackScale;
@property (nonatomic, assign) CGPoint pinchedStackCenter;
@property (nonatomic, assign, getter = isCollapsing) BOOL collapsing;

@end
