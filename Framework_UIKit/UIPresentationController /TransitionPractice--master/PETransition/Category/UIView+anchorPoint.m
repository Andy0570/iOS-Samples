//
//  UIView+anchorPoint.m
//  PETransition
//
//  Created by Petry on 16/9/11.
//  Copyright © 2016年 iStorm. All rights reserved.
//

#import "UIView+anchorPoint.h"

@implementation UIView (anchorPoint)
- (void)setAnchorPoint:(CGPoint)point
{
    self.frame = CGRectOffset(self.frame, (point.x - self.layer.anchorPoint.x)*self.frame.size.width, (point.y - self.layer.anchorPoint.y)*self.frame.size.height);
    self.layer.anchorPoint = point;
}
@end
