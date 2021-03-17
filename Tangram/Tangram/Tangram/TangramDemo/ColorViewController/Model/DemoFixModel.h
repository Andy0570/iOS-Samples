//
//  DemoFixModel.h
//  Tangram
//
//  Created by Qilin Hu on 2021/3/16.
//

#import <Foundation/Foundation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <Tangram/TangramItemModelProtocol.h>

NS_ASSUME_NONNULL_BEGIN

@interface DemoFixModel : NSObject <TangramItemModelProtocol>

@property   (nonatomic, assign) NSUInteger index;
@property   (nonatomic, assign) CGRect itemModelFrame;

@end

NS_ASSUME_NONNULL_END
