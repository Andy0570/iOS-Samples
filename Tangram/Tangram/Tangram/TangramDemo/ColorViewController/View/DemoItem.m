//
//  DemoItem.m
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import "DemoItem.h"
#import "DemoItemModel.h"

@implementation DemoItem

- (NSObject<TangramItemModelProtocol> *)model {
    return _itemModel;
}

@end
