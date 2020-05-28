//
//  Monster.m
//  MathMonsters
//
//  Created by Qilin Hu on 2020/5/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "Monster.h"

@interface Monster ()

@property (nonatomic, readwrite, copy) NSString *name;
@property (nonatomic, readwrite, copy) NSString *desc;
@property (nonatomic, readwrite, copy) NSString *iconName;
@property (nonatomic, readwrite) Weapon weapon;

@end

@implementation Monster

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
                    iconName:(NSString *)iconName
                      weapon:(Weapon)weapon {
    self = [super init];
    if (self) {
        _name = name;
        _desc = description;
        _iconName = iconName;
        _weapon = weapon;
    }
    return self;
}

- (NSString *)weaponName {
    NSString *string;
    switch (self.weapon) {
        case Blowgun: {
            string = @"blowgun";
            break;
        }
        case NinjaStar: {
            string = @"ninjastar";
            break;
        }
        case Fire: {
            string = @"fire";
            break;
        }
        case Sword: {
            string = @"sword";
            break;
        }
        case Smoke: {
            string = @"smoke";
            break;
        }
    }
    
    return string;
}
@end
