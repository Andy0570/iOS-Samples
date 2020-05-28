//
//  MasterViewController.m
//  MathMonsters
//
//  Created by Qilin Hu on 2020/5/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "DetailViewController.h"
#import "Monster.h"

@interface MasterViewController ()

@end

@implementation MasterViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
}


#pragma mark - Custom Accessors

- (NSArray <Monster *> *)monsters {
    if (!_monsters) {
        // 添加模型数据源
        Monster *monster1 = [[Monster alloc] initWithName:@"Cat-Bot"
                                              description:@"MEE-OW"
                                                 iconName:@"meetcatbot"
                                                   weapon:Sword];
        Monster *monster2 = [[Monster alloc] initWithName:@"Dog-Bot"
                                              description:@"BOW-WOW"
                                                 iconName:@"meetdogbot"
                                                   weapon:Blowgun];
        Monster *monster3 = [[Monster alloc] initWithName:@"Explode-Bot"
                                              description:@"BOOM!"
                                                 iconName:@"meetexplodebot"
                                                   weapon:Smoke];
        Monster *monster4 = [[Monster alloc] initWithName:@"Fire-Bot"
                                              description:@"Will Make You Steamed"
                                                 iconName:@"meetfirebot"
                                                   weapon:NinjaStar];
        Monster *monster5 = [[Monster alloc] initWithName:@"Ice-Bot"
                                              description:@"Has A Chilling Effect"
                                                 iconName:@"meeticebot"
                                                   weapon:Fire];
        Monster *monster6 = [[Monster alloc] initWithName:@"Mini-Tomato-Bot"
                                              description:@"Extremely Handsome"
                                                 iconName:@"meetminitomatobot"
                                                   weapon:NinjaStar];
        _monsters = @[monster1, monster2, monster3, monster4, monster5, monster6];
    }
    return _monsters;
}


#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.monsters.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    // 配置数据源
    Monster *currentMonster = self.monsters[indexPath.row];
    cell.textLabel.text = currentMonster.name;
    return cell;
}


#pragma mark - <UITableViewDelegate>

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取当前 Monster 模型数据
    Monster *selectedMonster = self.monsters[indexPath.row];
    
    // 通过 Delegate 的方式传递数据
    if ([self.delegate respondsToSelector:@selector(monsterSelected:)]) {
        [self.delegate monsterSelected:selectedMonster];
        
        // !!!: 通过 Delegate 链获取显示 DetailViewController 的导航视图控制器
        DetailViewController *detailViewController = (DetailViewController *)self.delegate;
        UINavigationController *detailNavController = detailViewController.navigationController;
        
        // 显示 DetailViewController 的导航视图控制器
        [self.splitViewController showDetailViewController:detailNavController sender:self];
    }
}

@end
