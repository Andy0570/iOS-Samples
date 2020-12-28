//
//  FRPLoginViewModel.h
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import "RVMViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface FRPLoginViewModel : RVMViewModel

@property (nonatomic, readonly) RACCommand *loginCommand;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;

@end

NS_ASSUME_NONNULL_END
