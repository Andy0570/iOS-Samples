//
//  UIImage+LYColor.m
//  LYTravellerPro
//
//  Created by LianLeven on 15/10/19.
//  Copyright © 2015年 lichangwen. All rights reserved.
//

#import "UIImage+LYColor.h"

@implementation UIImage (LYColor)

+ (UIImage *)imageWithLYColor:(UIColor *)color
{
    NSParameterAssert(color != nil);
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);   // Fill it with your color
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
@end
