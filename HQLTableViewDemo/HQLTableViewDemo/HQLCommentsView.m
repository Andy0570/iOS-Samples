//
//  HQLCommentsView.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/15.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLCommentsView.h"

// Framework
#import <YYKit.h>
#import <Masonry.h>
#import <JKCategories.h>
#import <UITableView+FDTemplateLayoutCell.h>

// View
#import "HQLCommentCell.h"

// Model
#import "HQLComment.h"

static NSString * const cellReuseIdentifier = @"HQLCommentCell";

@interface HQLCommentsView () <UITableViewDataSource, UITableViewDelegate, HQLCommentCellDelegate>
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation HQLCommentsView

#pragma mark - Initialize

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.tableView];
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];
    }
    return self;
}

#pragma mark - Custom Accessors

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        // 系统自适应高度
//        _tableView.estimatedRowHeight = 32.0f;
//        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:HQLCommentCell.class forCellReuseIdentifier:cellReuseIdentifier];
    }
    return _tableView;
}

- (void)setComments:(NSArray<HQLComment *> *)comments {
    _comments = comments;
    
    [self.tableView reloadData];
}

#pragma mark - <UITableViewDataSource>

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.comments.count;
    
//    if (self.comments.count < 3) {
//        return self.comments.count;
//    } else {
//        return 4;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    HQLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    HQLComment *currentComment = (HQLComment *)[self.comments objectAtIndex:indexPath.row];
    cell.comment = currentComment;
    cell.delegate = self;
    return cell;
}

#pragma mark - <UITableViewDelegate>

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:cellReuseIdentifier configuration:^(HQLCommentCell *cell) {
        HQLComment *currentComment = (HQLComment *)[self.comments objectAtIndex:indexPath.row];
        cell.comment = currentComment;
    }];
}

#pragma mark - <HQLCommentCellDelegate>

/// 点击评论中的用户昵称
- (void)commentCellDidTappedUser:(HQLUser *)user {
    
}

@end
