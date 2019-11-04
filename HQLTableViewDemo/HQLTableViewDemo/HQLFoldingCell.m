//
//  HQLFoldingCell.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/16.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLFoldingCell.h"

@interface RotatedView () <CAAnimationDelegate>

@property (nonatomic, assign) BOOL hiddenAfterAnimation;

@end

@implementation RotatedView

#pragma mark Init

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _hiddenAfterAnimation = NO;
}

#pragma mark - Custom Accessors

- (RotatedView *)blackView {
    if (!_backView) {
        _backView = [[RotatedView alloc] initWithFrame:CGRectZero];
        _backView.layer.anchorPoint = CGPointMake(0.5, 1);
        _backView.layer.transform = [self transform3d];
        _backView.translatesAutoresizingMaskIntoConstraints = FALSE;
    }
    return _backView;
}

#pragma mark Public

- (void)addBackViewHeight:(CGFloat)height color:(UIColor *)color {
    
    // 添加 backView 并设置位置约束
    self.backView.backgroundColor = color;
    [self addSubview:self.backView];

    NSLayoutConstraint *heightConstraint = [NSLayoutConstraint constraintWithItem:self.backView
                                                                        attribute:NSLayoutAttributeHeight
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:nil
                                                                        attribute:NSLayoutAttributeHeight
                                                                       multiplier:1.0
                                                                         constant:height];
    [self.backView addConstraint:heightConstraint];
    
    NSLayoutConstraint *top = [NSLayoutConstraint constraintWithItem:self.backView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1.0
                                                            constant:self.bounds.size.height - height / 2];
    NSLayoutConstraint *leading = [NSLayoutConstraint constraintWithItem:self.backView
                                                               attribute:NSLayoutAttributeLeading
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self
                                                               attribute:NSLayoutAttributeLeading
                                                              multiplier:1.0
                                                                constant:0];
    NSLayoutConstraint *trailing = [NSLayoutConstraint constraintWithItem:self.backView
                                                                attribute:NSLayoutAttributeTrailing
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self
                                                                attribute:NSLayoutAttributeTrailing
                                                               multiplier:1.0
                                                                 constant:0];
    
    [self addConstraints:@[top, leading, trailing]];
}

- (void)foldingAnimation:(NSString *)timing
                    from:(CGFloat)fromPoint
                      to:(CGFloat)toPoint
                   delay:(NSTimeInterval)delay
                duration:(NSTimeInterval)duration
                  hidden:(BOOL)hidden {
    
    CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.x"];
    
    rotateAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    rotateAnimation.fromValue = [NSNumber numberWithFloat:fromPoint];
    rotateAnimation.toValue = [NSNumber numberWithFloat:toPoint];
    rotateAnimation.duration = duration;
    rotateAnimation.delegate = self;
    rotateAnimation.fillMode = kCAFillModeForwards;
    rotateAnimation.removedOnCompletion = NO;
    rotateAnimation.beginTime = CACurrentMediaTime() + delay;
    
    _hiddenAfterAnimation = hidden;
    
    [self.layer addAnimation:rotateAnimation forKey:@"rotation.x"];
}

#pragma mark Private

- (CATransform3D)transform3d
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 2.5 / -2000;
    return transform;
}

#pragma mark - CAAnimationDelegate

// 在动画开始其活动持续时间时调用
- (void)animationDidStart:(CAAnimation *)anim
{
    self.layer.shouldRasterize = YES;
    self.alpha = 1;
}

// 当动画完成其活动持续时间或时，调用从它所附着的物体（即该层）移除。如果动画到达其活动持续时间的末尾，则为 true 没有被删除
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_hiddenAfterAnimation) {
        self.alpha = 0;
    }
    [self.layer removeAllAnimations];
    self.layer.shouldRasterize = NO;
}

@end

#pragma mark -

@interface HQLFoldingCell () {
    NSMutableArray *animationItemViews;
    UIColor *backViewColor;
    foldTapHandler tapHandler;
}

@property (nonatomic) NSLayoutConstraint *containerViewTop;

@end

@implementation HQLFoldingCell

#pragma mark - Init

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.foregroundView.layer.cornerRadius = 10;
    self.foregroundView.layer.masksToBounds = YES;
    
    backViewColor = [UIColor colorWithRed:0.9686 green:0.9333 blue:0.9686 alpha:1.0];
    
    [self configureDefaultState];
    animationItemViews = [self createAnimationItemView];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageViewToFriendDetailView:)];
