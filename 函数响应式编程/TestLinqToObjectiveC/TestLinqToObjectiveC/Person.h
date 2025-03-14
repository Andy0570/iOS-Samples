//
//  Person.h
//  TestLinqToObjectiveC
//
//  Created by huqilin on 2025/3/13.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Person : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSNumber *age;

- (instancetype)initWithName:(NSString *)name age:(NSNumber *)age;

@end

NS_ASSUME_NONNULL_END
