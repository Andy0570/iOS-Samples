//
//  HQLProvince.h
//  HQLCityPicker
//
//  Created by Qilin Hu on 2021/1/29.
//

/*
 示例城市模型

 "pinyin": "wuxishi",
 "first_char": "W",
 "area": "3",
 "id": "138",
 "parentid": "11",
 "listorder": "0",
 "code": "320200",
 "region": "0510",
 "name": "无锡市"
*/

#import <Mantle.h>

NS_ASSUME_NONNULL_BEGIN

/// 城市模型
@interface HQLCity : MTLModel <MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSString *area;
@property (nonatomic, readonly, copy) NSString *code;
@property (nonatomic, readonly, copy) NSString *first_char;
@property (nonatomic, readonly, copy) NSString *ID;
@property (nonatomic, readonly, copy) NSString *listorder;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSString *parentid;
@property (nonatomic, readonly, copy) NSString *pinyin;
@property (nonatomic, readonly, copy) NSString *region;
@end

/// 省份模型
@interface HQLProvince : MTLModel <MTLJSONSerializing>
@property (nonatomic, readonly, copy) NSString *code;
@property (nonatomic, readonly, copy) NSString *name;
@property (nonatomic, readonly, copy) NSArray<HQLCity *> *children;
@end

NS_ASSUME_NONNULL_END
