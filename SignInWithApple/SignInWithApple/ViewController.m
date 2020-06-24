//
//  ViewController.m
//  SignInWithApple
//
//  Created by Qilin Hu on 2020/6/23.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>

NSString* const setCurrentIdentifier = @"setCurrentIdentifier";

@interface ViewController () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@end

@implementation ViewController

#pragma mark - View life cycle

- (void)dealloc {
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithHue:168/360.0f saturation:86/100.0f brightness:74/100.0f alpha:1.0];
    
    if (@available(iOS 13.0, *)) {
        [self setupUI];
        [self observeAppleSignInState];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    [self perfomExistingAccountSetupFlows];
}

/**
// 按钮上文字的显示
typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDButtonType) {
    ASAuthorizationAppleIDButtonTypeSignIn,   // Sign in with Apple（通过Apple登录）
    ASAuthorizationAppleIDButtonTypeContinue, // Continue with Apple（通过Apple继续）

    ASAuthorizationAppleIDButtonTypeDefault = ASAuthorizationAppleIDButtonTypeSignIn,
}
*/

/**
 // 按钮的风格
 typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDButtonStyle) {
     ASAuthorizationAppleIDButtonStyleWhite,   // 白色的背景，黑色的文字和图标
     ASAuthorizationAppleIDButtonStyleWhiteOutline, // 带有褐色的边框、黑色额字体和图标，白色的背景
     ASAuthorizationAppleIDButtonStyleBlack,// 黑色的背景，白色的文字和图标
 }
 */
- (void)setupUI {
    // MARK: 添加 「通过 Apple 登录」按钮
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *appleIDButton = [ASAuthorizationAppleIDButton buttonWithType:ASAuthorizationAppleIDButtonTypeSignIn style:ASAuthorizationAppleIDButtonStyleWhite];
        // 注：根据 Apple 要求,「通过 Apple 登录」按钮的尺寸不得小于 140*30
        appleIDButton.frame = CGRectMake(50, 150, 200, 44);
        // 该按钮默认有圆角，当然，你也可以自定义圆角尺寸
        // appleIDButton.cornerRadius = 5;
        [appleIDButton addTarget:self action:@selector(handleAuthrization:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:appleIDButton];
    }
}

