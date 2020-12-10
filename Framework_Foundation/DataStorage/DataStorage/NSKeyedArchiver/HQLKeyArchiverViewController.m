//
//  HQLKeyArchiverViewController.m
//  DataStorage
//
//  Created by Qilin Hu on 2020/12/10.
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.nameArchiver.delegate = self;
    self.ageArchiver.delegate = self;
    self.nameUnarchiver.delegate = self;
    self.ageUnarchiver.delegate = self;
    
    self.person = [[Person alloc] init];
    
    
}

#pragma mark - Custom Accessors

// 创建目录 /Library/Application Support/UserData
- (NSString *)documentsPath {
    if (!_documentsPath) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        _documentsPath = [documentsPath stringByAppendingPathComponent:@"UserData"];
        
        if (![fileManager fileExistsAtPath:_documentsPath]) {
            NSError *error;
            BOOL isCreateDocumentpathSucceed = [fileManager createDirectoryAtPath:_documentsPath withIntermediateDirectories:YES attributes:nil error:&error];
            NSAssert(isCreateDocumentpathSucceed, @"Failed to create directory.");
        }
    }
    
    return _documentsPath;
}

- (IBAction)archiveAction:(id)sender {
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
    
    // B 使用 initForWritingWithData: 方法归档。
    // 1.把当前文本框内文本传送给person。
    [self.person setName:self.nameArchiver.text age:[self.ageArchiver.text integerValue]];
    
    // 2.使用 initFoWritingWithData: 方法归档内容至 mutableData。
    NSMutableData *mutableData = [NSMutableData data];
    NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:mutableData];
    [archiver encodeObject:self.person forKey:@"person"];
    [archiver finishEncoding];
    
    // 3.把归档写入 /Documents/UserData/PersonInfo 目录。
    NSString *path = [self.documentsPath stringByAppendingPathComponent:@"PersonInfo"];
    // /var/mobile/Containers/Data/Application/FBFF587D-DF09-4FC7-8F97-F80E15714B58/Documents/UserData/PersonInfo
    NSLog(@"path=%@",path);
    if (![mutableData writeToFile:path atomically:YES]) {
        NSAssert(NO, @"Failed to write file to filePath.");
    }
}

- (IBAction)unarchiveAction:(id)sender {
    //    // A 使用 unarchiveObjectWithFile: 读取归档
    //    // 1.获取归档路径
    //    NSString *nameArchiver = [self.documentsPath stringByAppendingPathComponent:@"nameArchiver"];
    //    NSString *ageArchiver = [self.documentsPath stringByAppendingPathComponent:@"ageArchiver"];
    //
    //    // 2.读取归档，并将其显示在对应文本框。
    //    self.nameUnarchiver.text = [NSKeyedUnarchiver unarchiveObjectWithFile:nameArchiver];
    //    self.ageUnarchiver.text = [NSKeyedUnarchiver unarchiveObjectWithFile:ageArchiver];
        
        // B 使用initForReadingWithData: 读取归档。
        // 1.从 Library/Application Support/UserData 目录获取归档文件。
        NSString *path = [self.documentsPath stringByAppendingPathComponent:@"PersonInfo"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        
        // 2.使用initForReadingWithData: 读取归档。
        NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        self.person = [unarchiver decodeObjectForKey:@"person"];
        [unarchiver finishDecoding];
        
        // 3.把读取到的内容显示到对应文本框。
        self.nameUnarchiver.text = self.person.name;
        self.ageUnarchiver.text = [@(self.person.age) stringValue];
}

#pragma mark - UITextFieldDelegate

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
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
