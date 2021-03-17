//
//  DemoFixModel.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "DemoFixModel.h"

@implementation DemoFixModel

- (void)setItemFrame:(CGRect)itemFrame
{
    _itemModelFrame = itemFrame;
}

- (CGRect)itemFrame
{
    return CGRectMake(0,0, 100, 30);
}

- (CGFloat)marginTop
{
    return 0.f;
}

- (CGFloat)marginLeft
{
    return 0.f;
}

- (CGFloat)marginRight
{
    return 0.f;
}

- (CGFloat)marginBottom
{
    return 0.f;
}

- (NSString *)display
{
    return @"inline";
}

- (TangramItemType *)itemType
{
    return @"demo";
}

- (NSString *)reuseIdentifier
{
    return @"";
}

@end
