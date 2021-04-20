//
//  HQLTabBarItem.m
//  HQLTabBarController
//
//  Created by Qilin Hu on 2021/3/19.
//

#import "HQLTabBarItem.h"

@implementation HQLTabBarItem

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) { return nil; }
    [self commonInitialization];
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (!self) { return nil; }
    [self commonInitialization];
    return self;
}

- (instancetype)init {
    return [self initWithFrame:CGRectZero];
}

- (void)commonInitialization {
    self.backgroundColor = [UIColor clearColor];
    
    self.title = @"";
    self.titlePositionAdjustment = UIOffsetZero;
    self.unselectedTitleAttributes = @{
        NSFontAttributeName: [UIFont systemFontOfSize:12.0f],
        NSForegroundColorAttributeName: [UIColor blackColor]
    };
    self.selectedTitleAttributes = [self.unselectedTitleAttributes copy];
    
    self.badgeTextColor = [UIColor whiteColor];
    self.badgeTextFont = [UIFont systemFontOfSize:12.0f];
    self.badgeBackgroundColor = [UIColor redColor];
    self.badgePositionAdjustment = UIOffsetZero;
}

- (void)drawRect:(CGRect)rect {
    CGSize frameSize = self.frame.size;
    CGSize imageSize = CGSizeZero;
    CGSize titleSize = CGSizeZero;
    NSDictionary *titleAttributes = nil;
    UIImage *backgroundImage = nil;
    UIImage *image = nil;
    CGFloat imageStartingY = 0.0f;
    
    if (self.isSelected) {
        image = self.selectedImage;
        backgroundImage = self.backgroundSelectedImage;
        titleAttributes = self.selectedTitleAttributes;
        if (!titleAttributes) {
            titleAttributes = self.unselectedTitleAttributes;
        }
    } else {
        image = self.unselectedImage;
        backgroundImage = self.backgroundUnselectedImage;
        titleAttributes = self.unselectedTitleAttributes;
    }
    
    imageSize = image.size;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    
    if (backgroundImage) {
        [backgroundImage drawInRect:self.bounds];
    }
    
    // Draw image and title
    if (self.title.length == 0) {
        [image drawInRect:CGRectMake(roundf((frameSize.width - imageSize.width) / 2) + self.imagePositionAdjustment.horizontal,
                                     roundf((frameSize.height - imageSize.height) / 2) + self.imagePositionAdjustment.vertical,
                                     imageSize.width, imageSize.height)];
    } else {
        titleSize = [self.title boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                             options:NSStringDrawingUsesLineFragmentOrigin
                                          attributes:titleAttributes
                                             context:nil].size;
        imageStartingY = roundf((frameSize.height - imageSize.height - titleSize.height) / 2);
        
        [image drawInRect:CGRectMake(roundf((frameSize.width - imageSize.width) / 2) + self.imagePositionAdjustment.horizontal,
                                     imageStartingY + self.imagePositionAdjustment.vertical,
                                     imageSize.width, imageSize.height)];
        
        // Title
        CGContextSetFillColorWithColor(context, [titleAttributes[NSForegroundColorAttributeName] CGColor]);
        [self.title drawInRect:CGRectMake(roundf((frameSize.width - titleSize.width) / 2) + self.titlePositionAdjustment.horizontal,
                                          imageStartingY + imageSize.height + self.titlePositionAdjustment.vertical,
                                          titleSize.width, titleSize.height) withAttributes:titleAttributes];
    }
    
    // Draw badges
    if (self.badgeValue.integerValue != 0) {
        CGSize badgeSize = [self.badgeValue boundingRectWithSize:CGSizeMake(frameSize.width, 20)
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:@{NSFontAttributeName: self.badgeTextFont}
                                                         context:nil].size;
        
        CGFloat textOffset = 2.0f;
        
        if (badgeSize.width < badgeSize.height) {
            badgeSize = CGSizeMake(badgeSize.height, badgeSize.height);
        }
        
        CGRect badgeBackgroundFrame = CGRectMake(roundf((frameSize.width + imageSize.width) / 2 * 0.9) + self.badgePositionAdjustment.horizontal,
                                                 textOffset + self.badgePositionAdjustment.vertical,
                                                 badgeSize.width + textOffset * 2,
                                                 badgeSize.height + textOffset * 2);
        
        if (self.badgeBackgroundColor) {
            CGContextSetFillColorWithColor(context, self.badgeBackgroundColor.CGColor);
            CGContextFillEllipseInRect(context, badgeBackgroundFrame);
        } else if (self.badgeBackgroundImage) {
            [self.badgeBackgroundImage drawInRect:badgeBackgroundFrame];
        }
        
        // Text
        CGContextSetFillColorWithColor(context, self.badgeTextColor.CGColor);
        NSMutableParagraphStyle *badgeTextStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        [badgeTextStyle setLineBreakMode:NSLineBreakByWordWrapping];
        [badgeTextStyle setAlignment:NSTextAlignmentCenter];
        
        NSDictionary *badgeTextAttributes = @{
            NSFontAttributeName: self.badgeTextFont,
            NSForegroundColorAttributeName: self.badgeTextColor,
            NSParagraphStyleAttributeName: badgeTextStyle
        };
        [self.badgeValue drawInRect:CGRectMake(CGRectGetMinX(badgeBackgroundFrame) + textOffset,
                                               CGRectGetMinY(badgeBackgroundFrame) + textOffset,
                                               badgeSize.width, badgeSize.height)
                     withAttributes:badgeTextAttributes];
    }
    CGContextRestoreGState(context);
}

#pragma mark - Image configuration

- (void)setSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && selectedImage != self.selectedImage) {
        self.selectedImage = selectedImage;
    }
    
    if (unselectedImage && unselectedImage != self.unselectedImage) {
        self.unselectedImage = unselectedImage;
    }
}

#pragma mark - Background configuration

- (void)setBackgroundSelectedImage:(UIImage *)selectedImage withUnselectedImage:(UIImage *)unselectedImage {
    if (selectedImage && selectedImage != self.backgroundSelectedImage) {
        self.backgroundSelectedImage = selectedImage;
    }
    
    if (unselectedImage && unselectedImage != self.backgroundUnselectedImage) {
        self.backgroundUnselectedImage = unselectedImage;
    }
}

#pragma mark - Badge configuration

- (void)setBadgeValue:(NSString *)badgeValue {
    _badgeValue = badgeValue;
    
    [self setNeedsDisplay];
}

#pragma mark - Accessibility

- (NSString *)accessibilityLabel {
    return @"tabbarItem";
}

- (BOOL)isAccessibilityElement {
    return YES;
}

@end
