//
//  main.m
//  TestLinqToObjectiveC
//
//  Created by huqilin on 2025/3/13.
//

#import <Foundation/Foundation.h>

// Framework
#import "NSArray+LinqExtensions.h"
#import "NSDictionary+LinqExtensions.h"

// Model
#import "Person.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        NSLog(@"Hello, World!");
        
        NSArray *people = @[
            [[Person alloc]  initWithName:@"Andy" age:@20],
            [[Person alloc]  initWithName:@"Bob" age:@25],
            [[Person alloc]  initWithName:@"Tom" age:@27],
            [[Person alloc]  initWithName:@"Bob" age:@25]
        ];
        
        // 转换，返回 name 字符串属性
        LINQSelector nameSelector = ^id(id person) {
            return [person name];
        };
        
        // 累加器，将数组元素拼接为字符串
        LINQAccumulator csvAccumulator = ^id(id item, id aggregate) {
            return [NSString stringWithFormat:@"%@, %@", aggregate, item];
        };
        
        NSString *result = [[[[people linq_select:nameSelector]
                                     linq_sort]
                                     linq_distinct]
                                     linq_aggregate:csvAccumulator];
        // Andy, Bob, Tom
        
        
        // MARK: - linq_where
        NSArray *peopleWhoAre25 = [people linq_where:^BOOL(Person *item) {
            return [item.age isEqualToNumber:@25];
        }];
        // "Person: Name=Bob, Age=25", "Person: Name=Bob, Age=25"

        
        
        // MARK: - linq_select
        NSArray *names = [people linq_select:^id(Person *item) {
            return item.name;
        }];
        // Andy, Bob, Tom, Bob
        

        // MARK: - linq_sort
        NSArray *sortedByName = [people linq_sort:^id(Person *item) {
            return item.name;
        }];
        /**
         (
             "Person: Name=Andy, Age=20",
             "Person: Name=Bob, Age=25",
             "Person: Name=Bob, Age=25",
             "Person: Name=Tom, Age=27"
         )
         */
        
        
    }
    return 0;
}
