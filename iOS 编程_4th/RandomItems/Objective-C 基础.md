要点：对象的创建和使用、消息发送、实例变量、类方法、实例方法、初始化方法、点语法、`NSArray`、`NSMutableArray`、`#import` 和 `@import`。

开发 iOS 应用需要使用 Objective-C 语言和 Cocoa Touch 框架。Objective-C 语言源自 C 语言，是 C 语言的扩展。Cocoa Touch 框架则是一个 Objective-C 类的集合。

## 2.1 对象

对象有实例变量，每个实例变量也有名称和类型。对象会通过实例变量（instance variable）保存属性的值。

类有属性和方法。方法和函数类似，也有名称、返回类型和一组期望传入的参数。此外，方法还可以访问对象的实例变量。要调用某个对象的方法，可以向该对象发送相应的消息（message）。

## 2.2 使用对象

要使用某个类的对象，必须先得到一个指向该对象的变量（variable）。这类“指针变量”保存的是对象在内存中的地址，而不是对象自身（所以是“指向”某个对象）。

```objectivec
// 创建了一个指针变量，变量名是 partyInstance，可以指向某个 Party 对象。
Party *partyInstance;
```

### 创建对象

向某个类发送 `alloc` 消息，可以创建该类的对像。类在收到 `alloc` 消息后，会在内存中创建对象（在堆上创建），并返回指向新对象的指针。

```objectivec
// 创建了一个指向 Party 对象的指针。
Party *partyInstance = [Party alloc];
```

对于新创建的对象，必须先向其发送一个初始化消息（initialization message）。虽然向类发送 `alloc` 消息能够创建对象，但是在完成初始化之前，新创建的对象还无法正常工作。

```objectivec
Party *partyInstance = [Party alloc];
[partyInstance init];
```

因为任何一个对象都必须在创建并且初始化之后才能使用，所有上述两个消息应该写在一行代码里，即**嵌套消息发送**（nested message send）。

```objectivec
Party *partyInstance = [[Party alloc] init];
```

程序会先执行最里面那个方括号中的代码，所以 Party 类会先收到 `alloc` 消息。接着，`alloc` 方法会返回指向新创建对象的指针。最后，未初始化的对象会收到 `init` 消息，返回初始化后的对象指针，并将指针保存在变量中。

### 发送消息

首先，消息必须写在一对方括号中。方括号中的消息包含如下三个部分：

| 消息发送语法的组成结构 | 描述                       |
| ---------------------- | -------------------------- |
| 接收方（receiver）     | 指针，指向执行方法的对象   |
| 选择器（selector）     | 需要执行方法的方法名       |
| 实参（arguments）      | 以变量形式传递给方法的数值 |

```objectivec
// 向 Party 对象发送 addAttendee: 消息，添加参加聚会的客人
// 向 partyInstance（接收方）发送 addAttendee: 消息会触发 addAttendee: 方法，并传入 somePerson（实参）。
[partyInstance addAttendee:somePerson];
```

**在 Objective-C 中，方法的唯一性取决于方法名。因此，即使参数类型或返回类型不同，一个类也不能有两个名称相同的方法。**

消息和方法之间的区别：

1. **方法是指一块可以执行的代码，而消息是指要求类或对象执行某个方法的动作。**
2. 消息的名称和将要执行的方法的名称一定是相同的。

### 释放对象

将指向对象的变量设置为 `nil`，可以要求程序释放该对象。

```objectivec
partyInstance = nil;
```

Objective-C 允许向某个值为 `nil` 的对象发送消息，且不会发生任何事情。

## 2.3 编写命令行工具 RandomItems

Objective-C 中的类是以层次结构（hierarchy）的形式存在的。除了整个层级结构的根类 `NSObject` 外，每个类都有一个且只有一个父类 （superclass）并继承其父类的行为。

在 Objective-C 中，数组所包含的“对象”并不是对象自身，而是指向对象的指针。当程序将某个对象加入数组时，数组会保存该对象在内存中的地址。