- (void)observeAppleSignInState {
    // MARK: 监听通过 Apple 登录的授权状态，判断授权是否失效
    if (@available(iOS 13.0, *)) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

//! 如果存在 iCloud Keychain 凭证或者 AppleID 凭证提示用户
- (void)perfomExistingAccountSetupFlows {
    if (@available(iOS 13.0, *)) {
        // A mechanism for generating requests to authenticate users based on their Apple ID.
        // 基于用户的 Apple ID 授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIDProvider = [ASAuthorizationAppleIDProvider new];
        
        // An OpenID authorization request that relies on the user’s Apple ID.
        // 授权请求依赖于用于的 AppleID
        ASAuthorizationAppleIDRequest *authAppleIDRequest = [appleIDProvider createRequest];
        
        // A mechanism for generating requests to perform keychain credential sharing.
        // 为了执行钥匙串凭证分享生成请求的一种机制
        ASAuthorizationPasswordRequest *passwordRequest = [[ASAuthorizationPasswordProvider new] createRequest];
        
        NSMutableArray <ASAuthorizationRequest *>* mArr = [NSMutableArray arrayWithCapacity:2];
        if (authAppleIDRequest) {
            [mArr addObject:authAppleIDRequest];
        }
        if (passwordRequest) {
            [mArr addObject:passwordRequest];
        }
        // ASAuthorizationRequest：A base class for different kinds of authorization requests.
        // ASAuthorizationRequest：对于不同种类授权请求的基类
        NSArray <ASAuthorizationRequest *>* requests = [mArr copy];
        
        // A controller that manages authorization requests created by a provider.
        // 由ASAuthorizationAppleIDProvider创建的授权请求 管理授权请求的控制器
        // Creates a controller from a collection of authorization requests.
        // 从一系列授权请求中创建授权控制器
        ASAuthorizationController *authorizationController = [[ASAuthorizationController alloc] initWithAuthorizationRequests:requests];
        // A delegate that the authorization controller informs about the success or failure of an authorization attempt.
        // 设置授权控制器通知授权请求的成功与失败的代理
        authorizationController.delegate = self;
        // A delegate that provides a display context in which the system can present an authorization interface to the user.
        // 设置提供 展示上下文的代理，在这个上下文中 系统可以展示授权界面给用户
        authorizationController.presentationContextProvider = self;
        // starts the authorization flows named during controller initialization.
        // 在控制器初始化期间启动授权流
        [authorizationController performRequests];
    }
}

#pragma mark - Actions

/**
 「通过 Apple 登录」按钮点击事件：
 1. 使用 Provider 创建 Request
 2. 使用 ASAuthorizationController 实例执行 Request
 */
- (void)handleAuthrization:(ASAuthorizationAppleIDButton *)button {
    if (@available(iOS 13.0, *)) {
        // 基于用户的 Apple ID 授权用户，生成用户授权请求的一种机制
        ASAuthorizationAppleIDProvider *appleIdProvider = [[ASAuthorizationAppleIDProvider alloc] init];
        
        // 创建新的 AppleID 授权请求
        ASAuthorizationAppleIDRequest *request = appleIdProvider.createRequest;
        // 在用户授权期间请求的联系信息
        request.requestedScopes = @[ASAuthorizationScopeEmail, ASAuthorizationScopeFullName];
        
        // 由 ASAuthorizationAppleIDProvider 创建的授权请求，管理授权请求的控制器
        ASAuthorizationController *controller = [[ASAuthorizationController alloc] initWithAuthorizationRequests:@[request]];
        
        // 设置授权控制器通知授权请求的成功与失败的代理
        controller.delegate = self;
        
        // 设置提供展示上下文的代理，在这个上下文中，系统可以向用户展示授权界面
        controller.presentationContextProvider = self;
        
         // 在控制器初始化期间启动授权流
        [controller performRequests];
    }
}

#pragma mark - <ASAuthorizationControllerDelegate>

// 授权成功的回调
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization NS_SWIFT_NAME(authorizationController(controller:didCompleteWithAuthorization:)) {
        
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用 ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;
        NSLog(@"credential:\n%@,",appleIDCredential);
        
        NSString *user = appleIDCredential.user;
        NSLog(@"user = %@", user);
        
        NSString *email = appleIDCredential.email;
        NSLog(@"email = %@", email);
        
        NSPersonNameComponents *fullname = appleIDCredential.fullName;
        NSLog(@"fullname = %@", fullname);
        
        NSData *identityToken = appleIDCredential.identityToken;
        NSLog(@"identityToken = %@", [[NSString alloc] initWithData:identityToken encoding:NSUTF8StringEncoding]);
        
        // 授权成功后，你可以拿到苹果返回的全部数据，根据需要和后台交互。
        // 需要使用钥匙串的方式保存用户的唯一信息，这里暂且处于测试阶段，NSUserDefaults
        // 保存apple返回的唯一标识符
        [[NSUserDefaults standardUserDefaults] setObject:user forKey:setCurrentIdentifier];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    } else if ([authorization.credential isKindOfClass:[ASPasswordCredential class]]) {
        // 用户登录使用现有的密码凭证
        ASPasswordCredential *psdCredential = authorization.credential;
        // 密码凭证对象的用户标识 用户的唯一标识
        NSString *user = psdCredential.user;
        // 密码凭证对象的密码
        NSString *psd = psdCredential.password;
        NSLog(@"psduser -  %@   %@",psd,user);
    } else {
        NSLog(@"授权信息不符");
    }
}

