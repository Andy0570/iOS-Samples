//
//  TangramSimpleTextElement.h
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import <UIKit/UIKit.h>
#import <Tangram/TangramElementHeightProtocol.h>
#import <TMLazyItemViewProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface TangramSimpleTextElement : UIView <TangramElementHeightProtocol, TMLazyItemViewProtocol>

@property (nonatomic, strong) NSString *text;

@end

NS_ASSUME_NONNULL_END
