//
//  main.m
//  RandomItems
//
//  Created by Qilin Hu on 2019/11/5.
//  Copyright © 2019 Tonintech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRItem.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        // 创建一个 NSMutableArray 对象，并用 items 变量保存该对象的地址。
        NSMutableArray *items = [[NSMutableArray alloc] init];

        // 向 items 所指向的 NSMutableArray 对象发送 addObject: 消息。
        [items addObject:@"One"];
        [items addObject:@"Two"];
        [items addObject:@"Three"];

        // 继续向同一个对象发送消息，这次是 insertObject:atIndex:
        [items insertObject:@"Zero" atIndex:0];

        // 遍历数组
        // 1.通过 for 循环遍历数组
        for (int i = 0; i < [items count]; i++) {
            // 向数组发送 objectAtIndex: 消息，根据当前索引获取 NSString 对象。
            NSString *item = [items objectAtIndex:i];
            NSLog(@"%@", item);
        }

        /*
         2.通过快速枚举遍历数组

         快速枚举比传统的 for 循环语法更简洁，出错概率更低，而且经过编译器优化，遍历速度更快。

         缺点：无法在循环体中添加或删除对象！
         */
        for (NSString *item in items) {
            NSLog(@"%@", item);
        }

        // 释放 items 所指向的 NSMutableArray 对象
        items = nil;

        
        // 创建 BNRItem 对象
        BNRItem *item = [[BNRItem alloc] init];
        NSLog(@"%@ %@ %@ %d", [item itemName], [item dateCreated], [item serialNumber], [item valueInDollars]);
        // Output:
        // (null) (null) (null) 0
        /*
         当某个实例变量被创建出来后，其所有的实例变量都会被设为默认值：
         如果实例变量是指向对象的指针，那么相应的指针会指向 nil。
         如果实例变量是 int 这样的基本类型，那么其数值会是 0。
         */

        // 创建一个新的 NSString 对象 "Red Sofa"，并传给 BNRItem 对象。
        // [item setItemName:@"Red Sofa"];
        item.itemName = @"Red Sofa";
        // 创建一个新的 NSString 对象 "A1B2C"，并传给 BNRItem 对象。
        // [item setSerialNumber:@"A1B2C"];
        item.serialNumber = @"A1B2C";
        // 将数值 100 传递并赋值给 BNRItem 对象的 valueInDollars。
        // [item setValueInDollars:100];
        item.valueInDollars = 100;
        // NSLog(@"%@ %@ %@ %d", [item itemName], [item dateCreated], [item serialNumber], [item valueInDollars]);
        NSLog(@"%@ %@ %@ %d", item.itemName, item.dateCreated, item.serialNumber, item.valueInDollars);
        // Output:
        // Red Sofa (null) A1B2C 100

        // 程序会先调用相应实参的 description 方法，然后用返回的字符串替换 %@
        NSLog(@"%@", item);

        /*
         点语法

         点语法在存和取方法中的用法相同。
         区别是：如果点语法用在赋值符号左边，就表示存方法，用在右边则代表取方法。
         点语法的可读性更好。
         */
        // 使用点语法为 _valueInDollars 赋值
        item.valueInDollars = 5;
        // 使用点语法获取 _valueInDollars 的值
        int value = item.valueInDollars;
        NSLog(@"value = %d", value);

        // 使用指定初始化方法创建 BNRItem 对象
        BNRItem *item2 = [[BNRItem alloc] initWithItemName:@"Red Sofa"
                                            valueInDollars:100
                                              serialNumber:@"A1B2C"];
        NSLog(@"%@", item2);

        // 使用其他初始化方法创建 BNRItem 对象
        BNRItem *item3 = [[BNRItem alloc] initWithItemName:@"Blue Sofa"];
        NSLog(@"%@", item3);

        BNRItem *item4 = [[BNRItem alloc] init];
        NSLog(@"%@", item4);

        // 向数组中添加 10 个有随机内容的 BNRItem 对象
        NSMutableArray *items2 = [[NSMutableArray alloc] init];
        for (int i = 0; i < 10; i ++) {
            BNRItem *item = [BNRItem randomItem];
            [items2 addObject:item];
        }
        // 使用 for-in 快速遍历输出
        for (BNRItem *item in items2) {
            NSLog(@"%@",item);
        }
    }
    return 0;
}
