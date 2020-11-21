//
//  UIView+Snap.m
//  PETransition
//
//  Created by Petry on 16/10/31.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "UIView+Snap.h"

@implementation UIView (Snap)

- (UIImage *)imageFromView
{
    UIView *snapView = self;
    UIGraphicsBeginImageContext(snapView.frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [snapView.layer renderInContext:context];
    UIImage *targetImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return targetImage;
}

@end
