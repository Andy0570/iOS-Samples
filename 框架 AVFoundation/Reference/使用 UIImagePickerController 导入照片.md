# 使用UIImagePickerController导入照片

> 原文：[Importing photos with UIImagePickerController @Hacking With Swift](https://www.hackingwithswift.com/read/10/4/importing-photos-with-uiimagepickercontroller)

当用户与单元格进行交互时，有很多集合视图事件需要处理，但我们稍后会回来讨论这个话题。现在，让我们看看如何使用`UIImagePickerController` 导入图片。这个新类的目的是让用户从相机中选择一张图片导入到应用程序中。当你第一次创建一个`UIImagePickerController` 对象时，iOS 会自动询问用户应用程序是否可以访问他们的照片。

首先，我们需要创建一个按钮，让用户将人添加到应用中。这很简单，只要在 `viewDidLoad()` 方法中添加以下内容即可：

```swift
navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addNewPerson))
```

`addNewPerson()` 方法是我们需要使用`UIImagePickerController` 的地方，但它的操作非常简单，我只给你看代码：

```swift
@objc func addNewPerson() {
    let picker = UIImagePickerController()
    picker.allowsEditing = true
    picker.delegate = self
    present(picker, animated: true)
}
```

这里面有三个有趣的东西。

1. 我们把 `allowsEditing` 属性设置为 `true`, 这样用户就可以裁剪他们选择的图片了。
2. 当你把 `self` 设置为 `delegate` 时，你不仅需要遵守 `UIImagePickerControllerDelegate` 协议，还需要同时遵守 `UINavigationControllerDelegate` 协议。
3. 整个方法是使用 `#selector` 从 `Objective-C` 代码中调用的，所以我们需要使用 `@objc` 属性。这是我最后一次重复这一点，但希望你在心理上一直期待 `#selector` 与 `@objc` 的搭配。

在 `ViewController.swift` 文件中，修改这一行：

```swift
class ViewController: UICollectionViewController {
```

改为：

```swift
class ViewController: UICollectionViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
```

这就告诉 Swift 你承诺你的类支持 `UIImagePickerControllerDelegate` 和 `UINavigationControllerDelegate` 这两个协议所要求的所有功能。其中第一个协议很有用，告诉我们何时用户选择了一张图片或者取消了拾取器。第二个，`UINavigationControllerDelegate`，在这里真的是很没有意义的，所以除了修改你的类声明来包含协议之外，不要担心它。

当你遵守 `UIImagePickerControllerDelegate` 协议时，你不需要添加任何方法，因为这两个都是可选的。但其实不然--不管出于什么原因，它们都被标记为可选，但除非你至少实现了其中的一个方法，否则你的代码就没什么用了!

我们关心的委托方法是 `imagePickerController(_，didFinishPickingMediaWithInfo:)`，当用户选择了一张图片，并将其返回给你时，该方法就会返回。这个方法需要做几件事。

* 从作为参数传递的字典实例中提取图片。
* 为它生成一个唯一的文件名。
* 将其转换为 JPEG 格式，然后将该 JPEG 格式的图片写入磁盘。
* 推出视图控制器。

为了让这些工作顺利进行，你需要学习一些新的东西。

首先，苹果公司通常会给你发送一个包含多个信息的字典作为方法参数。这有时会很难操作，因为你需要知道字典中键的名称，以便能够挑选出值，但随着时间的推移，你会掌握它的窍门。

这个字典参数将包含两个键中的一个：`.editedImage`（被编辑的图片）或 `.originalImage`，但在我们这里的情况中，它应该永远是前者，除非你改变 `allowEditing` 属性。

问题就在于，我们不知道这个值是否作为一个 `UIImage` 对象存在，所以我们不能直接提取它。相反，我们需要使用可选类型解析方法，比如 `?` 以及 `if let`。使用这种方法，我们可以确保我们总是能得到正确的结果。

其次，我们需要为我们导入的每一张图片生成一个唯一的文件名。这样我们就可以把它存储到我们的应用程序在磁盘上的空间中，而不会覆盖任何现有的东西，如果用户从他们的照片库中删除了图片，我们仍然有对应的备份文件。我们将使用一种新的类型，称为 **UUID**，它可以生成一个通用唯一标识符，非常适合随机文件名。

第三，一旦我们有了图片对象，还需要把它写入磁盘。你需要学习两段新的代码。`UIImage` 有一个 `jpegData()` 来将它转换为 `JPEG`图像格式的 `Data` 对象, 还有一个 `Data` 上的方法叫 `write(to:)`, 好吧, 将它的数据写入磁盘. 我们前面用过 `Data`，但提醒一下，它是一种比较简单的数据类型，可以容纳任何类型的二进制类型--图像数据、压缩文件数据、电影数据等等。

把信息写到磁盘上很容易，但是找到放信息的地方就很棘手了。所有安装的应用都有一个名为 “Documents" 的目录，在这个目录下，你可以保存应用的私有信息，而且它还会自动与 iCloud 同步。问题是，如何找到那个目录并不明显，所以我有一个我使用的方法，叫做`getDocumentsDirectory()`，它正好可以做到这一点--你不需要理解它的工作原理，但你需要把它复制到你的代码中。

说了这么多，下面是就是这个新的方法：

```swift
func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
    guard let image = info[.editedImage] as? UIImage else { return }

    let imageName = UUID().uuidString
    let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

    if let jpegData = image.jpegData(compressionQuality: 0.8) {
        try? jpegData.write(to: imagePath)
    }

    dismiss(animated: true)
}

func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    return paths[0]
}
```

同样，`getDocumentsDirectory()` 如何工作并不重要，但如果你好奇的话：`FileManager.default.urls` 的第一个参数询问文档目录，它的第二个参数补充说我们希望路径是相对于用户的主目录。这将返回一个数组，这个数组几乎总是只包含一个东西：用户的文档目录。所以，我们调出第一个元素并返回它。

现在进入重要的代码：正如你所看到的，我已经使用了 `guard` 来提取并获取图片拾取器中的图片，因为如果失败了，我们要立即退出方法。然后我们创建一个 `UUID` 对象，并使用它的 `uuidString` 属性将唯一标识符转换为字符串数据类型。

然后代码创建了一个新的常量 `imagePath`，它接收`getDocumentsDirectory()` 的 `URL` 路径结果，并对其调用一个新的方法：`appendingPathComponent()`。这是在处理文件路径时使用的，它为一个路径添加一个字符串（在我们的例子中是`imageName`），包括平台上使用的任何路径分隔符。

现在我们已经有了一个包含图像和路径的 `UIImage`，我们需要将`UIImage` 转换为 `Data` 对象，以便保存。要做到这一点，我们使用 `jpegData()` 方法，它需要一个参数：一个介于 `0` 和 `1` 之间的质量值，其中 `1` 代表 "最大图片保真度"。

一旦我们有了一个包含 JPEG 数据的 `Data` 对象，我们只需要安全地解开它，然后把它写到我们之前做的文件名中。这要使用 `write(to:)` 方法来完成，该方法需要一个文件名作为参数。

所以：用户可以选择一个图片，我们就会把它保存到磁盘上。但这仍然没有任何作用--你不会在应用中看到这张图片，因为我们除了把它写入磁盘之外，并没有对它做任何事情。为了解决这个问题，我们需要创建一个自定义类来保存自定义数据......