//
//  IMUser.h
//  DataStorage
//
//  Created by Qilin Hu on 2021/8/5.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// 用户性别
typedef NS_ENUM(NSUInteger, IMUserGender) {
    IMUserGenderFemale = 0, // 0女
    IMUserGenderMale = 1    // 1男
};

/// 用户模型
@interface IMUser : NSObject

@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) IMUserGender gender;
@property (nonatomic, assign) NSInteger age;
@property (nonatomic, copy) NSString *telephone;

@end

NS_ASSUME_NONNULL_END
