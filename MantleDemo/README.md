* GitHub: [Mantle](https://github.com/Mantle/Mantle)
* Star: 11.2k



# Mantle——iOS 模型 & 字典转换框架

[Mantle](https://github.com/mantle/mantle) 是 iOS 和 Mac 平台下基于 Objective-C 编写的一个简单高效的模型层框架。

## 典型的模型对象

通常情况下，用 Objective-C 编写模型对象的方式存在哪些问题？

让我们用 [GitHub API](http://developer.github.com)  进行演示。在 Objective-C 中，如何用一个模型来表示 [GitHub
issue](http://developer.github.com/v3/issues/#get-a-single-issue) ？


```objc
typedef enum : NSUInteger {
    GHIssueStateOpen,
    GHIssueStateClosed
} GHIssueState;

@interface GHIssue : NSObject <NSCoding, NSCopying>

@property (nonatomic, copy, readonly) NSURL *URL;
@property (nonatomic, copy, readonly) NSURL *HTMLURL;
@property (nonatomic, copy, readonly) NSNumber *number;
@property (nonatomic, assign, readonly) GHIssueState state;
@property (nonatomic, copy, readonly) NSString *reporterLogin;
@property (nonatomic, copy, readonly) NSDate *updatedAt;
@property (nonatomic, strong, readonly) GHUser *assignee;
@property (nonatomic, copy, readonly) NSDate *retrievedAt;

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

- (id)initWithDictionary:(NSDictionary *)dictionary;

@end
```

```objc
@implementation GHIssue

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

- (id)initWithDictionary:(NSDictionary *)dictionary {
    self = [self init];
    if (self == nil) return nil;

    _URL = [NSURL URLWithString:dictionary[@"url"]];
    _HTMLURL = [NSURL URLWithString:dictionary[@"html_url"]];
    _number = dictionary[@"number"];

    if ([dictionary[@"state"] isEqualToString:@"open"]) {
        _state = GHIssueStateOpen;
    } else if ([dictionary[@"state"] isEqualToString:@"closed"]) {
        _state = GHIssueStateClosed;
    }

    _title = [dictionary[@"title"] copy];
    _retrievedAt = [NSDate date];
    _body = [dictionary[@"body"] copy];
    _reporterLogin = [dictionary[@"user"][@"login"] copy];
    _assignee = [[GHUser alloc] initWithDictionary:dictionary[@"assignee"]];

    _updatedAt = [self.class.dateFormatter dateFromString:dictionary[@"updated_at"]];

    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [self init];
    if (self == nil) return nil;

    _URL = [coder decodeObjectForKey:@"URL"];
    _HTMLURL = [coder decodeObjectForKey:@"HTMLURL"];
    _number = [coder decodeObjectForKey:@"number"];
    _state = [coder decodeUnsignedIntegerForKey:@"state"];
    _title = [coder decodeObjectForKey:@"title"];
    _retrievedAt = [NSDate date];
    _body = [coder decodeObjectForKey:@"body"];
    _reporterLogin = [coder decodeObjectForKey:@"reporterLogin"];
    _assignee = [coder decodeObjectForKey:@"assignee"];
    _updatedAt = [coder decodeObjectForKey:@"updatedAt"];

    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    if (self.URL != nil) [coder encodeObject:self.URL forKey:@"URL"];
    if (self.HTMLURL != nil) [coder encodeObject:self.HTMLURL forKey:@"HTMLURL"];
    if (self.number != nil) [coder encodeObject:self.number forKey:@"number"];
    if (self.title != nil) [coder encodeObject:self.title forKey:@"title"];
    if (self.body != nil) [coder encodeObject:self.body forKey:@"body"];
    if (self.reporterLogin != nil) [coder encodeObject:self.reporterLogin forKey:@"reporterLogin"];
    if (self.assignee != nil) [coder encodeObject:self.assignee forKey:@"assignee"];
    if (self.updatedAt != nil) [coder encodeObject:self.updatedAt forKey:@"updatedAt"];

    [coder encodeUnsignedInteger:self.state forKey:@"state"];
}

- (id)copyWithZone:(NSZone *)zone {
    GHIssue *issue = [[self.class allocWithZone:zone] init];
    issue->_URL = self.URL;
    issue->_HTMLURL = self.HTMLURL;
    issue->_number = self.number;
    issue->_state = self.state;
    issue->_reporterLogin = self.reporterLogin;
    issue->_assignee = self.assignee;
    issue->_updatedAt = self.updatedAt;

    issue.title = self.title;
    issue->_retrievedAt = [NSDate date];
    issue.body = self.body;

    return issue;
}

- (NSUInteger)hash {
    return self.number.hash;
}

- (BOOL)isEqual:(GHIssue *)issue {
    if (![issue isKindOfClass:GHIssue.class]) return NO;

    return [self.number isEqual:issue.number] && [self.title isEqual:issue.title] && [self.body isEqual:issue.body];
}

@end
```

哇，这么简单的事情就编写了很多样板代码！而且，即使如此，此示例仍无法解决一些问题：

 * 无法使用服务器的新数据更新 `GHIssue`。
 * 无法反过来将 `GHIssue` 转换回 JSON。
 * `GHIssueState` 不应原样编码。如果这个枚举类型将来发生了变更，则现有的归档会崩溃（向下无法兼容）。
 * 如果 `GHIssue` 的接口未来发生变化，则现有的归档会崩溃（向下无法兼容）。

## 为什么不使用 Core Data?

Core Data 很好地解决了某些问题。如果你需要对数据执行复杂的查询，处理具有大量关系的巨大对象图或支持撤消和重做，那么 Core Data 是一个很好的选择。

但是，它确实也有一些痛点：

 * **仍然需要编写很多样板代码** 管理对象减少了上面看到的一些样板代码，但是 Core Data 有很多自己的东西。正确设置 Core Data 堆栈（持久性存储和持久性存储协调器）并执行提取操作可能也需要编写不少代码。
 * **它很难正确工作** 即使是经验丰富的开发人员，在使用 Core Data 时也会犯错，并且该框架也让人难以忍受。

如果你只是想尝试访问  JSON 对象，Core Data 可能需要耗费很多功夫而收效甚微（投入大于收益，不划算）。

尽管如此，如果你已经在应用程序中使用或想要使用 Core Data，Mantle 仍然可以是 API 和模型对象之间的便捷转换层。

## MTLModel

输入 [MTLModel](https://github.com/github/Mantle/blob/master/Mantle/MTLModel.h)。这是继承自 `MTLModel` 对象的 `GHIssue` 对象示例：

```objc
typedef enum : NSUInteger {
    GHIssueStateOpen,
    GHIssueStateClosed
} GHIssueState;

// 需要遵守 <MTLJSONSerializing> 协议
@interface GHIssue : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy, readonly) NSURL *URL;     // URL 类型
@property (nonatomic, copy, readonly) NSURL *HTMLURL; // URL 类型
@property (nonatomic, copy, readonly) NSNumber *number;
@property (nonatomic, assign, readonly) GHIssueState state; // 枚举类型
@property (nonatomic, copy, readonly) NSString *reporterLogin;
@property (nonatomic, strong, readonly) GHUser *assignee; // 该属性指向 GHUser 对象实例
@property (nonatomic, copy, readonly) NSDate *updatedAt; // JSON 日期字符串，转换为 NSDate

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *body;

@property (nonatomic, copy, readonly) NSDate *retrievedAt;

@end
```

```objc
@implementation GHIssue

+ (NSDateFormatter *)dateFormatter {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
    return dateFormatter;
}

// 模型和 JSON 的自定义映射
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"URL"           : @"url",
        @"HTMLURL"       : @"html_url",
        @"number"        : @"number",
        @"state"         : @"state",
        @"reporterLogin" : @"user.login",
        @"assignee"      : @"assignee",
        @"updatedAt"     : @"updated_at"
    };
}

// 自定义 JSON 模型转换，URL -> NSURL
+ (NSValueTransformer *)URLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

// 自定义 JSON 模型转换，URL -> NSURL
+ (NSValueTransformer *)HTMLURLJSONTransformer {
    return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
}

// 自定义 JSON 模型转换，JSON 字符串 -> 枚举类型
+ (NSValueTransformer *)stateJSONTransformer {
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
        @"open": @(GHIssueStateOpen),
        @"closed": @(GHIssueStateClosed)
    }];
}

// assignee 属性是一个 GHUser 对象实例
+ (NSValueTransformer *)assigneeJSONTransformer {
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:GHUser.class];
}

// 自定义 JSON 模型转换，JSON 字符串 -> NSDate
+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        // 自定义 JSON 转模型方式
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        // 自定义模型转 JSON 方式
        return [self.dateFormatter stringFromDate:date];
    }];
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;

    // 存储需要在初始化时由本地确定的值
    _retrievedAt = [NSDate date];

    return self;
}

@end
```

此版本中明显没有 `<NSCoding>`，
`<NSCopying>`，`-isEqual:`，和  `-hash` 的方法实现。通过检查子类中的 `@property` 属性声明，`MTLModel` 可以为所有这些方法提供默认实现。

原始示例中的问题也都被修复了：

> 无法使用服务器中的新数据更新 `GHIssue`。

`MTLModel` 扩展了一个的 `-mergeValuesForKeys: FromModel:`方法，可以与其他任何实现了` <MTLModel>` 协议的模型对象集成。

> 无法将 `GHIssue` 转换回 JSON 数据。

这是反向转换器真正派上用场的地方。
`+[MTLJSONAdapter JSONDictionaryFromModel:error:]`  可以把任何遵守 `<MTLJSONSerializing>` 协议的模型对象转换回 JSON 字典。
`+[MTLJSONAdapter JSONArrayFromModels:error:]` 是同样的，但是它是将包含模型对象的数组转换为  JSON 数组。

> 如果 `GHIssue`  的接口发生变化，则现有存档可能会无法工作。

`MTLModel` 会自动保存用于归档的模型对象的版本。当取消归档时，如果覆盖了 `-decodeValueForKey:withCoder:modelVersion:` 方法它会被自动调用，从而为你提供方便的挂钩来升级旧数据。



## MTLJSONSerializing - 模型和 JSON 的相互转换

为了将模型对象从 JSON 序列化或序列化为 JSON，你需要在自定义的 `MTLModel` 子类中声明遵守`<MTLJSONSerializing>` 协议。这样就可以使用 `MTLJSONAdapter` 将模型对象从 JSON 转换回来：

```objc
// JSON -> Model
NSError *error = nil;
XYUser *user = [MTLJSONAdapter modelOfClass:XYUser.class fromJSONDictionary:JSONDictionary error:&error];
```

```objc
// Model -> JSON
NSError *error = nil;
NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:user error:&error];
```



### +JSONKeyPathsByPropertyKey - 实现模型和 JSON 的自定义映射

此方法返回的 `NSDictionary` 字典用于指定如何将模型对象的属性映射到 JSON 的键上。

```objc
@interface XYUser : MTLModel

@property (readonly, nonatomic, copy) NSString *name;
@property (readonly, nonatomic, strong) NSDate *createdAt;

@property (readonly, nonatomic, assign, getter = isMeUser) BOOL meUser;
@property (readonly, nonatomic, strong) XYHelper *helper;

@end

@implementation XYUser

// 模型和 JSON 的自定义映射
// 将模型对象的属性名称与 JSON 对象的 key 名称进行映射。
+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
        @"name": @"name",
        @"createdAt": @"created_at"
    };
}

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error {
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self == nil) return nil;

    _helper = [XYHelper helperWithName:self.name createdAt:self.createdAt];

    return self;
}

@end
```

在此示例中，`XYUser` 类声明了 Mantle 需要以不同方式处理的四个属性：

- `name` 属性被映射到了 JSON 中相同名称的键上。
- `createdAt` 属性映射到了其等效的蛇形格式的键上。
- `meUser` 属性没有序列化为 JSON。
- JSON 反序列化后，`helper` 属性会在本地被初始化。


如果模型的父类还遵守了 `<MTLJSONSerializing>` 协议，则使用 `-[NSDictionary mtl_dictionaryByAddingEntriesFromDictionary:]` 来合并其映射。


如果你想将模型类的所有属性映射到它们自己，则可以使用`+[NSDictionary mtl_identityPropertyMapWithModel:]` 辅助方法。


使用 `+[MTLJSONAdapter modelOfClass:fromJSONDictionary:error:]` 方法反序列化 JSON 时，与属性名称不对应或具有显式映射的 JSON 将被忽略：

```objc
NSDictionary *JSONDictionary = @{
    @"name": @"john",
    @"created_at": @"2013/07/02 16:40:00 +0000",
    @"plan": @"lite"
};

XYUser *user = [MTLJSONAdapter modelOfClass:XYUser.class fromJSONDictionary:JSONDictionary error:&error];
```

这里， `plan`  字段将会被忽略，因为它既不匹配 `XYUser` 的属性名称，也不映射到`+JSONKeyPathsByPropertyKey` 中。


### `+JSONTransformerForKey:` - 对 JSON 和模型不同类型手动进行映射

从 JSON 反序列化时，实现此可选的 `<MTLJSONSerializing>` 协议方法以将属性转换为其他类型。

> 💡 
>
> 将 JSON 对象转换为模型对象时，如果 JSON 对象的数据类型和模型对象的数据类型不一致，或者无法实现自动转换时，需要通过以下的方法进行手动转换。
>
> ```objc
> + (NSValueTransformer *)JSONTransformerForKey:(NSString *)key;
> ```
>
> 此方法支持批量的自定义映射！通过判断属性名 `key` 的不同，可以实现多个属性的自定义映射操作。

```objc
/**
  这边的局部参数 key 指的是模型对象的属性名称。
 */
+ (NSValueTransformer *)JSONTransformerForKey:(NSString *)key {
    if ([key isEqualToString:@"createdAt"]) {
        // 当处理 createdAt 属性的映射时，执行自定义转换
        return [NSValueTransformer valueTransformerForName:XYDateValueTransformerName];
    }

    return nil;
}
```

`key` 是应用于模型对象的属性名；不是原始的 JSON 中的键。如果你使用 `+JSONKeyPathsByPropertyKey`  转换时，请记住这一点。

为了更加方便，如果你实现了 `+<key>JSONTransformer` 方法，那么 `MTLJSONAdapter` 将改用该方法的结果。例如，JSON 中通常表示为字符串的日期可以转换为 `NSDate`，如下所示：

```objc
// 自定义 JSON 模型转换，JSON 字符串 -> NSDate
+ (NSValueTransformer *)updatedAtJSONTransformer {
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *dateString, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter dateFromString:dateString];
    } reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
        return [self.dateFormatter stringFromDate:date];
    }];
}
```

如果转换器是可逆的，则在将对象序列化为 JSON 时也将使用它。

> 💡
>
> 也就是说，属性的自定义转换有两种途径，一种是：
>
> ```objc
> + (NSValueTransformer *)JSONTransformerForKey:(NSString *)key;
> ```
>
> 它支持批量的自定义映射操作。
>
> 还有一种是单个属性的自定义映射方法，即：
>
> ```objc
> +<key>JSONTransformer;
> ```
>
> 这边的 `<key>` 是模型对象中属性的名字。以上面的 `GHIssue` 例子来说，`GHIssue` 对象中的第一个属性 `URL` 是 `NSURL` 类型的属性，而 JSON 模型返回的 URL 链接是一个字符串类型，它们之间的数据类型不一致，因此这个属性无法实现自动转换，需要手动实现，即：
>
> ```objc
> // 自定义 JSON 模型转换，URL -> NSURL
> // 这个方法中的 <key> 就是 URL，即模型中的 URL 属性。
> + (NSValueTransformer *)URLJSONTransformer {
>     return [NSValueTransformer valueTransformerForName:MTLURLValueTransformerName];
> }
> ```
>
> 也就是说每个单独实现的自定义转换方法名是通过模型属性名与 `JSONTransformer` 拼接而来的。
>
> 💡 此外，这个 “拼接形式” 的自定义模型转换方法的优先级比 `JSONTransformerForKey:` 要高！也就是说，如果两个方法中都实现了某一个属性的自定义 JSON 模型转换，则以此方法的实现为准！



### `+classForParsingJSONDictionary:`


如果你使用了类簇，请实现此可选方法，``classForParsingJSONDictionary` 可以让你选择使用哪一个类进行 JSON 反序列化。

```objc
@interface XYMessage : MTLModel

@end

@interface XYTextMessage: XYMessage

@property (readonly, nonatomic, copy) NSString *body;

@end

@interface XYPictureMessage : XYMessage

@property (readonly, nonatomic, strong) NSURL *imageURL;

@end

@implementation XYMessage

+ (Class)classForParsingJSONDictionary:(NSDictionary *)JSONDictionary {
    if (JSONDictionary[@"image_url"] != nil) {
        return XYPictureMessage.class;
    }

    if (JSONDictionary[@"body"] != nil) {
        return XYTextMessage.class;
    }

    NSAssert(NO, @"No matching class for the JSON dictionary '%@'.", JSONDictionary);
    return self;
}

@end
```

然后，`MTLJSONAdapter` 会根据你传入的 JSON 字典自动选择类：

```objc
NSDictionary *textMessage = @{
    @"id": @1,
    @"body": @"Hello World!"
};

NSDictionary *pictureMessage = @{
    @"id": @2,
    @"image_url": @"http://example.com/lolcat.gif"
};

XYTextMessage *messageA = [MTLJSONAdapter modelOfClass:XYMessage.class fromJSONDictionary:textMessage error:NULL];

XYPictureMessage *messageB = [MTLJSONAdapter modelOfClass:XYMessage.class fromJSONDictionary:pictureMessage error:NULL];
```

## Persistence 持久化存储

Mantle 不会自动为你保留对象。但是，MTLModel 默认实现了 `NSCoding` 协议，可以利用 `NSKeyedArchiver` 方便的对对象进行归档和解档。

如果你需要更强大的功能，或者想要避免一次将整个模型保留在内存中，那么 Core Data 可能是更好的选择。


## 最低系统要求

Mantle supports the following platform deployment targets:

* macOS 10.10+
* iOS 8.0+
* tvOS 9.0+
* watchOS 2.0+


## 导入 Mantle

### 手动导入

To add Mantle to your application:

 1. Add the Mantle repository as a submodule of your application's repository.
 1. Run `git submodule update --init --recursive` from within the Mantle folder.
 1. Drag and drop `Mantle.xcodeproj` into your application's Xcode project.
 1. On the "General" tab of your application target, add `Mantle.framework` to the "Embedded Binaries".

If you’re instead developing Mantle on its own, use the `Mantle.xcworkspace` file.

### [Carthage](https://github.com/Carthage/Carthage) 方式

Simply add Mantle to your `Cartfile`:

```ruby
github "Mantle/Mantle"
```

### [CocoaPods](https://cocoapods.org/pods/Mantle) 方式

Add Mantle to your `Podfile` under the build target they want it used in:

```ruby
target 'MyAppOrFramework' do
  pod 'Mantle'
end
```

Then run a `pod install` within Terminal or the [CocoaPods app](https://cocoapods.org/app).



## License

Mantle is released under the MIT license. See
[LICENSE.md](https://github.com/github/Mantle/blob/master/LICENSE.md).

## More Info

Have a question? Please [open an issue](https://github.com/Mantle/Mantle/issues/new)!



## 参考

* [Mantle-- 国外程序员最常用的 iOS 模型 & 字典转换框架](https://segmentfault.com/a/1190000003882034)
* [iOS 模型框架 - Mantle 解读](https://www.jianshu.com/p/d9e66beedb8f)
