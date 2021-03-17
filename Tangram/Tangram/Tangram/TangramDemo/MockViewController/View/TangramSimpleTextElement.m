//
//  TangramSimpleTextElement.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "TangramSimpleTextElement.h"

@interface TangramSimpleTextElement ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation TangramSimpleTextElement

- (instancetype)init {
    self = [super init];
    if (self) {
        [self addSubview:self.label];
    }
    return self;
}

- (UILabel *)label {
    if (!_label) {
        _label = [[UILabel alloc] init];
        _label.font = [UIFont systemFontOfSize:14.0f];
    }
    return _label;
}

#pragma mark - TMLazyItemViewProtocol

- (void)mui_afterGetView {
    self.label.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.label.text = self.text;
}

#pragma mark - <TangramElementHeightProtocol>

+ (CGFloat)heightByModel:(TangramDefaultItemModel *)itemModel
{
    return 30.f;
}

@end
