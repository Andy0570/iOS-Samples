//
//  AFCollectionViewLayoutAttributes.m
//  Dimensions
//
//  Created by Ash Furrow on 2013-01-13.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewLayoutAttributes.h"

@implementation AFCollectionViewLayoutAttributes

-(id)copyWithZone:(NSZone *)zone {
    AFCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    attributes.layoutMode = self.layoutMode;
    return attributes;
}

@end
