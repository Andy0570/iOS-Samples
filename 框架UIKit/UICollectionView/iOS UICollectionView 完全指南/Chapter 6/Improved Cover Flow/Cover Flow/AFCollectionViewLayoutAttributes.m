//
//  AFCollectionViewLayoutAttributes.m
//  Cover Flow
//
//  Created by Ash Furrow on 2013-01-17.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewLayoutAttributes.h"

@implementation AFCollectionViewLayoutAttributes

-(id)copyWithZone:(NSZone *)zone
{
    AFCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    
    attributes.shouldRasterize = self.shouldRasterize;
    attributes.maskingValue = self.maskingValue;
    
    return attributes;
}

@end
