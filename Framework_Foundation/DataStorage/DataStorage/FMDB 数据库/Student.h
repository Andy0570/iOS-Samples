//
//  Student.h
//  DataStorage
//
//  Created by Qilin Hu on 2021/1/7.
//

#import "HQLArchiveBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface Student : HQLArchiveBaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) int age;
@property (nonatomic, assign) int number;
@property (nonatomic, copy) NSString *sex;
@property (nonatomic, assign) int height;

@property (nonatomic, copy) NSString *startTime;

@end

NS_ASSUME_NONNULL_END
