//
//  TLDemoTableViewController.h
//  TabBarTest
//
//  Created by 李伯坤 on 2017/9/13.
//  Copyright © 2017年 李伯坤. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TLTabBarControllerProtocol.h"

@interface TLDemoTableViewController : UIViewController <TLTabBarControllerProtocol>

@property (nonatomic, assign) NSInteger tag;

@end
