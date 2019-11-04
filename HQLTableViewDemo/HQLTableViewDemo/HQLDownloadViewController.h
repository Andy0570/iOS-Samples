//
//  HQLDownloadViewController.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2019/9/11.
//  Copyright © 2019 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 参考：
 <https://github.com/shinobicontrols/iOS7-day-by-day/blob/master/01-nsurlsession/01-nsurlsession.md>
 <http://www.voidcn.com/article/p-vqslkieb-ben.html>
 */
@interface HQLDownloadViewController : UIViewController

- (IBAction)startCancellable:(id)sender;  // 可撤销任务
- (IBAction)startResumable:(id)sender;    // 可恢复任务
- (IBAction)startBackground:(id)sender;   // 后台任务

- (IBAction)cancelCancellable:(id)sender; // 取消当前任务

@end

NS_ASSUME_NONNULL_END
