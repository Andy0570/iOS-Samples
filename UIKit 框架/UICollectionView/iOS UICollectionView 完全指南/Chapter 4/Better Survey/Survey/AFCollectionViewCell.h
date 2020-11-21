//
//  AFCollectionViewCell.h
//  Survey
//
//  Created by Ash Furrow on 2013-01-05.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImage *image;

-(void)setDisabled:(BOOL)disabled;

@end
