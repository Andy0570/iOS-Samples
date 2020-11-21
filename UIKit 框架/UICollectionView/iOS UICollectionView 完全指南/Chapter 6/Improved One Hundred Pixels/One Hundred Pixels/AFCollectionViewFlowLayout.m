//
//  AFCollectionViewFlowLayout.m
//  One Hundred Pixels
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewFlowLayout.h"

@implementation AFCollectionViewFlowLayout

-(id)init
{
    if (!(self = [super init])) return nil;
    
    self.itemSize = CGSizeMake(200, 200);
    self.sectionInset = UIEdgeInsetsMake(13.0f, 13.0f, 13.0f, 13.0f);
    self.minimumInteritemSpacing = 13.0f;
    self.minimumLineSpacing = 13.0f;
    
    return self;
}

@end
