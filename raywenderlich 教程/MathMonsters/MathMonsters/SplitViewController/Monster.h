//
//  Monster.h
//  MathMonsters
//
//  Created by Qilin Hu on 2020/5/28.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, Weapon) {
    Blowgun,
    NinjaStar,
    Fire,
    Sword,
    Smoke,
};

@interface Monster : NSObject

@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *desc;
@property (nonatomic, readonly, copy) NSString *iconName;
@property (nonatomic, readonly) Weapon weapon;

- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
                    iconName:(NSString *)iconName
                      weapon:(Weapon)weapon;

- (NSString *)weaponName;

@end

NS_ASSUME_NONNULL_END
