> 原文：[RIP Tutorial: **Generic usage of UIImagePickerController**](https://riptutorial.com/ios/example/10266/generic-usage-of-uiimagepickercontroller)



# 示例

**第一步：创建控制器，设置委托，遵守协议。**

```swift
//Swift
class ImageUploadViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePickerController = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
    }
}

//Objective-C
@interface ImageUploadViewController : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate> {

    UIImagePickerController *imagePickerController;

}

@end

@implementation ImageUploadViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    imagePickerController.delegate = self;

}

@end
```

注意：实际上我们不会实现 `UINavigationControllerDelegate` 中定义的任何协议方法，但由于 `UIImagePickerController` 继承自 `UINavigationController`，并且改变了 `UINavigationController`的行为。因此，我们仍然需要主动声明我们的视图控制器遵守 `UINavigationControllerDelegate` 协议。

**第二步：在你需要的时候显示 `UIImagePickerController`。**

```swift
//Swift
self.imagePickerController.sourceType = .Camera // options: .Camera , .PhotoLibrary , .SavedPhotosAlbum
self.presentViewController(self.imagePickerController, animated: true, completion: nil)

//Objective-C
imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera; // options: UIImagePickerControllerSourceTypeCamera, UIImagePickerControllerSourceTypePhotoLibrary, UIImagePickerControllerSourceTypeSavedPhotosAlbum
[self presentViewController:imagePickerController animated:YES completion:nil];
```

**第三步：实现委托方法。**

```swift
//Swift
func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
    if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
        // Your have pickedImage now, do your logic here
    }
    self.dismissViewControllerAnimated(true, completion: nil)
}

func imagePickerControllerDidCancel(picker: UIImagePickerController) {
    self.dismissViewControllerAnimated(true, completion: nil)
}

//Objective-C
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {

   UIImage *pickedImage = info[UIImagePickerControllerOriginalImage];

    if (pickedImage) {
    
        //You have pickedImage now, do your logic here
    
    }

    [self dismissViewControllerAnimated:YES completion:nil];

}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {

    [self dismissViewControllerAnimated:YES completion:nil];

}
```