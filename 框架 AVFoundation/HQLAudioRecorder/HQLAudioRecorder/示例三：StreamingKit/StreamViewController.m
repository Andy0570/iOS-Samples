//
//  StreamViewController.m
//  HQLAudioRecorder
//
//  Created by Qilin Hu on 2021/2/23.
//

#import "StreamViewController.h"
#import <StreamingKit/STKAudioPlayer.h>

@interface StreamViewController ()
@property (weak, nonatomic) IBOutlet UIButton *playButton;
@end

@implementation StreamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

// 通过 StreamingKit 框架播放网络音频文件
- (IBAction)playButtonTapped:(id)sender {
    STKAudioPlayer *audioPlayer = [[STKAudioPlayer alloc] init];
    [audioPlayer play:@"https://m3.8js.net:99/1830/121204301235515.mp3"];
}


@end
