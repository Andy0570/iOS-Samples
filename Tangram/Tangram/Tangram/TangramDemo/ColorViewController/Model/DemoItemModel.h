//
//  DemoItemModel.h
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <Tangram/TangramItemModelProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoItemModel : NSObject <TangramItemModelProtocol>

@property (nonatomic, assign) CGRect itemModelFrame;
@property (nonatomic, assign) BOOL isBlock;
@property (nonatomic, assign) NSUInteger indexInLayout;

@end

NS_ASSUME_NONNULL_END
