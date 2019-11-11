//
//  HQLDetailViewControl.m
//  HQLHomepwner
//
//  Created by ToninTech on 16/9/9.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLDetailViewControl.h"
#import "Item.h"
#import "HQLItemStore.h"
#import "HQLImageStore.h"

// UIImagePickerController 是 UINavigationController 的子类，
// 所以 UIImagePickerController 的委托也要遵守 UINavigationControllerDelegate 协议。
@interface HQLDetailViewControl () <UINavigationControllerDelegate,UIImagePickerControllerDelegate, UIPopoverPresentationControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *serialNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *SerialField;
@property (weak, nonatomic) IBOutlet UITextField *ValueField;
@property (weak, nonatomic) IBOutlet UILabel     *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar   *toolbar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cameraButton;
@property (strong, nonatomic) UIPopoverPresentationController *imagePickerPopover;
@end

@implementation HQLDetailViewControl

#pragma mark - Lifecycle

- (instancetype)initForNewItem:(BOOL)isNew {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        
        // 创建恢复标识和恢复类
        self.restorationIdentifier = NSStringFromClass([self class]);
        self.restorationClass = [self class];
        
        if (isNew) {
            // 导航栏完成按钮
            UIBarButtonItem *doneItem = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                                 target:self
                                                 action:@selector(save:)];
            self.navigationItem.rightBarButtonItem = doneItem;
            // 导航栏取消按钮
            UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc]
                            initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                                 target:self
                                                 action:@selector(cancel:)];
            self.navigationItem.leftBarButtonItem = cancelItem;
        }
        
        // 注册观察者:UIContentSizeCategoryDidChangeNotification
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
        [defaultCenter addObserver:self
                          selector:@selector(updateFonts:)
                              name:UIContentSizeCategoryDidChangeNotification
                            object:nil];
    }
    return self;
}

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    @throw [NSException exceptionWithName:@"Wrong initializer" reason:@"Use initForNewItem" userInfo:nil];
    return nil;
}

/**
 *  通常，如果是创建整个视图层次结构及所有视图约束，就覆盖 loadView 方法；
 *  如果只是向通过 NIB 文件创建的视图层次结构中添加一个视图或约束，就覆盖 viewDidLoad 方法。
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // ------------------------
    // 在代码中使用自动布局:VFL 视觉化格式语言
    // 创建 UIImageView 对象
    UIImageView *iv = [[UIImageView alloc] initWithImage:nil];
    // 设置 UIImageView 对象的内容缩放模式
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // 在 Apple 引入自动布局系统之前，iOS 一直使用自动缩放掩码（autoresizing masks）缩放视图，以适配不同大小的屏幕。
    // 默认情况下，视图会将自动缩放掩码转换为对应的约束，这类约束经常会与手动添加的约束产生冲突。
    // 告诉自动布局系统不要将自动缩放掩码转换为约束
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    // 将 UIImageView 对象添加到 view 上
    [self.view addSubview:iv];
    // 将 UIImageView 对象赋给 imageView 属性
    self.imageView = iv;
    
    
    // 初始 UITextField 的内容放大优先级是 250，而 imageView 的内容放大优先级是 251
    // 如果用户选择了一张小尺寸图片，自动布局系统会增加 UITextField 对象的高度，使得高度超出 UITextField 对象的固有内容大小
    // 将 imageView 垂直方向的优先级设置为比其他视图低的数值
    // 设置垂直方向上的【内容放大优先级】
    [self.imageView setContentHuggingPriority:200
                                      forAxis:UILayoutConstraintAxisVertical];
    // 设置垂直方向上的【内容缩小优先级】
    [self.imageView setContentCompressionResistancePriority:700
                                                    forAxis:UILayoutConstraintAxisVertical];
    // 创建视图名称字典，将名称与视图对象关联起来
    NSDictionary *nameMap = @{
                              @"imageView" :self.imageView,
                              @"dateLabel" :self.dateLabel,
                              @"toolbar"   :self.toolbar
                              };
    // imageView 的左边和右边与父视图的距离都是0点
    NSArray *horizontalConstraints =
        [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                options:0
                                                metrics:nil
                                                  views:nameMap];
    // imageView 的顶边与 dateLabel 的距离是8点，底边与 toolbar 的距离也是8点
    NSArray *verticalConstrants = [NSLayoutConstraint
            constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                options:0
                                metrics:nil
                                  views:nameMap];
    
    /**
     *  如何判断约束应该添加到哪个视图中？
     *  ※ 如果约束同时对【多个父视图相同的视图】起作用，那么约束应该添加到它们的父视图中。
     *  ※ 如果约束只对【某个视图自身】起作用，那么约束应该添加到该视图中。
     *  ※ 如果约束同时对【多个父视图不同的视图】起作用，但是这些视图在层次结构中有共同的祖先视图，那么约束应该添加到它们最近一级的祖先视图中。
     *  ※ 如果约束同时对【某个视图及其父视图】起作用，那么约束应该添加到它们的父视图中。
     */
    // 将两个 NSLayoutConstraint 对象数组添加到 HQLDetailViewControl 的 view 中
    [self.view addConstraints:horizontalConstraints];
    [self.view addConstraints:verticalConstrants];
}

