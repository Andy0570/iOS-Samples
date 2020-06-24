原文：[medium: Sign In with Apple](https://medium.com/@robotsNpencils/sign-in-with-apple-1109c49ec577)


苹果公司推出了 Sign In with Apple，这是一个对用户和开发者都很强大的工具。现在我们来向你展示如何使用它。

![](https://upload-images.jianshu.io/upload_images/2648731-007a90775f4073ba.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


很多应用都允许你通过 Facebook 账号或者 Google 账号来注册和登录，而不是创建一个新帐户；这比为你使用的每一款应用创建一个新的账户要方便得多，但代价是需要提供你的个人信息，然后 Google 和 Facebook 就会利用这些信息对你进行定向广告投送。

苹果希望为用户提供一种方法，让用户安全地登录这些应用，以保证你的隐私信息安全。为了实现这一目的，在今年的 WWDC 会议上，苹果推出了一个 "Sign In with Apple" 的按钮，它看起来是这样的：

![](https://upload-images.jianshu.io/upload_images/2648731-eae562df62a88abd.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


苹果不仅仅是向应用开发者“提供”这个功能，而且“要求”所有提供替代登录方式（如通过 Facebook 账号或 Google 账号登录）的应用开发者也必须同时支持 Sign in with Apple（即，通过 Apple 登录）。这将确保用户可以选择使用苹果提供的更具隐私保护的登录方式。

为何它更具有隐私性？Facebook 和谷歌使用用户的登录信息来帮助第三方厂商跟踪用户并提供定向广告投送服务。而苹果的登录方式则不会这么做。

另一个新的隐私功能是，在使用 "通过 Apple 登录"时，用户可以选择使用随机生成的 "虚拟 "电子邮件地址作为自己的账户，该地址将转发电子邮件到用户的真实账户。这可以保护你不必分享你的真实电子邮件地址。用户使用的每个应用都可以使用不同的虚拟电子邮件，所以旗下有多个应用的厂商就无法判断你是否同时使用了他们提供的多个应用。

![](https://upload-images.jianshu.io/upload_images/2648731-9553a00d182ea4c4.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


苹果提供了一个演示该功能基本原理的示例应用程序，我们将在这里运行一些细节，以及一些检查不在示例应用程序中的通知的代码。

## 实现

那么作为开发者，如何在你的应用中进行设置呢？

1. 首先，你需要将 **AuthenticationServices** 框架添加到您的 iOS 13 / Xcode 11项目中。

2. 然后在项目的 "Signing and Capabilities" 标签下，添加 "Sign In with Apple"功能。

    ![](https://upload-images.jianshu.io/upload_images/2648731-427094bb5913a5e6.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)


3. 确保你也在你的团队的"Signing"部分进行了设置，这样 Xcode 就可以创建一个使用 Sign In with Apple 功能的 provisioning 配置文件。

4. 在您的应用程序中添加“通过 Apple 登录”按钮。将其添加到你的登录视图中。你可以在 Interface Builder 中通过创建一个 `UIView` 并将其设置为 `ASAuthorizationAppleIDButton` 类并为其设置一个 Action 动作来添加它，或者通过编程方式添加它：

   ```swift
   import AuthenticationServices
   
   func createButton() {
       let authorizationButton = ASAuthorizationAppleIDButton()
       authorizationButton.addTarget(self, action: 
           #selector(handleAuthorizationAppleIDButtonPress), 
           for: .touchUpInside)
       myView.addSubview(authorizationButton)
   }
   ```

5. 现在确保按钮动作能处理登录请求:

   ```swift
   @objc
   func handleAuthorizationAppleIDButtonPress() {
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
   
        let authorizationController = 
        ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
   }
   ```

   现在你能请求的作用域只有 `.fullName` 和 `.email`。名字和电子邮件将在 Delegate 函数中返回，如步骤8所示。

   需要注意的是，你也可以在登录视图第一次显示时检查登录状态，如果你的应用中已经有了用户名/密码，你也可以通过这种方式询问是否有授权。
   
   ```swift
   /// Prompts the user if an existing iCloud Keychain credential or Apple ID credential is found.
   func performExistingAccountSetupFlows() {
       // Prepare requests for both Apple ID and password providers.
       let requests = [ASAuthorizationAppleIDProvider().createRequest(),
                       ASAuthorizationPasswordProvider().createRequest()]
   
       // Create an authorization controller with the given requests.
       let authorizationController = ASAuthorizationController(authorizationRequests: requests)
       authorizationController.delegate = self
       authorizationController.presentationContextProvider = self
       authorizationController.performRequests()
   } 
   ```
   
6. 第 5 步中的函数将控制器设置为 `presentationContextProvider`，它指定了这个函数。

   ```swift
   extension MyLoginViewController: ASAuthorizationControllerPresentationContextProviding {
        func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
             return self.view.window!
        }
   }
   ```

   这将返回最适合登录授权的 UI 视图。

7. 第 5 步的函数也设置了 delegate 委托，所以我们需要处理委托函数。首先是错误处理：

   ```swift
   extension MyLoginViewController: ASAuthorizationControllerDelegate {
        func authorizationController(controller: ASAuthorizationController, 
                  didCompleteWithError error: Error) {
             // Handle error.
        }
   }
   ```

   其次是处理登录结果：

   ```swift
   extension MyLoginViewController: ASAuthorizationControllerDelegate {
       func authorizationController(controller: ASAuthorizationController,    
                                      didCompleteWithAuthorization authorization: ASAuthorization) {
           if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
   
               let userIdentifier = appleIDCredential.user
               let fullName = appleIDCredential.fullName
               let email = appleIDCredential.email
   
               // Now we have the account information.
               // We can store the userIdentifier in our account 
               // system as the username.
           } else if let passwordCredential = authorization.credential as? ASPasswordCredential {
               // Sign in using an existing iCloud Keychain credential.
               let username = passwordCredential.user
               let password = passwordCredential.password
               
               // handle being logged in the old way
           }
        }
   }
   ```

   

8. 当应用程序启动时，我们可以在 AppDelegate 中检查我们是否已经被授权。

   ```swift
   let userIdentifier = // get saved userIdentifier - sample app uses Keychain
   appleIDProvider.getCredentialState(forUserID: userIdentifier) { (credentialState, error) in
       switch credentialState {
       case .authorized:
           // The Apple ID credential is valid.
           break
       case .revoked:
           // The Apple ID credential is revoked.
           break
       case .notFound:
           // No credential was found, so show the sign-in UI.
           // code ....
       default:
           break
       }
   }
   ```

   与此同时，你也可以关注登录状态的变化：

   ```swift
   let center = NotificationCenter.default
   let name = NSNotification.Name.ASAuthorizationAppleIDProviderCredentialRevoked
   let observer = center.addObserver(forName: name, object: nil, queue: nil) { (notification) in
       // sign user out
       // optionally guide them to sign in again
   }
   ```

   ## 问题

   在测试过程中，我们遇到了几个问题。
   1. 测试应该在真机设备上进行。对`ASAuthorizationAppleIDProvider().getCredentialState(...)`的调用在模拟器中总是失败，会返回 `.notFound`。而在真机设备上，该函数会返回预期的结果。

   2. 示例应用程序没有说明如何处理注销应用程序。它也没有说当用户已经在另一个设备上登录时，应用程序如何处理在新设备上登录。WWDC 会议中提到了这一点，但在示例应用中并没有说明。示例应用中的注销按钮只是清除了用户的本地信息，所以检查用户名失败后会尝试再次登录。它没有实际的登出程序。

   3. 将设备旋转成横向，然后再旋转成纵向（即横竖屏切换），会破坏 UI。

   4. 以用户的视角，我们在授权后会收到这个错误：

      ![](https://upload-images.jianshu.io/upload_images/2648731-e56150f903765c13.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

   
   这些问题的 BUG 报告已经提交，我们将在未来收到反馈后进行更新。
   
   就这样吧! 通过 Apple 登录非常直接。大多数（如果不是所有）打开你的应用程序的用户都有一个苹果账户。有一个第一方的集成授权登录功能将加快开发速度，并且不需要任何社交媒体账户的参与。


