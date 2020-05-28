//
//  MasterViewController.h
//  MathMonsters
//
//  Created by Qilin Hu on 2020/5/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Monster;

NS_ASSUME_NONNULL_BEGIN

// 通过 Delegate 的方式在 Master-Detail 之间传递 Monster 数据
@protocol MonsterSelectionDelegate <NSObject>

@required
- (void)monsterSelected:(Monster *)monster;

@end

@interface MasterViewController : UITableViewController

// 数据源
@property (nonatomic, copy) NSArray<Monster *> *monsters;
@property (nonatomic, weak) id<MonsterSelectionDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
