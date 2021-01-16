//
//  HQLStorageManager.h
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/7.
//

#import <Foundation/Foundation.h>
@class Student;

NS_ASSUME_NONNULL_BEGIN

@interface HQLStorageManager : NSObject

+ (instancetype)sharedManager;

- (BOOL)saveStudent:(Student *)student;
- (NSArray <Student *> *)getAllStudents;
- (BOOL)removeStudents:(NSArray <Student *> *)students;

@end

NS_ASSUME_NONNULL_END