```objectivec
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
```

### 格式化字符串

`NSLog` 函数可以将某个指定的字符串输出至 Xcode 控制台。

```objectivec
int a = 1;
float b = 2.5;
char c = 'A';

NSLog(@"Integer: %d Float: %f Char: %c", a, b, c);
// Output：Integer: 1 Float: 2.500000 Char: A
```

Objective-C 的格式化字符串基本上和 C 语言相同。但是 Objective-C 支持一种额外的转换说明：`%@`，对应的实参类型是**指向任何一种对象的指针**。

程序在处理格式化字符串时，如果遇到 `%@`，则不会将其直接替换为相应位置的实参。程序首先会向相应位置的实参发送 `description` 消息，得到 `description`方法返回的 `NSString` 对象，然后使用得到的 `NSString` 对象替换 `%@`。

## 2.4 创建 Objective-C 类的子类

见源码注释。

### 实例变量

### 点语法

点语法在存和取方法中的用法相同。区别是：如果点语法用在赋值符号左边，就表示存方法，用在右边则代表取方法。

点语法和存取方法在应用运行时没有区别，而且点语法的可读性更好。

### 类方法和实例方法

**类方法**（class method）的作用通常是创建对象，或者获取类的某些全局属性。类方法不会作用在对象上，也不能存取实例变量。

**实例方法**（instance method）则用来操作类的对象（对象有时也称为类的一个实例）。

调用实例方法时，需要向类的对象发送消息，而调用类方法时，则向类自身发送消息。

### 覆盖方法

子类可以覆盖（override）父类的方法。

### 初始化方法

初始化方法（initialization method）：用于初始化类的对象的方法。

### 指定初始化方法

任何一个类，无论有多少个初始化方法，都必须选定其中的一个作为**指定初始化**（designated initializer）方法。指定初始化方法要确保对象的每一个实例变量都处在一个有效的状态。

### instancetype

`instancetype` 关键字：方法的返回类型和调用方法的对象类型相同。`init` 方法的返回类型都声明为 `instancetype`。

在 Objective-C 中，一个对象不能同时拥有两个选择器相同、但是返回类型（或者参数类型）不同的方法。

### id

`id` 的定义是“**指向任意对象的指针**”。

`instancetype` 只能用来表示方法返回类型，但是 `id` 还可以用来表示变量和方法参数的类型。如果程序运行时无法确定一个对象的类型，就可以将该对象声明为 `id`。

💡 因为 `id` 的定义是“指向任意对象的指针”，所以当一个变量的类型被声明为  `id`  时，无须在变量名或参数名前再加 “`*`”。

### self

`self` 存在于方法中，是一个隐式（implicit）局部变量。编写方法时不需要声明 `self`，并且程序会自动为 `self` 赋值，指向收到消息的自身（大多数面向对象的语言也有这个概念，有些将其称为 `this`，而不是 `self`）。

**通常情况下，`self` 会用来向对象自己发送消息**。

### super

在覆盖父类的某个方法时，往往需要保留该方法在父类中的实现，然后在其基础上扩充子类的实现。

 `super` 是如何工作的？**通常情况下，当某个对象收到消息时，系统会先从这个对象的类开始，查询和消息名相同的方法名。如果没找到，则会在这个对象的父类中继续查找。该查询过程会沿着继承路径向上，直到找到相应的方法名为止（如果直到层次结构的顶端也没能找到合适的方法，程序就会抛出异常）**。

**向 `super` 发消息，其实是向 `self` 发消息，但是要求系统在查找方法时跳过当前对象的类，从父类开始查询。**

### 其他初始化方法与初始化方法链

覆盖子类的 `init` 方法，将其与指定初始化方法“串联”起来。

**串联**（ chain）使用初始化方法的机制可以减少错误，也更容易维护代码。

在创建类时，需要先确定指定初始化方法，然后只在指定初始化方法中编写初始化的核心代码，其他初始化方法只需要调用指定初始化方法（直接或间接）并传入默认值即可。

