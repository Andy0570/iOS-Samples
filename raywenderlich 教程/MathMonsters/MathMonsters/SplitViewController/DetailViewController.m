//
//  DetailViewController.m
//  MathMonsters
//
//  Created by Qilin Hu on 2020/5/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "DetailViewController.h"
#import "MasterViewController.h"
#import "Monster.h"

@interface DetailViewController () 

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *weaponImageView;

@end

@implementation DetailViewController


#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark - Custom Accessors

- (void)setMonster:(Monster *)monster {
    _monster = monster;
    
    [self loadViewIfNeeded];
    self.nameLabel.text = monster.name;
    self.descriptionLabel.text = monster.desc;
    self.iconImageView.image = [UIImage imageNamed:monster.iconName];
    self.weaponImageView.image = [UIImage imageNamed:monster.weaponName];
}


#pragma mark - MonsterSelectionDelegate

- (void)monsterSelected:(Monster *)monster {
    self.monster = monster;
}



@end
