//
//  CommentTableViewController.h
//  WKWebViewDemo
//
//  Created by Qilin Hu on 2020/6/15.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^CommentTableViewDidScrollBlock)(CGPoint contentOffset);

@interface CommentTableViewController : UITableViewController

@property (nonatomic, copy) CommentTableViewDidScrollBlock tableDidScrollBlock;

@end

NS_ASSUME_NONNULL_END