//    self.coverImageView.userInteractionEnabled = YES;
//    [self.coverImageView addGestureRecognizer:tap];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - IBActions

- (void)tapImageViewToFriendDetailView:(UITapGestureRecognizer *)sender
{
    if (tapHandler) {
        tapHandler();
    }
}

#pragma mark - Pubilc

/**
 Open or close cell
 
 - parameter selected: Specify true if you want to open cell or false if you close cell.
 - parameter animated: Specify true if you want to animate the change in visibility or false if you want immediately.
 - parameter completion: A block object to be executed when the animation sequence ends.
 */
- (void)selectedAnimation:(BOOL)selected animation:(BOOL)animated completion:(animationCompletion)completion
{
    if (selected) {
        // 打开状态
        self.containerView.alpha = 1;
        for (UIView *subView in self.containerView.subviews) {
            subView.alpha = 1;
        }
        
        if (animated) {
            [self openAnimation:completion];
        } else {
            self.foregroundView.alpha = 0;
            for (UIView *subView in self.containerView.subviews) {
                if ([subView isKindOfClass:[RotatedView class]]) {
                    RotatedView *rotateView = (RotatedView *)subView;
                    rotateView.backView.alpha = 0;
                }
            }
        }
    } else {
        //关闭状态
        if (animated) {
            [self closeAnimation:completion];
        } else {
            self.foregroundView.alpha = 1;
            self.containerView.alpha = 0;
        }
    }
}

- (BOOL)isAnimating
{
    for (UIView *item in animationItemViews) {
        if (item.layer.animationKeys.count > 0) return YES;
    }
    return NO;
}

- (CGFloat)returnSumTime
{
    NSMutableArray *tempArray = [self durationSequence];
    CGFloat sumTime = 0.0;
    for (NSNumber *number in tempArray) {
        CGFloat time = [number floatValue];
        sumTime += time;
    }
    return sumTime;
}



- (void)fold_imageTap:(foldTapHandler)handler
{
    tapHandler = handler;
}

#pragma mark - Private

- (void)closeAnimation:(animationCompletion)completion
{
    NSArray *durations = [self durationSequence];
    durations = [[durations reverseObjectEnumerator] allObjects];
    NSTimeInterval delay = 0;
    NSString *timing = kCAMediaTimingFunctionEaseIn;
    CGFloat from = 0.0;
    CGFloat to = M_PI / 2;
    BOOL hidden = YES;
    [self configureAnimationItems:FCAnimationClose];
    for (int index = 0; index < animationItemViews.count; index++) {
        float duration = [durations[index] floatValue];
        NSArray *tempArray = [[animationItemViews reverseObjectEnumerator] allObjects];
        RotatedView *animatedView = tempArray[index];
        [animatedView foldingAnimation:timing from:from to:to delay:delay duration:duration hidden:hidden];
        
        from = from == 0.0 ? -M_PI / 2 : 0.0;
        to = to == 0.0 ? M_PI / 2 : 0.0;
        timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
        hidden = !hidden;
        delay += duration;
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.containerView.alpha = 0;
        if (completion) {
            completion(nil);
        }
    });
    
    RotatedView *firstItemView;
    for (UIView *tempView in self.containerView.subviews) {
        if (tempView.tag == 0) {
            firstItemView = (RotatedView *)tempView;
        }
        
        float value = (delay - [[durations lastObject] floatValue] * 1.5);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(value * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        });
    }
}

- (void)openAnimation:(animationCompletion)completion
{
    NSArray *durtions = [self durationSequence];
    NSTimeInterval delay = 0;
    NSString *timing = kCAMediaTimingFunctionEaseIn;
    CGFloat from = 0.0;
    CGFloat to = -M_PI / 2;
    BOOL hidden = YES;
    [self configureAnimationItems:FCAnimationOpen];
    
    for (int index = 0; index < animationItemViews.count; index++) {
        float duration = [durtions[index] floatValue];
        RotatedView *animatedView = animationItemViews[index];
        [animatedView foldingAnimation:timing from:from to:to delay:delay duration:duration hidden:hidden];
        from = from == 0 ? M_PI / 2 : 0.0;
        to = to == 0.0 ? -M_PI / 2 : 0.0;
        timing = timing == kCAMediaTimingFunctionEaseIn ? kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn;
        hidden = !hidden;
        delay += duration;
    }
    for (UIView *view in self.containerView.subviews) {
        if (view.tag == 0) {
            RotatedView *firstItemView = (RotatedView *)view;
            firstItemView.layer.masksToBounds = YES;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:firstItemView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            firstItemView.layer.mask = maskLayer;
        } else if (view.tag == 3) {
            RotatedView *lastItemView = (RotatedView *)view;
            lastItemView.layer.masksToBounds = YES;
            UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:lastItemView.bounds byRoundingCorners:UIRectCornerBottomRight | UIRectCornerBottomLeft cornerRadii:CGSizeMake(10, 10)];
            CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
            maskLayer.frame = self.bounds;
            maskLayer.path = maskPath.CGPath;
            lastItemView.layer.mask = maskLayer;
        }
    }
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)([durtions[0] floatValue] * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion(nil);
        }
    });
}