// 视图即将显示时调用
- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    Item *item            = self.item;
    self.nameField.text   = item.itemName;
    self.SerialField.text = item.serialNumber;
    self.ValueField.text  = [NSString stringWithFormat:@"%d",item.valueInDollars];
    // 创建NSDateFormatter对象，用于将NSDate对象转换成简单的日期字符串
    static NSDateFormatter *dateFormater = nil;
    // 初始化并设置日期格式
    if (!dateFormater) {
        dateFormater = [[NSDateFormatter alloc] init];
        dateFormater.dateStyle = NSDateFormatterMediumStyle;
        dateFormater.timeStyle = NSDateFormatterNoStyle;
    }
    // 将转换后得到的日期字符串设置为dateLabel的标题
    self.dateLabel.text = [dateFormater stringFromDate:item.dateCreated];
    
    // 根据itemKey，从 HQLImageStore 对象获取照片
    NSString *itemKey = self.item.itemKey;
    UIImage *imageToDisplay = [[HQLImageStore sharedStore] imageForKey:itemKey];
    // 将得到的照片赋给 UIImageView 对象
    self.imageView.image = imageToDisplay;
    
    // 添加自动转屏通知：iPhone 横屏状态下禁用拍照按钮
    [[NSNotificationCenter defaultCenter]
        addObserver:self
           selector:@selector(deviceOrientationDidChange:)
               name:UIDeviceOrientationDidChangeNotification
             object:nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [self updateFonts];
}

// 视图即将出栈时调用
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // 取消当前的第一响应对象
    [self.view endEditing:YES];
    // 将修改“保存”至Item对象
    Item *item          = self.item;
    item.itemName       = self.nameField.text;
    item.serialNumber   = self.SerialField.text;
    item.valueInDollars = [self.ValueField.text intValue];
    
    [[UIDevice currentDevice] endGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter]
        removeObserver:self
                  name:UIDeviceOrientationDidChangeNotification
                object:nil];
}

- (void)deviceOrientationDidChange:(NSNotification *)notification {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    [self prepareViewsForOrientation:orientation];
}

- (void)prepareViewsForOrientation:(UIInterfaceOrientation)orientation {
    // 如果是 iPad，则不执行任何操作
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        return;
    }
    
    // 判断设备是否处于横屏方向
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        self.imageView.hidden = YES;
        self.cameraButton.enabled = NO;
    } else {
        self.imageView.hidden = NO;
        self.cameraButton.enabled = YES;
    }
}

// Deprecated
//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//                                duration:(NSTimeInterval)duration {
//    [self prepareViewsForOrientation:toInterfaceOrientation];
//}

- (void)dealloc {
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter removeObserver:self];
}


#pragma mark - Custom Accessors

// 设置 HQLDetailViewControl 对象的item属性，设置相应的导航栏标题
- (void)setItem:(Item *) item {
    _item = item;
    // 不能在 init 方法中设置导航栏标题，因为那时 itme 属性还没有被赋值，是 nil
    // 在 viewDidLoad 方法中设置？
    self.navigationItem.title = _item.itemName;
}


#pragma mark - Private

// 为正文（UIFontTextStyleBody）的 UIFont 对象创建文本样式，再赋给所有的 UILabel 对象
- (void)updateFonts {
    UIFont *font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    self.dateLabel.font = font;
    self.nameField.font = font;
    self.SerialField.font = font;
    self.ValueField.font = font;
}

- (void)save:(id)sender {
    // UIViewController 对象的 presentingViewController 属性:
    // 当【某个 UIViewController 对象】以模态形式显示时，该属性会指向【~~显示该对象的那个 UIViewController 对象~~】(包含该对象的 UINavigationController 对象)
    // 再说确切一点：当应用以模态形式显示某个视图控制器时，负责显示该视图控制器的将是相关族系中的顶部视图控制器。
    // 所以 HQLDetailViewController 对象的视图会被放置在 UINavigationController 对象的视图上方，从而导致遮住 UINavigationBar 对象。
    // 所以下面一行代码的意思是 向 HQLItemsViewController 对象发送关闭模态视图消息
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}

- (void)cancel:(id)sender {
    // 如果用户按下了 Cancel 按钮，就从 HQLItemStore 对象移除新创建的 Item 对象
    [[HQLItemStore sharedStore] removeItem:self.item];
    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:self.dismissBlock];
}


#pragma mark - IBActions

