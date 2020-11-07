//
//  HQLCommentsView.h
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/15.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class HQLComment;

@interface HQLCommentsView : UIView

@property (nonatomic, copy) NSArray<HQLComment *> *comments;

@end

NS_ASSUME_NONNULL_END
