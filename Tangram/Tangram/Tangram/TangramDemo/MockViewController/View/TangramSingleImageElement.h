//
//  TangramSingleImageElement.h
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import <UIKit/UIKit.h>
#import <Tangram/TangramElementHeightProtocol.h>
#import <Tangram/TangramDefaultItemModel.h>
#import <Tangram/TangramEasyElementProtocol.h>
#import <TMLazyItemViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface TangramSingleImageElement : UIControl <TangramElementHeightProtocol, TMLazyItemViewProtocol>

@property (nonatomic, strong) NSString *imgUrl;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, weak) TangramDefaultItemModel *tangramItemModel;
@property (nonatomic, weak) UIView<TangramLayoutProtocol> *atLayout;
@property (nonatomic, weak) TangramBus *tangramBus;
@property (nonatomic, strong) NSString *action;

@end

NS_ASSUME_NONNULL_END