- (IBAction)takePicture:(id)sender {
    // 创建 UIImagePickerController 对象
    // 需要为其1️⃣ 设置sourceType属性;2️⃣ 设置delegate属性
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    /* 1️⃣ 设置 sourceType:
     *
     *  UIImagePickerControllerSourceTypePhotoLibrary,拍摄一张新照片
     *  UIImagePickerControllerSourceTypeCamera,从相册中选取
     *  UIImagePickerControllerSourceTypeSavedPhotosAlbum，从最近拍摄的照片中选取
     */
    // 设置 sourceType 之前，先检查设备是否支持相机。
    // 如果设备支持相机，就使用拍照模式，否则让用户从照片库中选择照片
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 设置取景十字图层
        UIImageView *cameraOverlayView = [[UIImageView alloc]
                                          initWithImage:[UIImage imageNamed:@"CrossHair"]];
//        cameraOverlayView.alpha = 0.50f;
        cameraOverlayView.center = self.view.center;
        imagePicker.cameraOverlayView = cameraOverlayView;
        
    }else {
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    // 2️⃣ 设置 delegate
    imagePicker.delegate = self;
    
    // 以模态的形式显示 UIImagePickerController  对象
//    [self presentViewController:imagePicker animated:YES completion:nil];
    
    // 显示 UIImagePickerController 对象
    // 创建 UIPopoverPresentationController 对象前先检查当前设备是否是 iPad
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        // 如果是 iPad 设备就创建 UIPopoverPresentationController 对象用于显示 UIImagePickerController 对象
        imagePicker.modalPresentationStyle = UIModalPresentationPopover;
        
        
        self.imagePickerPopover = [imagePicker popoverPresentationController];
        self.imagePickerPopover.delegate = self;
        self.imagePickerPopover.permittedArrowDirections = UIPopoverArrowDirectionAny;
        self.imagePickerPopover.barButtonItem = self.cameraButton;
        
        [self presentViewController:imagePicker animated:YES completion:nil];
    } else{
        // 以模态的形式显示 UIImagePickerController  对象
        [self presentViewController:imagePicker animated:YES completion:nil];
    }
    
    
}

// 将 UIView 顶层视图改为 UIControl
// 点击空白部分取消第一响应者状态
- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark - UIImagePickerControllerDelegate

// 将选择的照片放入之前创建的UIImageView对象中，然后关闭UIImagePickerController对象
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(nonnull NSDictionary<NSString *,id> *)info{
    // 通过info字典获取选择的照片
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    [self.item setThumbnailFromImage:image];
    // 以itemKey为键，将照片存入 HQLImageStore 对象
    [[HQLImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    // 将照片放入UIImageView对象
    self.imageView.image = image;
    // 关闭 UIImagePickerController 对象
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // 判断 UIPopoverPresentationController 对象是否存在
    if (self.imagePickerPopover) {
        // 关闭 UIPopoverPresentationController 对象
        [self.imagePickerPopover dismissalTransitionDidEnd:YES];
        self.imagePickerPopover = nil;
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    NSLog(@"用户取消了选择！");
    // 关闭 UIImagePickerController 对象
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

// 键盘的"return"键被按下后，关闭键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma mark - UIPopoverPresentationControllerDelegate
- (void)popoverPresentationControllerDidDismissPopover:(UIPopoverPresentationController *)popoverPresentationController {
    NSLog(@"User Dismissed popover");
    self.imagePickerPopover = nil;
}


#pragma mark - UIViewControllerRestoration

+ (nullable UIViewController *) viewControllerWithRestorationIdentifierPath:(NSArray *)identifierComponents coder:(NSCoder *)coder {
    BOOL isNew = NO;
    // 通过恢复标识路径恢复相应的视图控制器
    // 2: UINavigationController/HQLDetailViewController
    // 3: UINavigationController/UINavigationController/HQLDetailViewController
    if ([identifierComponents count] == 3) {
        isNew = YES;
    }
    return [[self alloc] initForNewItem:isNew];
}

// 编码当前 Item 对象的 itemKey 属性
- (void) encodeRestorableStateWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.item.itemKey forKey:@"item.itemKey"];
    // 保存 UITextField 对象中的文本
    self.item.itemName = self.nameField.text;
    self.item.serialNumber = self.serialNumberLabel.text;
    self.item.valueInDollars = [self.ValueField.text intValue];
    // 保存修改
    [[HQLItemStore sharedStore] saveChanges];
    
    [super encodeRestorableStateWithCoder:coder];
}

// 解码
- (void) decodeRestorableStateWithCoder:(NSCoder *)coder {
    NSString *itemKey = [coder decodeObjectForKey:@"item.itemKey"];
    for (Item *item in [[HQLItemStore sharedStore] allItems]) {
        if ([itemKey isEqualToString:item.itemKey]) {
            self.item = item;
            break;
        }
    }
    [super decodeRestorableStateWithCoder:coder];
    
}

@end
