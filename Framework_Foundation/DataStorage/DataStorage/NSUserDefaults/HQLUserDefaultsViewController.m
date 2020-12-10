//
//  HQLUserDefaultsViewController.m
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/10.
//

#import "HQLUserDefaultsViewController.h"

static NSString * const selectedSegmentKey = @"selectedSegmentKey";
static NSString * const spinnerAnimatingKey = @"spinnerAnimatingKey";
static NSString * const switchEnabledKey = @"SwitchEnabledKey";
static NSString * const progressBarKey = @"progressBarKey";
static NSString * const textFieldKey = @"textFieldKey";
static NSString * const slider1Key = @"slider1Key";
static NSString * const slider2Key = @"slider2Key";
static NSString * const slider3Key = @"slider3Key";
static NSString * const sliderValueKey = @"sliderValueKey";
static NSString * const textViewComponent = @"textViewComponent";
static NSString * const controlStateComponent = @"controlStateComponent";
static NSString * const archivedDataComponent = @"archivedDataComponent";

// 声明遵守 UITextViewDelegate、UITextFieldDelegate 协议
@interface HQLUserDefaultsViewController () <UITextViewDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UISegmentedControl *segments;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIButton *spinningButton;
@property (strong, nonatomic) IBOutlet UISwitch *cSwitch;
@property (strong, nonatomic) IBOutlet UITextField *textField;
@property (strong, nonatomic) IBOutlet UIProgressView *progressBar;
@property (strong, nonatomic) IBOutlet UISlider *slider1;
@property (strong, nonatomic) IBOutlet UISlider *slider2;
@property (strong, nonatomic) IBOutlet UISlider *slider3;
@property (strong, nonatomic) IBOutlet UITextView *textView;

// 声明两个可变词典类型属性，用来保存数据。
@property (strong, nonatomic) NSMutableDictionary *controlStateDictionary;
@property (strong, nonatomic) NSMutableDictionary *sliderValueDictionary;

@end

@implementation HQLUserDefaultsViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 设置代理
    self.textField.delegate = self;
    self.textView.delegate = self;
    
    self.textView.backgroundColor = [UIColor lightGrayColor];
    self.textField.placeholder = @"Text Field";
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // 读取偏好设置中segment设置。
    NSInteger selectedSegmentIndex = [[NSUserDefaults standardUserDefaults] integerForKey:selectedSegmentKey];
    self.segments.selectedSegmentIndex = selectedSegmentIndex;
    
    // 恢复偏好设置中spinner状态设置。
    if ([[NSUserDefaults standardUserDefaults] boolForKey:spinnerAnimatingKey] == true) {
        [self.spinner startAnimating];
        [self.spinningButton setTitle:@"Stop Animating" forState:UIControlStateNormal];
    } else {
        [self.spinner stopAnimating];
        [self.spinningButton setTitle:@"Start Animating" forState:UIControlStateNormal];
    }
    
    // 从 plist 恢复 controlState 词典。
    NSURL *controlStateURL = [self urlForDocumentDirectoryWithPathComponent:controlStateComponent];
    if (controlStateURL) {
        // 如果url存在，读取保存的数据。
        self.controlStateDictionary = [NSMutableDictionary dictionaryWithContentsOfURL:controlStateURL];
    }
    if ([[self.controlStateDictionary allKeys] count] != 0) {
        // 如果词典不为空，恢复数据。
        [self.cSwitch setOn:[[self.controlStateDictionary objectForKey:switchEnabledKey] boolValue]];
        self.progressBar.progress = [[self.controlStateDictionary objectForKey:progressBarKey] floatValue];
        self.textField.text = [self.controlStateDictionary objectForKey:textFieldKey];
    }
    
    // 读取归档，恢复sliderValue词典内容。
    NSURL *dataURL = [self urlForDocumentDirectoryWithPathComponent:archivedDataComponent];
    if (dataURL) {
        // 如果url存在，读取保存的数据。
        NSMutableData *data = [[NSMutableData alloc] initWithContentsOfURL:dataURL];
        NSError *error;
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingFromData:data error:&error];
        if (error) {
            NSLog(@"解档失败:%@",error);
            return;
        }
        
        self.sliderValueDictionary = [unarchiver decodeObjectForKey:sliderValueKey];
    }
    
    if (self.sliderValueDictionary.allKeys.count != 0) {
        // 如果词典不为空，恢复数据。
        self.slider1.value = [[self.sliderValueDictionary objectForKey:slider1Key] floatValue];
        self.slider2.value = [[self.sliderValueDictionary objectForKey:slider2Key] floatValue];
        self.slider3.value = [[self.sliderValueDictionary objectForKey:slider3Key] floatValue];
    }
    
    // 读取文本文件，恢复textView内容。
    NSURL *textViewContentsURL = [self urlForDocumentDirectoryWithPathComponent:textViewComponent];
    if (textViewContentsURL) {
        NSString *textViewContents = [NSString stringWithContentsOfURL:textViewContentsURL encoding:NSUTF8StringEncoding error:nil];
        self.textView.text = textViewContents;
    }
}