### ⭐️⭐️⭐️ 初始化方法总结

* 类会继承父类所有的初始化方法，也可以为类加入任意数量的初始化方法。
* 每个类都要选定一个指定初始化方法。
* 在执行其他初始化工作之前，必须先用指定初始化方法调用父类的指定初始化方法（直接或间接）。
* 其他初始化方法要调用指定初始化方法（直接或间接）。
* 如果某个类所声明的指定初始化方法与其父类的不同，就必须覆盖父类的指定初始化方法并调用新的指定初始化方法（直接或间接）。

### 类方法

在返回类型的前面，实例方法使用的是字符 `-` ，而类方法使用的是字符 `+`。

在 Objective-C 中，如果某个类方法的返回类型是这个类的对象（例如  `[NSString stringWithFormat:]`），就可以将这种类方法称为**便捷方法**（convenience method）。

## 深入学习 NSArray 与 NSMutableArray

Objective-C 中的数组可以存储不同类型的对象。

数组对象只能保存指向 Objective-C 对象的指针，所以不能将基本类型（primitive）的变量或 C 结构加入数组对象。如果要将基本类型的变量和 C 结构加入数组，可以先将它们“包装”成 Objective-C 对象，例如 `NSNumber`、`NSValue` 和 `NSData`。

不能将 `nil` 加入数组。如果要将“空洞”加入数组对象，就必须使用 `NSNull` 对象。 `NSNull` 对象的作用就是代表 `nil`。

## 2.6 异常与未知选择器

Objective-C 的对象都有一个名为 `isa` 的实例变量。通过该实例变量可以知道某个对象是哪个类的实例。

```
对象 —— isa ——> 类
```

类在创建了一个对象后，会为新创建的对象的 `isa` 实例变量赋值，将其指回自己，即创建该对象的类。

如果应用向某个对象发送了其无法响应的消息，那么程序就会抛出**异常**（exception）。异常也称为**运行时错误**（run-time error）。

**未知选择器**的含义：某个对象收到了其没有实现的消息。

## 2.12 如何为类命名

* 当两个不同的类拥有相同的名称时，就会产生**名字空间冲突**（namespace collision）。
* Objective-C 没有提供名字空间（namespace）机制，为了区分类，需要为类名增加前缀（长度为2至3个字符）。
* 有着良好编程风格的程序员都会为类名加上前缀。这些前缀通常会和当前开发的应用有关，或者和代码所属的代码库有关。
* 开发者应该使用 3 个字符的前缀，避免和 Apple 提供的类产生冲突——它们都是 2 个字符的前缀。



## 2.13 #import 和 @import

Objective-C 类的数量非常庞大，一般来说需要用到系统框架的时候，都会使用 `#import ` 命令来引入，`#import ` 命令会自动引入框架的全部头文件，这样，不再需要单独引入某个类的头文件。

```objectivec
#import <Foundation/Foundation.h>
```
当项目中使用的框架越来越多时，编译器也会花费越来越多的时间处理大量重复的头文件。
为了解决这一问题以提高效率，Xcode 为所有项目都添加了一个预编译头文件（precompiled header file，PCH），第一次编译项目时，预编译头文件中列出的文件会被编译并缓存，编译器会重复使用缓存结果快速编译项目中的其他文件。

```objectivec
#ifdef __OBJC__

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#endif  /* __OBJC__ */
```
但是**维护 pch 文件低效耗时**，因此继续优化编译器并引入了 `@import` 指令：
```objectivec
@import Foundation;
```
这行代码告诉编译器需要使用 Foundation框架，之后编译器会优化预编译头文件和缓存编译结果的过程。同时，文件中不用再明确引用框架——编译器会根据`＠import`自动导入相应的框架。

Tips: 在项目的 Build Settings 配置中，将 **Enable Modules (C and Objective-C)** 设置为 **YES**，编译器会自动将  `#import` 指令转换为 Modules 的形式。
