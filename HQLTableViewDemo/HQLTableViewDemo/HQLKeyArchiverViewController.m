//
//  HQLKeyArchiverViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/30.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLKeyArchiverViewController.h"
#import "Person.h"

@interface HQLKeyArchiverViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameArchiver;
@property (weak, nonatomic) IBOutlet UITextField *ageArchiver;
@property (weak, nonatomic) IBOutlet UITextField *nameUnarchiver;
@property (weak, nonatomic) IBOutlet UITextField *ageUnarchiver;

@property (strong, nonatomic) Person *person;

@property (strong, nonatomic) NSString *documentsPath;

@end

@implementation HQLKeyArchiverViewController

#pragma mark - Lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameArchiver.delegate = self;
    self.ageArchiver.delegate  = self;
    self.nameUnarchiver.delegate = self;
    self.ageUnarchiver.delegate = self;
    
    self.person = [[Person alloc] init];
    
    // 当应用进入系统后台时，执行归档操作！
    [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidEnterBackgroundNotification object:nil queue:nil usingBlock:^(NSNotification * _Nonnull note) {
        [self archiver:nil];
        NSLog(@"archiver");
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidEnterBackgroundNotification object:nil];
}

#pragma mark - Custom Accessors

- (NSString *)documentsPath {
    if (!_documentsPath) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        if (paths.count > 0) {
            _documentsPath = paths.firstObject;
            
            // 如果目录不存在，则创建该目录
            if (![[NSFileManager defaultManager] fileExistsAtPath:_documentsPath]) {
                NSError *error;
                if (![[NSFileManager defaultManager] createDirectoryAtPath:_documentsPath withIntermediateDirectories:YES attributes:nil error:&error]) {
                    NSLog(@"Failed to create directory. error: %@",error);
                }
            }
        }
    }
    return _documentsPath;
}

#pragma mark - IBActions

- (IBAction)archiver:(id)sender {
//    // A 使用 archiveRootObject: toFile: 方法归档
//    // 1.修改当前目录为 self.documentsPath
//    NSFileManager *sharedFM = [NSFileManager defaultManager];
//    [sharedFM changeCurrentDirectoryPath:self.documentsPath];
//
//    // 2.归档
//    if (![NSKeyedArchiver archiveRootObject:self.nameArchiver.text toFile:@"nameArchiver"]) {
//        NSLog(@"Failed to archive nameArchiver");
//    }
//    if (![NSKeyedArchiver archiveRootObject:self.ageArchiver.text toFile:@"ageArchiver"]) {
//        NSLog(@"Failed to archive ageArchiver");
//    }
    
    // B 使用initForWritingWithData: 归档。
    // 1.把当前文本框内文本传送给person。
    [self.person setName:self.nameArchiver.text age:[self.ageArchiver.text integerValue]];
    
    // 2.使用 initFoWritingWithData: 方法归档内容至 mutableData。
    NSMutableData *mutableData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    [archiver encodeObject:self.person forKey:@"person"];
    [archiver finishEncoding];
    
    // 3.把归档写入 Library/Application Support/Data 目录。
    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:@"Data"];
    if (![mutableData writeToFile:filePath atomically:YES]) {
        NSLog(@"Failed to write file to filePath");
    }
}

- (IBAction)unarchiver:(id)sender {
//    // A 使用 unarchiveObjectWithFile: 读取归档
//    // 1.获取归档路径
//    NSString *nameArchiver = [self.documentsPath stringByAppendingPathComponent:@"nameArchiver"];
//    NSString *ageArchiver = [self.documentsPath stringByAppendingPathComponent:@"ageArchiver"];
//
//    // 2.读取归档，并将其显示在对应文本框。
//    self.nameUnarchiver.text = [NSKeyedUnarchiver unarchiveObjectWithFile:nameArchiver];
//    self.ageUnarchiver.text = [NSKeyedUnarchiver unarchiveObjectWithFile:ageArchiver];
    
    // B 使用initForReadingWithData: 读取归档。
    // 1.从Library/Application Support/Data目录获取归档文件。
    NSString *filePath = [self.documentsPath stringByAppendingPathComponent:@"Data"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    // 2.使用initForReadingWithData: 读取归档。
    NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    self.person = [unarchiver decodeObjectForKey:@"person"];
    [unarchiver finishDecoding];
    
    // 3.把读取到的内容显示到对应文本框。
    self.nameUnarchiver.text = self.person.name;
    self.ageUnarchiver.text = [@(self.person.age) stringValue];
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
