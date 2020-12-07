//
//  AFCollectionViewLayoutAttributes.m
//  One Hundred Pixels
//
//  Created by Ash Furrow on 2013-01-30.
//  Copyright (c) 2013 Ash Furrow. All rights reserved.
//

#import "AFCollectionViewLayoutAttributes.h"

@implementation AFCollectionViewLayoutAttributes

-(id)copyWithZone:(NSZone *)zone
{
    AFCollectionViewLayoutAttributes *attributes = [super copyWithZone:zone];
    
    attributes.shadowOpacity = self.shadowOpacity;
    attributes.maskingValue = self.maskingValue;
    
    return attributes;
}

@end
