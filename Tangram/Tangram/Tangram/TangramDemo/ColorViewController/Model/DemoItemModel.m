//
//  DemoItemModel.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "DemoItemModel.h"

@implementation DemoItemModel



#pragma mark - <TangramItemModelProtocol>

- (void)setItemFrame:(CGRect)itemFrame {
    _itemModelFrame = itemFrame;
}

- (CGRect)itemFrame {
    // return _itemModelFrame
    return CGRectMake(_itemModelFrame.origin.x,
                      _itemModelFrame.origin.y,
                      _itemModelFrame.size.width,
                      _itemModelFrame.size.height);
}

- (NSString *)display {
    return @"inline";
}

- (TangramItemType *)itemType {
    return @"demo";
}

- (NSString *)reuseIdentifier {
    return @"demo_model_reuse_identifier";
}

- (CGFloat)marginTop {
    return 5.f;
}

- (CGFloat)marginRight {
    return 5.f;
}

- (CGFloat)marginBottom {
    return 5.f;
}

- (CGFloat)marginLeft {
    return 5.f;
}

@end
