//
//  DetailViewController.h
//  MathMonsters
//
//  Created by Qilin Hu on 2020/5/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterViewController.h"

@class Monster;

NS_ASSUME_NONNULL_BEGIN

@interface DetailViewController : UIViewController <MonsterSelectionDelegate>

@property (nonatomic, strong) Monster *monster;

@end

NS_ASSUME_NONNULL_END
