//
//  HQLItemStore.m
//  HQLHomepwner
//
//  Created by ToninTech on 16/8/30.
//  Copyright © 2016年 ToninTech. All rights reserved.
//

#import "HQLItemStore.h"
#import "Item.h"
#import "HQLImageStore.h"

@interface HQLItemStore ()

// 类扩展中为NSMutableArray（可变数组）
// privateItems 属性只在内部使用
@property (nonatomic, strong) NSMutableArray *privateItems;

@property (nonatomic, strong) NSMutableArray *allAssetTypes;

@end

@implementation HQLItemStore


#pragma mark - init

+ (instancetype)sharedStore {
    // 将 sharedStore 声明为了静态变量，当【某个定义了静态变量的方法】返回时，程序不会释放相应的变量
    static HQLItemStore *sharedStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedStore = [[self alloc] initPrivate];
    });
    return sharedStore;
}

// 这是真正的（私有的）初始化方法
- (instancetype)initPrivate {
    self = [super init];
    // 父类的init方法是否成功创建了对象
    if (self) {
        //载入之前保存的全部HQLItem对象
        NSString *path = [self itemArchivePath];
        //根据路径载入固化文件
        _privateItems = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
        // 如果之前没有保存过_privateItems，就创建一个新的
        if (!_privateItems) {
            _privateItems = [[NSMutableArray alloc] init];
        }
        
//        //读取Homepwner.xcdatamodeld
//        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
//        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
//        
//        //设置SQLite文件路径
//        NSString *path = [self itemArchivePath];
//        NSURL *storeURL = [NSURL fileURLWithPath:path];
//        NSError *error = nil;
//        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
//                               configuration:nil
//                                         URL:storeURL
//                                     options:nil
//                                       error:&error]) {
//            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
//        }
//        //创建NSManagedObjectContext对象
//        _context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
//        _context.persistentStoreCoordinator = psc;
//        
//        [self loadAllItems];
    }
    
    return self; 
}

// 如果调用[[HQLItemstore alloc] init],就提示应该使用[HQLItemstore sharedStore].
- (instancetype)init {
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use + [HQLItemstore sharedStore]"
                                 userInfo:nil];
    return  nil;
}


#pragma mark - Cusotm Accessors

// allItems取方法，返回值为 NSArray 类型

// 既然 allItems 被声明为了只读属性（readonly），这里又覆盖了它的取方法，
// 编译器就不会为 allItems 生成取方法和实例变量_allItems.
- (NSArray *)allItems {
    // 方法体中返回值为 NSMutableArray 类型
    return self.privateItems;
}


#pragma mark - Public

- (Item *)createItem {
    
//    Item *item = [Item randomItem];
    Item *item = [[Item alloc] init];
    
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(Item *)item {
    
    /**
     *  删除
        removeItem 方法调用了 NSMutableArray 中的 removeObjectIdenticalTo： 比较指向对象的指针，该方法只会移除数组所保存的那些和传入对象指针完全相同的指针
        removeObject：该方法会枚举数组，向每一个对象发送isEqual：消息，判断当前对象和传入对象所包含的数据是否相等
     */
    [self.privateItems removeObjectIdenticalTo:item];
    // 根据键值删除对应的图片
    NSString *key = item.itemKey;
    [[HQLImageStore sharedStore] deleteImageForKey:key];
}

- (void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex {
    if (fromIndex == toIndex) {
        return;
    }
    // 得到要移动的对象的指针，以便稍后能将其插入新的位置
    Item *item = self.privateItems[fromIndex];
    // 将 item 从 allItem 数组中移除
    [self.privateItems removeObjectAtIndex:fromIndex];
    // 根据新的索引的位置，将 item 插回 allItem 数组
    [self.privateItems insertObject:item atIndex:toIndex];
}

// 保存数据
- (BOOL) saveChanges{
    
    NSString *path = [self itemArchivePath];
    //如果固话成功就返回YES
    return [NSKeyedArchiver archiveRootObject:self.privateItems toFile:path];
    //    NSError *error;
    //    BOOL successful = [self.context save:&error];
    //    if (!successful) {
    //        NSLog(@"Error saving:%@",[error localizedDescription]);
    //    }
    //    return successful;
}


#pragma mark - Private

// 获取文件路径
- (NSString *) itemArchivePath {
    
//    //NSSearchPathForDirectoriesInDomains：获取沙盒中某种目录的全路径
//    //注意第一个参数是NSDocumentDirectory而不是NSDocumentationDirectory
//    NSArray *documentDirectiorise = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    //从documentDirectiorise数组获取第一个，也是唯一文档目录路径
//    NSString *documentDirectiory = [documentDirectiorise firstObject];
//    return [documentDirectiory stringByAppendingPathComponent:@"items.archive"];
 

//  使用Core Data
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //    //从documentDirectiorise数组获取第一个，也是唯一文档目录路径
    NSString *documentDirectiory = [documentDirectories firstObject];
    return [documentDirectiory stringByAppendingPathComponent:@"store.data"];
}

//- (void) loadAllItems {
//    
//    if (!self.privateItems) {
//        NSFetchRequest *request = [[NSFetchRequest alloc] init];
//        NSEntityDescription *e = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:self.context];
//        request.entity = e;
//        NSSortDescriptor *sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
//        request.sortDescriptors = @[sd];
//        NSError *error;
//        NSArray *result = [self.context executeFetchRequest:request error:&error];
//        if (!result) {
//            [NSException raise:@"Fetch failed" format:@"Reason:%@",[error localizedDescription]];
//        }
//        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
//    }
//    
//}

@end