- (NSMutableArray *)durationSequence
{
    NSMutableArray *durationArray = [NSMutableArray arrayWithObjects:[NSNumber numberWithFloat:0.35], [NSNumber numberWithFloat:0.23], [NSNumber numberWithFloat:0.23], nil];
    NSMutableArray *durtions = [NSMutableArray array];
    for (int index = 0; index < self.containerView.subviews.count - 1; index++) {
        NSNumber *tempDuration = durationArray[index];
        float temp = [tempDuration floatValue] / 2;
        NSNumber *duration = [NSNumber numberWithFloat:temp];
        
        [durtions addObject:duration];
        [durtions addObject:duration];
    }
    return durtions;
}

- (NSMutableArray *)createAnimationItemView
{
    NSMutableArray *items = [NSMutableArray array];
    NSMutableArray *rotatedViews = [NSMutableArray array];
    
    [items addObject:self.foregroundView];
    
    for (UIView *itemView in self.containerView.subviews) {
        if ([itemView isKindOfClass:[RotatedView class]]) {
            RotatedView *tempView = (RotatedView *)itemView;
            [rotatedViews addObject:tempView];
            if (tempView.backView != nil) [rotatedViews addObject:tempView.backView];
        }
    }
    [items addObjectsFromArray:rotatedViews];
    return items;
}

- (void)configureAnimationItems:(FCAnimationType)animationType
{
    if (animationType == FCAnimationOpen) {
        for (UIView *view in self.containerView.subviews) {
            if ([view isKindOfClass:[RotatedView class]]) {
                view.alpha = 0;
            }
        }
    } else {
        for (UIView *view in self.containerView.subviews) {
            if (![view isKindOfClass:[RotatedView class]]) return;
            RotatedView *tempRotaView = (RotatedView *)view;
            if (animationType == FCAnimationOpen) {
                tempRotaView.alpha = 0;
            } else {
                tempRotaView.alpha = 1;
                tempRotaView.backView.alpha = 0;
            }
        }
    }
}

//设置初始状态
- (void)configureDefaultState
{
    self.containerViewTopConstraint.constant = _foregroundTopConstraint.constant;
    
    self.containerView.alpha = 0;
    
    //将第一个图设置成圆角
    UIView *firstItemView;
    for (UIView *v in self.containerView.subviews) {
        if (v.tag == 0) {
            firstItemView = v;
        }
    }
    
    //设置外层图片属性
    self.foregroundView.layer.anchorPoint = CGPointMake(0.5, 1);
    
    self.foregroundTopConstraint.constant += self.foregroundView.bounds.size.height / 2;
    self.foregroundView.layer.transform = [self transform3d];
    [self.contentView bringSubviewToFront:self.foregroundView];
    
    for (NSLayoutConstraint *constraint in self.containerView.constraints) {
        if ([constraint.identifier isEqualToString:@"yPosition"]) {
            constraint.constant -= [constraint.firstItem layer].bounds.size.height / 2;
            [constraint.firstItem layer].anchorPoint = CGPointMake(0.5, 0);
            [constraint.firstItem layer].transform = [self transform3d];
        }
    }
    
    //添加背景View
    RotatedView *previusView;
    for (UIView *sub in self.containerView.subviews) {
        if (sub.tag > 0 && [sub isKindOfClass:[RotatedView class]]) {
            RotatedView *tempView = (RotatedView *)sub;
            [previusView addBackViewHeight:tempView.bounds.size.height color:backViewColor];
            previusView = tempView;
        }
    }
}

//3d偏移属性设置
- (CATransform3D)transform3d
{
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = 2.5 / -2000;
    return transform;
}


@end
