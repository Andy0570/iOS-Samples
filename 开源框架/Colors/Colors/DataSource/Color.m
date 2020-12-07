//
//  Color.m
//  Colors
//
//  Created by Qilin Hu on 2020/7/8.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "Color.h"
#import "UIColor+Hex.h"

@implementation Color

#pragma mark - Initialize

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    if (!dict) {
        return nil;
    }
    
    self = [super init];
    if (self) {
        self.hex = dict[@"hex"];
        self.name = dict[@"name"];
        self.rgb = dict[@"rgb"];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UIColor *)color {
    return [UIColor colorFromHex:self.hex];
}

#pragma mark - Public

+ (UIImage *)roundThumbWithColor:(UIColor *)color {
    return [self roundImageForSize:CGSizeMake(32.0, 32.0) withColor:color];
}

+ (UIImage *)roundImageForSize:(CGSize)size withColor:(UIColor *)color {
    if (!color) {
        return nil;
    }
    
    // Constants
    CGRect bounds = CGRectMake(0, 0, size.width, size.height);
    
    // Create the image context
    UIGraphicsBeginImageContextWithOptions(bounds.size, NO, 0);
    
    // Oval Drawing
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithOvalInRect:bounds];
    [color setFill];
    [ovalPath fill];
    
    // Create the image using the current context.
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
