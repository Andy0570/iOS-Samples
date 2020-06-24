### 1. 项目中开启 Sign In With Apple 功能

在 Xcode 项目的 **TARGETS** 配置中，选择 **Signing & Capabilities** 选项卡。点击左上角的 “+” 按钮，搜索并添加 "Sign In with Apple" 功能。

![](https://upload-images.jianshu.io/upload_images/2648731-b119d944e9eed9cf.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)



### 2. 添加 AuthenticationServices 框架

在 TARGETS —> General —> Frameworks 下添加 **AuthenticationServices** 框架：

![](https://upload-images.jianshu.io/upload_images/2648731-5aca6465d48728cd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

然后在所需的视图控制器中导入 `<AuthenticationServices/AuthenticationServices.h>` 框架：
```objectivec
#import<AuthenticationServices/AuthenticationServices.h>
```

### 3. 添加标识符

在这里，我创建了 `setCurrentIdentifier` 标识符对象用于保存当前用户，然后让当前视图控制器遵守 `ASAuthorizationControllerDelegate` 和 `ASAuthorizationControllerPresentationContextProviding` 代理。

```objectivec
#import "ViewController.h"
#import <AuthenticationServices/AuthenticationServices.h>

static NSString * const setCurrentIdentifier = @"setCurrentIdentifier";

@interface ViewController () <ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding>

@end
```

### 4. 创建并加载「通过 Apple 登录」按钮，发起授权

```objectivec
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
```

在按钮点击事件中，发起授权，获取用户的 Appid 身份信息，该方法需要实现的主要有两个部分：
 1. 使用 Provider 创建 Request
 2. 使用 ASAuthorizationController 实例执行 Request

```objectivec
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
```

### 5. 实现授权回调协议（ASAuthorizationControllerDelegate）中的方法

授权成功的回调：

```objectivec
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithAuthorization:(ASAuthorization *)authorization NS_SWIFT_NAME(authorizationController(controller:didCompleteWithAuthorization:)) {
        
    if ([authorization.credential isKindOfClass:[ASAuthorizationAppleIDCredential class]]) {
        // 用户登录使用 ASAuthorizationAppleIDCredential
        ASAuthorizationAppleIDCredential *appleIDCredential = authorization.credential;

        NSString *user = appleIDCredential.user;
        NSString *nickname = appleIDCredential.fullName.nickname;
        NSData *identityToken = appleIDCredential.identityToken;
        NSLog(@"user:%@, nickname:%@, identityToken:%@", user, nickname, identityToken);
        
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
```

授权失败的回调：

```objectivec
- (void)authorizationController:(ASAuthorizationController *)controller didCompleteWithError:(NSError *)error  NS_SWIFT_NAME(authorizationController(controller:didCompleteWithError:)) {
    
    NSString *errorMsg;
    switch (error.code) {
        case ASAuthorizationErrorUnknown: {
            errorMsg = @"授权请求失败，未知原因";
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
            errorMsg = @"获取授权失败";
            break;
        }
    }
    
    NSLog(@"error message:%@", errorMsg);
}
```

以上代码中，授权失败状态（`ASAuthorizationError`）是一个枚举类型，我们通过 `switch-case` 语法遍历授权失败状态枚举值，并执行不同的处理流程。

```objectivec
typedef NS_ERROR_ENUM(ASAuthorizationErrorDomain, ASAuthorizationError) {
    ASAuthorizationErrorUnknown = 1000,         // 授权请求失败未知原因
    ASAuthorizationErrorCanceled = 1001,        // 用户取消了授权请求
    ASAuthorizationErrorInvalidResponse = 1002, // 授权请求响应无效
    ASAuthorizationErrorNotHandled = 1003,      // 未能处理授权请求
    ASAuthorizationErrorFailed = 1004,          // 授权请求失败
} API_AVAILABLE(ios(13.0), macos(10.15), tvos(13.0), watchos(6.0));
```

### 6. 实现显示授权控制器的回调方法（ASAuthorizationControllerPresentationContextProviding）

```objectivec
#pragma mark - <ASAuthorizationControllerPresentationContextProviding>

// 告诉代理应该在哪个 window 展示内容给用户
- (ASPresentationAnchor)presentationAnchorForAuthorizationController:(ASAuthorizationController *)controller {
    return self.view.window;
}
```


### 6. 监听授权状态改变的通知

```objectivec
- (void)dealloc {
    if (@available(iOS 13.0, *)) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}

- (void)observeAppleSignInState {
    // MARK: 监听通过 Apple 登录的授权状态，判断授权是否失效
    if (@available(iOS 13.0, *)) {
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(handleSignInWithAppleStateChanged:) name:ASAuthorizationAppleIDProviderCredentialRevokedNotification object:nil];
    }
}
```

当授权状态改变时，执行的方法：

```objectivec
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
```
其中，授权状态 `ASAuthorizationAppleIDProviderCredentialState` 是一个枚举类型：
```objectivec
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
```
在以上方法中，需要通过 `switch-case` 语法遍历该枚举类型的不同状态，并执行不同的处理流程。

### Apple ID 的唯一性

Apple 通过授权凭证（`ASAuthorizationAppleIDCredential`）的 `user` 属性返回用户 ID，即使用户取消授权，然后再重新授权，该 ID 属性的值并不会改变，仍然是唯一的。这里简单测试如下。
第一次发起授权，获取并返回 `user` 值如下：
```
000701.c78c577e89ac4c56af2208c05947ca41.0652
```
接着，打开系统设置-用户-密码与安全性-使用您 Apple ID 的 App - 在授权应用列表中删除该应用以取消授权。
重新打开应用，点击「通过 Apple 登录」按钮重新登录，系统返回的 `user` 值仍为：
```
000701.c78c577e89ac4c56af2208c05947ca41.0652
```

可见，对于同一个应用下的同一个 Apple ID 用户，返回的 `user` 值是唯一的。



源码参考：[GitHub: Sign-In-with-Apple](https://github.com/karthiksaral/Sign-In-with-Apple)


#### Apple 文档
- [如何使用 “通过 Apple 登录” 功能](https://support.apple.com/zh-cn/HT210318)
- [有关 “通过 Apple 登录” 的指南更新](https://developer.apple.com/cn/news/?id=09122019b)
- [Apple Store 审核指南: 4.8 通过 Apple 登录](https://developer.apple.com/cn/sign-in-with-apple/get-started/)
- [Human Interface Guidelines - Sign in with Apple](https://developer.apple.com/design/human-interface-guidelines/sign-in-with-apple/overview/introduction/)
- [Sample Code: Implementing User Authentication with Sign in with Apple](https://developer.apple.com/documentation/authenticationservices/implementing_user_authentication_with_sign_in_with_apple?language=objc)
- [Web Service Endpoint: Generate and Validate Tokens](https://developer.apple.com/documentation/sign_in_with_apple/generate_and_validate_tokens)

#### 社区博客
- [stackoverflow: How to integrate 'Sign in with Apple' flow in iOS Objective-C?](https://stackoverflow.com/questions/58813712/how-to-integrate-sign-in-with-apple-flow-in-ios-objective-c)
- [简书：Sign In With Apple（一）](https://www.jianshu.com/p/c101b61abaeb)
- [简书：iOS 开发：Sign In With Apple（使用 Apple 登录）](https://www.jianshu.com/p/efb02bc8935a)
- [快速配置 Sign In with Apple](https://mp.weixin.qq.com/s/xkxCnKqA0u-guEYcYCkcOg)
- [Medium: iOS 13 — Sign In with Apple Tutorial](https://medium.com/@avitsadok/ios-13-sign-in-with-apple-tutorial-b71bb3f68de)
- [Medium: Sign In with Apple](https://www.jianshu.com/p/24497d4b2da3)


