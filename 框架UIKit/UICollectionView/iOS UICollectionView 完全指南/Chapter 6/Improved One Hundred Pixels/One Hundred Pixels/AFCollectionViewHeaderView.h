//
//  AFCollectionViewHeaderView.h
//  One Hundred Pixels
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AFCollectionViewHeaderView : UICollectionReusableView

+(NSString *)kind;

-(void)setText:(NSString *)text;

@end
