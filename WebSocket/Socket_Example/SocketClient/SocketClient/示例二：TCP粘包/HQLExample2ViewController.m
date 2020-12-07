//
//  HQLExample2ViewController.m
//  SocketClient
//
//  Created by Qilin Hu on 2020/12/4.
//

#import "HQLExample2ViewController.h"
#import "HQLSocketManager.h"

@interface HQLExample2ViewController ()

@end

@implementation HQLExample2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)sendMsg:(id)sender {
    [[HQLSocketManager share] sendMsg];
}

- (IBAction)connect:(id)sender {
    [[HQLSocketManager share] connect];
}

- (IBAction)disconnect:(id)sender {
    [[HQLSocketManager share] disConnect];
}


@end
