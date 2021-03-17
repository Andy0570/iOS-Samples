//
//  TangramSingleImageElement.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "TangramSingleImageElement.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <Tangram/TangramEvent.h>
#import <Tangram/UIView+Tangram.h>

@interface TangramSingleImageElement ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation TangramSingleImageElement

#pragma mark - Initialize

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    self.clipsToBounds = YES;
    self.backgroundColor = [UIColor grayColor];
    
    [self addSubview:self.imageView];
    [self addSubview:self.titleLabel];
    
    [self addTarget:self action:@selector(clickedOnElement) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

#pragma mark - Custom Accessors

- (UIImageView *)imageView {
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
        _imageView.userInteractionEnabled = NO;
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textColor = [UIColor redColor];
    }
    return _titleLabel;
}

- (void)setImgUrl:(NSString *)imgUrl {
    if (imgUrl.length > 0) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
    }
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    if (frame.size.width > 0 && frame.size.height > 0) {
        [self mui_afterGetView];
    }
}

#pragma mark - Actions

// 发送点击事件
- (void)clickedOnElement {
    TangramEvent *event = [[TangramEvent alloc] initWithTopic:@"jumpAction" withTangramView:self.inTangramView posterIdentifier:@"singleImage" andPoster:self];
    [event setParam:self.action forKey:@"action"];
    [self.tangramBus postEvent:event];
}

#pragma mark - TMLazyItemViewProtocol

- (void)mui_afterGetView {
    self.imageView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.titleLabel.text = [NSString stringWithFormat:@"%ld",[self.number longValue]];
    [self.titleLabel sizeToFit];
}

#pragma mark - TangramElementHeightProtocol

+ (CGFloat)heightByModel:(TangramDefaultItemModel *)itemModel {
    return 100.f;
}

@end
