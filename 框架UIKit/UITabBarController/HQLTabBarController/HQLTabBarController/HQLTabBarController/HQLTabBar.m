//
//  HQLTabBar.m
//  HQLTabBarController
//
//  Created by Qilin Hu on 2021/3/19.
//

#import "HQLTabBar.h"
#import "HQLTabBarItem.h"

@interface HQLTabBar ()

@property (nonatomic, assign) CGFloat itemWidth;
@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation HQLTabBar

#pragma mark - Initialize

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
    self.backgroundView = [[UIView alloc] init];
    [self addSubview:self.backgroundView];
    
    self.translucent = NO;
}

- (void)layoutSubviews {
    CGSize frameSize = self.frame.size;
    CGFloat minimumContentHeight = [self minimumContentHeight];
    
    self.backgroundView.frame = CGRectMake(0, frameSize.height - minimumContentHeight, frameSize.width, frameSize.height);
    
    self.itemWidth = roundf((frameSize.width - self.contentEdgeInsets.left - self.contentEdgeInsets.right) / self.items.count);
    NSInteger index = 0;
    
    // Layout items
    for (HQLTabBarItem *item in self.items) {
        CGFloat itemHeight = item.itemHeight;
        
        if (!itemHeight) {
            itemHeight = frameSize.height;
        }
        
        item.frame = CGRectMake(self.contentEdgeInsets.left + (index * self.itemWidth), roundf(frameSize.height - itemHeight) - self.contentEdgeInsets.top, self.itemWidth, itemHeight - self.contentEdgeInsets.bottom);
        [item setNeedsDisplay];
        
        index ++;
    }
}

#pragma mark - Configuration

- (void)setItems:(NSArray *)items {
    for (HQLTabBarItem *item in _items) {
        [item removeFromSuperview];
    }
    
    _items = [items copy];
    for (HQLTabBarItem *item in _items) {
        [item addTarget:self action:@selector(tabBarItemWasSelected:) forControlEvents:UIControlEventTouchDown];
        [self addSubview:item];
    }
}

- (void)setItemWidth:(CGFloat)itemWidth {
    if (itemWidth > 0) {
        _itemWidth = itemWidth;
    }
}

- (void)setHeight:(CGFloat)height {
    self.frame = CGRectMake(CGRectGetMinX(self.frame), CGRectGetMinY(self.frame), CGRectGetWidth(self.frame), height);
}

/// 返回 tabBar items 中的最小高度
- (CGFloat)minimumContentHeight {
    CGFloat minimumTabBarContentHeight = CGRectGetHeight(self.frame);
    
    for (HQLTabBarItem *item in self.items) {
        CGFloat itemHeight = item.itemHeight;
        if (itemHeight && itemHeight < minimumTabBarContentHeight) {
            minimumTabBarContentHeight = itemHeight;
        }
    }
    
    return minimumTabBarContentHeight;
}

#pragma mark - Item selection

- (void)tabBarItemWasSelected:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:shouldSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        if (![self.delegate tabBar:self shouldSelectItemAtIndex:index]) {
            return;
        }
    }
    
    self.selectedItem = sender;
    if (self.delegate && [self.delegate respondsToSelector:@selector(tabBar:didSelectItemAtIndex:)]) {
        NSInteger index = [self.items indexOfObject:sender];
        [self.delegate tabBar:self didSelectItemAtIndex:index];
    }
}

- (void)setSelectedItem:(HQLTabBarItem *)selectedItem {
    if (selectedItem == _selectedItem) {
        return;
    }
    _selectedItem.selected = NO;
    _selectedItem = selectedItem;
    _selectedItem.selected = YES;
}

#pragma mark - Translucency

- (void)setTranslucent:(BOOL)translucent {
    _translucent = translucent;
    
    CGFloat alpha = (translucent ? 0.9 : 1.0);
    self.backgroundView.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:alpha];
}

#pragma mark - Accessibility

- (BOOL)isAccessibilityElement{
    return NO;
}

- (NSInteger)accessibilityElementCount {
    return self.items.count;
}

- (id)accessibilityElementAtIndex:(NSInteger)index {
    return self.items[index];
}

- (NSInteger)indexOfAccessibilityElement:(id)element {
    return [self.items indexOfObject:element];
}

@end
