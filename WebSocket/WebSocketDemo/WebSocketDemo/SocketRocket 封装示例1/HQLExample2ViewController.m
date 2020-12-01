//
//  HQLExample2ViewController.m
//  WebSocketDemo
//
//  Created by Qilin Hu on 2020/12/1.
//

#import "HQLExample2ViewController.h"
#import "WebSocketManager.h"

@interface HQLExample2ViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) WebSocketManager *socketManger;
@end

@implementation HQLExample2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.socketManger = [WebSocketManager share];
    
    self.view.backgroundColor = [UIColor blueColor];
    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(50, 100, 100,40)];
    self.textField.borderStyle=UITextBorderStyleRoundedRect;
    self.textField.layer.masksToBounds=YES;
    self.textField.layer.cornerRadius=12;
    [self.view addSubview:self.textField];
    
    UIButton * button=[[UIButton alloc]initWithFrame:CGRectMake(50, 150, 100, 40)];
    [button setTitle:@"发送" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    button.layer.masksToBounds = YES;
    button.layer.cornerRadius = 10;
    [self.view addSubview:button];
    [button addTarget:self action:@selector(sendMsg) forControlEvents:UIControlEventTouchUpInside];

    UIButton * button1=[[UIButton alloc]initWithFrame:CGRectMake(50, 200, 100, 40)];
    [button1 setTitle:@"连接"forState:UIControlStateNormal];
    [button1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button1.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    button1.layer.masksToBounds = YES;
    button1.layer.cornerRadius = 10;
    [self.view addSubview:button1];
    [button1 addTarget:self action:@selector(startSocket) forControlEvents:UIControlEventTouchUpInside];

    UIButton * button2=[[UIButton alloc]initWithFrame:CGRectMake(50, 250, 100, 40)];
    [button2 setTitle:@"断开" forState:UIControlStateNormal];
    [button2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button2.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    button2.layer.masksToBounds = YES;
    button2.layer.cornerRadius = 10;
    [self.view addSubview:button2];
    [button2 addTarget:self action:@selector(stopSocket) forControlEvents:UIControlEventTouchUpInside];

    UIButton * button3=[[UIButton alloc]initWithFrame:CGRectMake(50, 300, 100, 40)];
    [button3 setTitle:@"sendPing" forState:UIControlStateNormal];
    [button3 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    button3.backgroundColor=[UIColor colorWithRed:220/255.0 green:220/255.0 blue:220/255.0 alpha:1.0];
    button3.layer.masksToBounds = YES;
    button3.layer.cornerRadius = 10;
    [self.view addSubview:button3];
    [button3 addTarget:self action:@selector(sendPing) forControlEvents:UIControlEventTouchUpInside];
}

- (void)sendMsg {
    if (self.textField.text.length == 0) { return; }
    
    [self.socketManger sendMessage:self.textField.text];
}

- (void)startSocket {
    [self.socketManger open];
}

- (void)stopSocket {
    [self.socketManger close];
}

- (void)sendPing {
    [self.socketManger ping];
}

@end
