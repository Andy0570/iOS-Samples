//
//  HQLKeyArchiver2ViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/10/31.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import "HQLKeyArchiver2ViewController.h"

// Model
#import "Persion2.h"

@interface HQLKeyArchiver2ViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *myswitch;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (strong, nonatomic) NSString *documentsPath;
@property (nonatomic, strong) Persion2 *person;

@end

@implementation HQLKeyArchiver2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.person = [[Persion2 alloc] init];
    [self.person setNum:10
               latitude:15.9
             longtitude:23.3
             loginState:NO
             identifier:@"abcedfg"
                  title:@"myNameIsZhangSan"];
    
}

#pragma mark - IBActions

- (IBAction)valueChanged:(id)sender {
    self.person.isLogin = self.myswitch.isOn;
}


- (IBAction)archiverButtonDidClicked:(id)sender {
    NSString *string = [NSString stringWithFormat:@"待归档用户：\n%@",self.person];
    self.textView.text = string;
    
    [NSKeyedArchiver archiveRootObject:self.person toFile:self.documentsPath];
}

- (IBAction)unarchiverButtonDidClicked:(id)sender {
    self.person = [NSKeyedUnarchiver unarchiveObjectWithFile:self.documentsPath];
    
    NSString *string = [NSString stringWithFormat:@"已解档用户：\n%@",self.person];
    self.textView.text = string;
}



#pragma mark - Private

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
    return [_documentsPath stringByAppendingPathComponent:@"person2"];
}

@end
