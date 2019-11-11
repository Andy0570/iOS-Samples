//
//  main.m
//  BMITime
//
//  Created by ToninTech on 2017/3/20.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

/*
 *  参考《Objective-C 编程》（第2版）练习编程。
 *  第 18 章 —— 第一个自定义类
 *
 */

#import <Foundation/Foundation.h>
//#import "BNRPerson.h"
#import "BNREmployee.h"
#import "BNRAsset.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        
        /* 111
         
        // 创建 BNRPerson 实例
        // BNREmployee 的实例可以回应 BNRPerson 的方法
//        BNRPerson *mikey = [[BNREmployee alloc] init];
        
        // 创建 BNREmployee 类的实例
        BNREmployee *mikey = [[BNREmployee alloc] init];
        
        
        // 使用 setter 存方法 为实例变量赋值
//        [mikey setWeightInkilos:96];
//        [mikey setHeightInMeters:1.8];
        // 使用 点语法
        mikey.weightInkilos = 96;
        mikey.heightInMeters = 1.8;
        mikey.employeeID = 12;
        
//        mikey.hireDate = [NSDate dateWithNaturalLanguageString:@"Aug 2nd,2010"];
        //Specifying date
        NSDateComponents *components = [NSDateComponents new];
        [components setYear:2010];
        [components setDay:2];
        [components setMonth:8];
        //We need this calendar so that we can use -dateFromComponents function:)
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier: NSCalendarIdentifierGregorian];
        //Assigning final date to our Object/Employee
        mikey.hireDate = [gregorian dateFromComponents: components];
        //Giving date nice look (Aug %day, %year)
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        //Displays time in ENG (or localization), i get russian output by default without these two lines: Август 2, 2010
        NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
        [dateFormatter setLocale:usLocale];
        //Applying dateFormatter to our date(mikey.hireDate), because it needs to look fancy... the result will be string, i just don't know how to make mikey.hireDate look right (%month %day, %year) without converting it to String    :}
        NSString *finalDateItsStringNow = [dateFormatter stringFromDate:mikey.hireDate];
        
        // 使用 getter 取方法 打印出实例变量的值
//        float height = [mikey heightInMeters];
//        int weight = [mikey weightInkilos];
        float height = mikey.heightInMeters;
        int weight = mikey.weightInkilos;
        NSLog(@"mikey is %.2f meters tall and weights %d kilograms",height,weight);
        NSLog(@"%@ hired on %@",mikey,finalDateItsStringNow);
        
        // 使用定制方法打印出 bmi 的值
        float bmi = [mikey bodyMassIndex];
        double years = [mikey yearsOfEmployment];
        NSLog(@"BMI of %.2f,has worked with us for %.2f years",bmi,years);
         
         111 */
        
        // 创建一数组，用来包含多个 BNREmployee 对象
        NSMutableArray *employees = [[NSMutableArray alloc] init];
        
        // 创建 NSMutableDictionary 对象，用于包含多个“主管”
        NSMutableDictionary *executives = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < 10 ; i ++) {
            // 创建 BNREmployee 实例
            BNREmployee *mikey = [[BNREmployee alloc] init];
            
            // 为实例变量赋值
            mikey.weightInkilos = 90 + i;
            mikey.heightInMeters = 1.8 - i/10.0;
            mikey.employeeID = i;
            
            // 将新创建的 BNREmployee 实例加入数组
            [employees addObject:mikey];
            
            // 第一个 BNREmployee 对象?
            if (i == 0) {
                [executives setObject:mikey forKey:@"CEO"];
            }
            
            // 第二个 BNREmployee 对象?
            if (i == 1) {
                [executives setObject:mikey forKey:@"CTO"];
            }
        }
        
        // 让一个数组包含所有的 BNRAsset 对象
        NSMutableArray *allAssets = [[NSMutableArray alloc] init];
        
        // 创建 10 个 BNRAsset 对象
        for (int i = 0; i < 10 ; i ++) {
            // 创建一个 BNRAsset 对象
            BNRAsset *asset = [[BNRAsset alloc] init];
            
            // 为 BNRAsset 对象设置合适的标签
            NSString *currentLabel = [NSString stringWithFormat:@"Laptop %d",i];
            asset.label = currentLabel;
            asset.resaleValue = 350 + i * 17;
            
            // 生成 0 至 9 之间的随机整数 （包含0 和 9）
            NSUInteger randomIndex = random() % [employees count];
            
            // 取出相应的 BNREmployee 对象
            BNREmployee *randomEmployee = [employees objectAtIndex:randomIndex];
            
            // 将 BNRAsset 对象赋值给该 BNREmployee 对象
            [randomEmployee addAsset:asset];
            
            [allAssets addObject:asset];
        }
        
        //  先根据 valueOfAssets 属性进行 升序 排序
        NSSortDescriptor *voa = [NSSortDescriptor sortDescriptorWithKey:@"valueOfAssets" ascending:YES];
        // 如果某两个对象的 valueOfAssets 属性相同，再根据 employeeID 属性 升序 排序
        NSSortDescriptor *eid = [NSSortDescriptor sortDescriptorWithKey:@"employeeID" ascending:YES];
        
        [employees sortUsingDescriptors:@[voa,eid]];
        
        NSLog(@"employees: %@", employees);
        
        NSLog(@"Giving up ownership of one employee");
        
        [employees removeObjectAtIndex:5];
        
        NSLog(@"allAssets:%@",allAssets);
        
        // 输出整个 NSMutableDictionary 对象
        NSLog(@"executives:%@",executives);
        
        // 输出CEO的信息
        NSLog(@"CEO:%@",executives[@"CEO"]);
        executives = nil;
        
        // 要收回拥有物品总价值高于75美元的员工的物品
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"holder.valueOfAssets > 70"];
        
        // NSMutableArray 有一个名为 - filterUsingPredicate: 的方法，通过该方法可以很方便地剔除所有不能“满足”传入的 NSPredicate 对象的对象
        // NSArray 有一个名为 filteredArrayUsingPredicate: 的方法，可以创建一个新的数组，包含所有能够满足传入的 NSPredicate 对象的对象
        NSArray *toBeReclaimed = [allAssets filteredArrayUsingPredicate:predicate];
        
        NSLog(@"toBeReclaimed:%@",toBeReclaimed);
        
        toBeReclaimed = nil;
        
        NSLog(@"Giving up ownership of arrays");
        
        allAssets = nil;
        employees = nil;
        

    }
    // 给予时间完成性能分析
    sleep(100);
    return 0;
         
         
        
        
        
}