#pragma mark - Custom Accessors

- (NSMutableDictionary *)controlStateDictionary {
    if (!_controlStateDictionary) {
        _controlStateDictionary = [NSMutableDictionary dictionary];
    }
    return _controlStateDictionary;
}

- (NSMutableDictionary *)sliderValueDictionary {
    if (!_sliderValueDictionary) {
        _sliderValueDictionary = [NSMutableDictionary dictionary];
    }
    return _sliderValueDictionary;
}

#pragma mark - IBActions

// segmented control部分
- (IBAction)controlValueChanged:(id)sender {
    if (sender == self.segments) {
        // !!!: 使用偏好设置保存 segments 当前状态
        NSInteger selectedSegment = ((UISegmentedControl *)sender).selectedSegmentIndex;
        [[NSUserDefaults standardUserDefaults] setInteger:selectedSegment forKey:selectedSegmentKey];
        [[NSUserDefaults standardUserDefaults] synchronize];

    } else if (sender == self.cSwitch) {
        [self.controlStateDictionary setValue:[NSNumber numberWithBool:self.cSwitch.isOn] forKey:switchEnabledKey];
    } else if (sender == self.textField) {
        [self.controlStateDictionary setValue:self.textField.text forKey:textFieldKey];
    } else if (sender == self.slider1) {
        [self.sliderValueDictionary setValue:[NSNumber numberWithFloat:self.slider1.value] forKey:slider1Key];
        
        // 根据 slider1 的值更新 progress 进度条
        [self.progressBar setProgress:self.slider1.value];
        [self.controlStateDictionary setValue:[NSNumber numberWithFloat:self.progressBar.progress] forKey:progressBarKey];
    } else if (sender == self.slider2) {
        [self.sliderValueDictionary setValue:[NSNumber numberWithFloat:self.slider2.value] forKey:slider2Key];
    } else if (sender == self.slider3) {
        [self.sliderValueDictionary setValue:[NSNumber numberWithFloat:self.slider3.value] forKey:slider3Key];
    }
    
    // !!!: 使用 plist 保存 controlState 词典
    NSURL *controlStateURL = [self urlForDocumentDirectoryWithPathComponent:controlStateComponent];
    // NSDictionary -> 保存到文件
    [self.controlStateDictionary writeToURL:controlStateURL atomically:YES];
    
    // !!!: 使用归档保存 sliderValue 词典
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [archiver encodeObject:self.sliderValueDictionary forKey:sliderValueKey];
    [archiver finishEncoding];
    
    // !!!: 保存文本文件
    NSURL *dataURL = [self urlForDocumentDirectoryWithPathComponent:archivedDataComponent];
    // NSData -> 保存到文件
    if (![data writeToURL:dataURL atomically:YES]) {
        NSLog(@"Couldn't write to dataURL");
    }
}


// spinner部分
- (IBAction)toggleSpinner:(id)sender {
    // 控制活动指示器的旋转和暂停
    if (self.spinner.isAnimating) {
        [self.spinner stopAnimating];
        [self.spinningButton setTitle:@"开始动画" forState:UIControlStateNormal];
    } else {
        [self.spinner startAnimating];
        [self.spinningButton setTitle:@"结束动画" forState:UIControlStateNormal];
    }
    
    // 使用偏好设置保存「活动指示器」的当前状态
    [[NSUserDefaults standardUserDefaults] setBool:[self.spinner isAnimating] forKey:spinnerAnimatingKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - Private

// 拼接并返回 plist 文件要保存的路径
- (NSURL *)urlForDocumentDirectoryWithPathComponent:(NSString *)pathComponent {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Documents 目录：NSDocumentDirectory
    NSURL *documentsURL = [fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask].firstObject;
    NSURL *customURL = [documentsURL URLByAppendingPathComponent:pathComponent];
    if (customURL) { return customURL; }
    
    NSError *error = nil;
    BOOL isCreateDocumentsUrlSucceed = [fileManager createDirectoryAtURL:customURL withIntermediateDirectories:YES attributes:nil error:&error];
    NSAssert(isCreateDocumentsUrlSucceed, @"Failed to create directory.");
    return customURL;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidEndEditing:(UITextView *)textView {
    // 编辑完成后，保存文本文件。
    NSString *textViewContents = textView.text;
    NSURL *fileURL = [self urlForDocumentDirectoryWithPathComponent:textViewComponent];
    
    // !!!: 保存文本文件
    // NSString -> 保存到文件
    [textViewContents writeToURL:fileURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
    }
    return true;
}

// 隐藏键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isFirstResponder]) {
        [textField resignFirstResponder];
    }
    return YES;
}

@end
