//
//  FRPLoginViewModel.m
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import "FRPLoginViewModel.h"
#import "FRPPhotoImporter.h"

@interface FRPLoginViewModel ()
@property (nonatomic, strong) RACCommand *loginCommand;
@end

@implementation FRPLoginViewModel

- (instancetype)init {
    self = [super init];
    if (!self) { return nil; }
    
    @weakify(self);
    self.loginCommand = [[RACCommand alloc] initWithEnabled:[self validateLoginInputs] signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [FRPPhotoImporter logInWithUsername:self.username password:self.password];
    }];
    
    return self;
}

/**
 RACObserve(self, username) 监听 username 属性的变化
 RACObserve(self, password) 监听 password 属性的变化
 
 combineLatest:reduce: 合并两个信号，变为一个信号输出
 */
- (RACSignal *)validateLoginInputs {
    return [RACSignal combineLatest:@[RACObserve(self, username), RACObserve(self, password)] reduce:^id(NSString *username, NSString *password) {
        return @(username.length > 0 && password.length > 0);
    }];
}


@end
