//
//  HQLComment1TableViewController.m
//  HQLTableViewDemo
//
//  Created by Qilin Hu on 2020/10/13.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "HQLComment1TableViewController.h"

// Framework
#import <Chameleon.h>
#import <JKCategories.h>

// Controller
#import "HQLUserCenterViewController.h"

// View
#import "HQLTopicHeaderView.h"
#import "HQLTopicFooterView.h"
#import "HQLCommentCell.h"

// Model
#import "HQLUser.h"
#import "HQLComment.h"
#import "HQLTopic.h"

static NSString * const headerReuseIdentifier = @"HQLTopicHeaderView";
static NSString * const footerReuseIdentifier = @"HQLTopicFooterView";
static NSString * const cellReuseIdentifier = @"HQLCommentCell";

@interface HQLComment1TableViewController () <HQLCommentCellDelegate, HQLTopicHeaderViewDelegate>

// 模拟数据
@property (nonatomic, copy) NSArray<HQLTopic *> *topics;
@property (nonatomic, copy) NSArray<HQLUser *> *users;
@property (nonatomic, copy) NSString *textString;

@end

@implementation HQLComment1TableViewController

#pragma mark - Initialize

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupData];
    [self setupTableView];
}

- (void)setupData {
    
    self.textString = @"跑步也非常容易尝试。所需要的只是一双好鞋、一点时间和一个健康的动机。你可以随地实践起来。一些人喜欢沿着人群熙攘的街道跑步，另外一些人则喜欢在绿树成荫的公园里跑。一些人喜欢在夕阳西下的时候在海岸边慢跑，一些人则喜欢夜深人静的时候在冷清的摩天大楼之间奔跑。你可以独乐，亦可以与众同乐。你可以选择有挑战性的路线参加比赛，也可以知识追求个人的目标而毫不在意时间和长度，只是为了纯粹的快乐和好处而去跑步。";
    
    // 模拟用户数据
    HQLUser *user0 = [[HQLUser alloc] initWithUserId:@1000 nickname:@"Andy0570" avatarUrl:[NSURL URLWithString:@"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=1206211006,1884625258&fm=58"]];
    HQLUser *user1 = [[HQLUser alloc] initWithUserId:@1001 nickname:@"吴亦凡" avatarUrl:[NSURL URLWithString:@"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2625917416,3846475495&fm=58"]];
    HQLUser *user2 = [[HQLUser alloc] initWithUserId:@1002 nickname:@"杨洋" avatarUrl:[NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=413353707,3948222604&fm=58"]];
    HQLUser *user3 = [[HQLUser alloc] initWithUserId:@1003 nickname:@"陈伟霆" avatarUrl:[NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=3937650650,3185640398&fm=58"]];
    HQLUser *user4 = [[HQLUser alloc] initWithUserId:@1004 nickname:@"张艺兴" avatarUrl:[NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1691925636,1723246683&fm=58"]];
    HQLUser *user5 = [[HQLUser alloc] initWithUserId:@1005 nickname:@"鹿晗" avatarUrl:[NSURL URLWithString:@"https://ss2.baidu.com/6ONYsjip0QIZ8tyhnq/it/u=437161406,3838120455&fm=58"]];
    HQLUser *user6 = [[HQLUser alloc] initWithUserId:@1006 nickname:@"杨幂" avatarUrl:[NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1663450221,575161902&fm=58"]];
    HQLUser *user7 = [[HQLUser alloc] initWithUserId:@1007 nickname:@"唐嫣" avatarUrl:[NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=1655233011,1466773944&fm=58"]];
    HQLUser *user8 = [[HQLUser alloc] initWithUserId:@1008 nickname:@"刘亦菲" avatarUrl:[NSURL URLWithString:@"https://ss0.baidu.com/6ONWsjip0QIZ8tyhnq/it/u=3932899473,3078920054&fm=58"]];
    HQLUser *user9 = [[HQLUser alloc] initWithUserId:@1009 nickname:@"林允儿" avatarUrl:[NSURL URLWithString:@"https://ss1.baidu.com/6ONXsjip0QIZ8tyhnq/it/u=2961367360,923857578&fm=58"]];
    
    self.users = @[user0,user1,user2,user3,user4,user5,user6,user7,user8,user9];
    
    // 模拟话题数据
    NSMutableArray *topicArrays = [NSMutableArray arrayWithCapacity:20];
    NSDate *date = [NSDate date];
    for (NSInteger i = 0; i < 20; i++) {
        
        HQLTopic *topic = [[HQLTopic alloc] init];
        topic.topicId = [NSNumber numberWithInteger:i];
        
        // 点赞数
        NSInteger thumbNumber = [self randomNumberFrom:1000 to:100000];
        topic.thumbNums = [NSNumber numberWithInteger:thumbNumber];
        
        // 是否点赞
        topic.thumb = [self randomNumberFrom:0 to:1];
        
        // 时间
        NSTimeInterval timeInterval = date.timeIntervalSince1970 - 1000 *(30 -i) - 60;
        NSDate *d = [NSDate dateWithTimeIntervalSince1970:timeInterval];
        topic.createDateTime = d;
        
        // 发布内容
        topic.content = [self.textString substringFromIndex:[self randomNumberFrom:1 to:self.textString.length - 1]];
        topic.user = [self.users jk_objectAtIndex:[self randomNumberFrom:0 to:9]];
        topic.commentsCount = [NSNumber numberWithInteger:[self randomNumberFrom:0 to:20]];
        
        // 评论
        topic.comments = [[NSMutableArray alloc] init];
        for (NSInteger j = 0; j < topic.commentsCount.integerValue; j++) {
            HQLComment *comment = [[HQLComment alloc] init];
            comment.commentId = [NSNumber numberWithInteger:j];
            comment.createDateTime = [NSDate date];
            comment.content = [self.textString substringToIndex:[self randomNumberFrom:1 to:30]];
            
            if (j % 3 == 0) {
                /// 是否是回复
                comment.reply = YES;
                /// 被回复的用户
                comment.toUser = [self.users jk_objectAtIndex:[self randomNumberFrom:0 to:5]];
            } else {
                comment.reply = NO;
            }
            
            comment.fromeUser = [self.users jk_objectAtIndex:[self randomNumberFrom:6 to:9]];
            
            [topic.comments addObject:comment];
        }
        
        [topicArrays addObject:topic];
    }
    
    self.topics = [NSArray arrayWithArray:topicArrays];
}

- (NSInteger)randomNumberFrom:(NSInteger)from to:(NSInteger)to {
    return (NSInteger)(from + (arc4random() % (to - from + 1)));
}

- (void)setupTableView {
    self.navigationItem.title = @"评论列表1";
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.tableView.backgroundColor = rgb(249, 249, 249);
    
    // 系统自适应高度
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 32.0f;
    self.tableView.estimatedSectionHeaderHeight = 80.0f;
    self.tableView.sectionFooterHeight = 10.0f;
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone; // 分割线样式
    self.tableView.tableFooterView = [UIView new];    // 隐藏列表空白区域的分隔线

    // 注册重用 header/footer cell
    [self.tableView registerClass:HQLTopicHeaderView.class forHeaderFooterViewReuseIdentifier:headerReuseIdentifier];
    [self.tableView registerClass:HQLTopicFooterView.class forHeaderFooterViewReuseIdentifier:footerReuseIdentifier];
    
    // 注册重用 cell（class 类型）
    [self.tableView registerClass:HQLCommentCell.class forCellReuseIdentifier:cellReuseIdentifier];
}

#pragma mark - <UITableViewDataSource>

// 一共有多少个 section，此示例中，一个 section 对应一个 topic 话题数据。
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.topics.count;
}

// 各个 section 中有多少个 row，此示例中，一个 row 对应一条 comments 评论数据。
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HQLTopic *currentTopic = (HQLTopic *)[self.topics jk_objectAtIndex:section];
    return currentTopic.comments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HQLCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:cellReuseIdentifier forIndexPath:indexPath];
    HQLTopic *currentTopic = (HQLTopic *)[self.topics jk_objectAtIndex:indexPath.section];
    HQLComment *currentComment = (HQLComment *)[currentTopic.comments jk_objectAtIndex:indexPath.row];
    cell.comment = currentComment;
    cell.delegate = self;
    return cell;
}

#pragma mark - <UITableViewDelegate>

// section header 显示话题数据
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    HQLTopicHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:headerReuseIdentifier];
    HQLTopic *currentTopic = (HQLTopic *)[self.topics jk_objectAtIndex:section];
    headerView.topic = currentTopic;
    headerView.delegate = self;
    return headerView;
}

// section footer 显示分割线
- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    HQLTopicFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:footerReuseIdentifier];
    return footerView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - <HQLCommentCellDelegate>

/// 点击评论中的用户昵称
- (void)commentCellDidTappedUser:(HQLUser *)user {
    // 跳转到对应的用户中心主页
    [self pushToUserCenterViewController:user];
}

#pragma mark - <HQLTopicHeaderViewDelegate>

/// 点击头像或者昵称的回调
- (void)topicHeaderViewDidClickedUser:(HQLUser *)user {
    // 跳转到对应的用户中心主页
    [self pushToUserCenterViewController:user];
}

/// 点击话题文本的回调
- (void)topicHeaderViewDidClickedContent:(HQLTopic *)topic {
    // TODO: 直接回复该评论，弹出回复键盘
    
}

/// 点击更多按钮
- (void)topicHeaderViewDidClickedMoreButton {
    // TODO: 显示弹窗，分享、收藏、举报、转发、拉黑...anything
}

/// 点击点赞按钮
- (void)topicHeaderViewDidClickedThumbButton:(UIButton *)thumbButton {
    // 点赞
    thumbButton.selected = !thumbButton.isSelected;
}

- (void)pushToUserCenterViewController:(HQLUser *)user {
    HQLUserCenterViewController *vc = [[HQLUserCenterViewController alloc] init];
    vc.user = user;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
