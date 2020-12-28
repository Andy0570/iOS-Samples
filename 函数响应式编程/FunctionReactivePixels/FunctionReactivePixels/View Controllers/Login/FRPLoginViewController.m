//
//  FRPLoginViewController.m
//  FunctionReactivePixels
//
//  Created by Qilin Hu on 2020/12/28.
//

#import "FRPLoginViewController.h"

// Utilities
#import <SVProgressHUD.h>

// View Model
#import "FRPLoginViewModel.h"

@interface FRPLoginViewController ()

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (nonatomic, strong) FRPLoginViewModel *viewModel;

@end

@implementation FRPLoginViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (!self) { return nil; }
    
    self.viewModel = [FRPLoginViewModel new];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 配置导航栏按钮
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:nil action:nil];
    
    // Reactive Stuff
    @weakify(self);
    RAC(self.viewModel, username) = self.usernameTextField.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTextField.rac_textSignal;
    self.navigationItem.rightBarButtonItem.rac_command = self.viewModel.loginCommand;
    
    [[self.viewModel.loginCommand.executionSignals flattenMap:^RACStream *(RACSignal *execution) {
            // Sends RACUnit after the execution completes.
            return [[execution ignoreValues] concat:[RACSignal return:RACUnit.defaultUnit]];
        }] subscribeNext:^(id x) {
            @strongify(self);
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil ];
        }];
    [self.viewModel.loginCommand.errors subscribeNext:^(id x) {
        NSLog(@"Login error:%@", x);
    }];
    
    self.navigationItem.leftBarButtonItem.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            @strongify(self);
            [self.presentingViewController dismissViewControllerAnimated:YES completion:^{
                [subscriber sendCompleted];
            }];
            
            return nil;
        }];
    }];
}



@end