/**
 授权失败的回调
 
 typedef NS_ERROR_ENUM(ASAuthorizationErrorDomain, ASAuthorizationError) {
     ASAuthorizationErrorUnknown = 1000,
     ASAuthorizationErrorCanceled = 1001,
     ASAuthorizationErrorInvalidResponse = 1002,
     ASAuthorizationErrorNotHandled = 1003,
     ASAuthorizationErrorFailed = 1004,
 } API_AVAILABLE(ios(13.0), macos(10.15), tvos(13.0), watchos(6.0));
 */
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  NS_SWIFT_NAME(authorizationController(controller:didCompleteWithError:)) {
    NSLog(@"%@",error);
    
    NSString *errorMsg;
    switch (error.code) {
        case ASAuthorizationErrorUnknown: {
            errorMsg = @"授权请求失败未知原因";
            break;
        }
        case ASAuthorizationErrorCanceled: {
            errorMsg = @"用户取消了授权请求";
            break;
        }
        case ASAuthorizationErrorInvalidResponse: {
            errorMsg = @"授权请求响应无效";
            break;
        }
        case ASAuthorizationErrorNotHandled: {
            errorMsg = @"未能处理授权请求";
            break;
        }
        case ASAuthorizationErrorFailed: {
            errorMsg = @"授权请求失败";
            break;
        }
    }
    
    NSLog(@"error message:%@", errorMsg);
}

#pragma mark - <ASAuthorizationControllerPresentationContextProviding>

// 告诉代理应该在哪个 window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return self.view.window;
}

#pragma mark - NSNotificationCenter

/**
typedef NS_ENUM(NSInteger, ASAuthorizationAppleIDProviderCredentialState) {
    // 授权状态失效（用户停止使用 AppID 登录 App）
    ASAuthorizationAppleIDProviderCredentialRevoked,
    // 已授权（用户已使用 AppleID 登录过 App）
    ASAuthorizationAppleIDProviderCredentialAuthorized,
    // 授权凭证缺失（可能是使用 AppleID 登录过 App）
    ASAuthorizationAppleIDProviderCredentialNotFound,
    // 授权 AppleID 提供者凭证已转移
    ASAuthorizationAppleIDProviderCredentialTransferred,
}
*/
- (void)handleSignInWithAppleStateChanged:(NSNotification *)notification {
    NSLog(@"%s", __FUNCTION__);
    NSLog(@"%@", notification);
    
    if (@available(iOS 13.0,*)) {
        // 基于用户的 Apple ID 生成授权用户请求的机制
        ASAuthorizationAppleIDProvider *provider = [[ASAuthorizationAppleIDProvider alloc] init];
        
        // 注意 存储用户标识信息需要使用钥匙串来存储 这里笔者简单期间 使用NSUserDefaults 做的简单示例
        NSString *user = [[NSUserDefaults standardUserDefaults] objectForKey:@"userIdentifier"];
        NSLog(@"user11 -     %@",user);
        
        __block NSString *errorMsg;
        [provider getCredentialStateForUserID:user completion:^(ASAuthorizationAppleIDProviderCredentialState credentialState, NSError * _Nullable error) {
            if (!error) {
                switch (credentialState) {
                    case ASAuthorizationAppleIDProviderCredentialRevoked: {
                        NSLog(@"Revoked");
                        errorMsg = @"苹果授权凭证失效";
                        break;
                    }
                    case ASAuthorizationAppleIDProviderCredentialAuthorized: {
                        NSLog(@"Authorized");
                        errorMsg = @"苹果授权凭证状态良好";
                        break;
                    }
                    case ASAuthorizationAppleIDProviderCredentialNotFound: {
                        NSLog(@"NotFound");
                        errorMsg = @"未发现苹果授权凭证";
                        break;
                    }
                    case ASAuthorizationAppleIDProviderCredentialTransferred: {
                        NSLog(@"CredentialTransferred");
                        errorMsg = @"未发现苹果授权凭证";
                        break;
                    }
                }
            } else {
                NSLog(@"state is failure");
            }
        }];
    }
}


@end
