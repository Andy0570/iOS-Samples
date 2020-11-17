> 原文：[Using UIImagePickerController on iOS @2020-04-01](https://ikyle.me/blog/2020/uiimagepickercontroller)
> 原文作者：[Kyle Howells](https://ikyle.me/)

如何在 iOS 上使用 Objective-C 和 Swift 语言实现使用 `UIImagePickerController` 从照片库中选择照片？

允许用户选择照片的最简单的方法是使用 `UIImagePickerController` 类，它为用户提供了一个内置的 UI 来访问照片。

实现起来非常简单。

1. 声明你的类遵守 `UIImagePickerControllerDelegate` 和 `UINavigationControllerDelegate` 协议。
2. 实现 `-imagePickerController:didFinishPickingMediaWithInfo:` 方法。
3. 初始化  `UIImagePickerController`  实例对象，并呈现该视图控制器。
4. 对返回的图像进行处理。

Objective-C：

```objc
- (void)pickPhoto {
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePicker.delegate = self;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

// 实现 UIImagePickerControllerDelegate 委托协议中的方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<UIImagePickerControllerInfoKey,id> *)info{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    self.imageView.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}
```

Swift:

```swift
func pickPhoto() {
    let imagePicker = UIImagePickerController()
    imagePicker.sourceType = .photoLibrary
    imagePicker.delegate = self
    present(imagePicker, animated: true)
}

// 实现 UIImagePickerControllerDelegate 委托协议中的方法
public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any])
    imageView.image = (info[.originalImage] as? UIImage)
    picker.dismiss(animated: true, completion: nil)
}
```



# 脚注

## UIImagePickerControllerSourceType

* `UIImagePickerControllerSourceTypePhotoLibrary` (`.photoLibrary`) 允许用户从他们的全部照片库中挑选图片，包括浏览他们的相册。
* `UIImagePickerControllerSourceTypeSavedPhotosAlbum` (`.savedPhotosAlbum`) 将选择范围限制在其按时间顺序排列的 "时刻 "画面、相机胶卷上。
* `UIImagePickerControllerSourceTypeCamera` (`.camera`) 显示拍摄界面，这样用户就可以拍照，然后显示在应用中。

**注意**：除非在项目的 `info.plist` 文件中配置 `NSCameraUsageDescription` 键，否则使用`UIImagePickerControllerSourceTypeCamera(.camera)` 会让应用崩溃，并带有以下错误信息；与其他两个不同的是，它将用户选择照片的行为作为隐含的同意将该照片也交给应用，并且自 iOS 11 以来没有提示权限，因为 iOS 11 将其改为单独的进程运行（因此不再需要`NSPhotoLibraryUsageDescription` 键）。

```
[access] This app has crashed because it attempted to access privacy-sensitive data without a usage description.
The app's Info.plist must contain an NSCameraUsageDescription key with a string value explaining to the user how the app uses this data.
```

## 选择照片、视频或两者兼有

默认情况下，`UIImagePickerController` 将只显示并选择用户图片库中的图片。但这实际上是通过 `mediaTypes` 属性控制的，它作为一个过滤器。要选择照片和视频，你可以将数组设置为包括视频。

Objective-C：

```objc
@import MobileCoreServices; // kUTTypeImage 和 kUTTypeMovie 被定义在其中
imagePicker.mediaTypes = @[(NSString*)kUTTypeImage, (NSString*)kUTTypeMovie];
```

Swift:

```swift
import MobileCoreServices
imagePicker.mediaTypes = [(kUTTypeImage as String), (kUTTypeMovie as String)]
```

要获取视频，你需要从返回的字典信息中获取`UIImagePickerControllerMediaURL`（`.mediaURL`）键，而不是 `UIImagePickerControllerOriginalImage`（`.originalImage`）值。

**注意**：该属性的[开发者文档](https://developer.apple.com/documentation/uikit/uiimagepickercontroller/1619173-mediatypes?language=objc)中包含了这个有趣的评论，涉及到那些你开启了 "Bounce and Loop" 等效果的 Live Photos。

> If you want to display a Live Photo rendered as a Loop or a Bounce, you must include the kUTTypeMovie identifier.
>
> 如果你想显示开启了循环播放或弹簧动画的实况照片（Live Photo），那么你就必须在 `mediaTypes` 属性中包含 `kUTTypeMovie` 标识符。

要为数据源指定所有可用的媒体类型，请使用类似这样的语句：

```objc
myImagePickerController.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
        UIImagePickerControllerSourceTypeCamera];
```

## 可用性检查

`UIImagePickerController` 还包括几个类方法来检查不同功能的可用性。

Objective-C：

```objc
if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
    // 此设备有一个摄像头
}
NSArray *mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
// 这款相机可以拍摄视频，还是只能够拍摄照片（即：第一款 iPhone 与 iPhone 3G 的对比）。
```

Swift:

```Swift
if UIImagePickerController.isSourceTypeAvailable(.camera) {
    // 此设备有一个摄像头
}
let mediaTypes:[String]? = UIImagePickerController.availableMediaTypes(for: .camera)
// 这款相机可以拍摄视频，还是只能够拍摄照片（即：第一款 iPhone 与 iPhone 3G 的对比）。
```

## 其他

还有更多的 API，比如获取闪光灯的可用性，检查前后摄像头的可用性，分别检查每个摄像头的能力，以及允许在将照片交给你的应用程序之前对其进行基本的编辑。[官方 UIImagePickerController 文档](https://developer.apple.com/documentation/uikit/uiimagepickercontroller?language=objc)

## 局限性

`UIImagePickerController` 是一个非常有用和方便的类，可以在应用程序中快速添加图片选择器。但它也有局限性：

* 不支持多选
* 有限的过滤选项（只能选择照片、视频，或两者兼选）。
* 不能直接通过程序访问照片库（只能访问给你的照片）。
* 有限的相机访问或 UI 定制。

如果你想要这些功能，那么你就需要使用 `AVFoundation` 来制作一个自定义的相机 UI，或者使用 `PhotoKit`（这将是下一篇博文的主题）来制作一个自定义的图像选择器。