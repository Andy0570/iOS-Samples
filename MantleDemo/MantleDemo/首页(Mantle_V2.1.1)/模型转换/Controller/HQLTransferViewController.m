//
//  HQLTransferViewController.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/7/24.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLTransferViewController.h"

// Framework
#import <Mantle.h>
#import <YYKit.h>

// Model
#import "HQLCommonRequestModel.h"
#import "YYCommonRequestModel.h"

@interface HQLTransferViewController ()

@property (nonatomic, strong) NSDictionary *jsonData;

@property (nonatomic, strong) HQLCommonRequestModel *mantleModel;
@property (nonatomic, strong) YYCommonRequestModel *yyModel;

@end

@implementation HQLTransferViewController

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.jsonData = @{
        @"userId"     : @123,
        @"cityCode"   : @320200,
        @"categoryId" : @1,
        @"marketId"   : @22,
        @"floorId"    : @333,
        @"storeId"    : @4444,
        @"storeName"  : @"Nike 官方旗舰店",
        @"brandId"    : @55555,
        @"goodsId"    : @666666,
        @"page"       : @1,
        @"limit"      : @10
    };
}




#pragma mark - Actions

- (IBAction)mantleJsonToModel:(id)sender {
    // JSON 字典 -> 模型
    NSError *error = nil;
    HQLCommonRequestModel *model = [MTLJSONAdapter modelOfClass:HQLCommonRequestModel.class fromJSONDictionary:self.jsonData error:&error];
    NSLog(@"JSON 字典 -> 模型:\n%@",model);

    self.mantleModel = model;
}
/**
 2020-07-24 17:39:11.990806+0800 MantleDemo[50839:16283507] JSON 字典 -> 模型:
 <HQLCommonRequestModel: 0x280554ae0> {
     userId = 123,
     cityCode = 320200,
     brandId = 55555,
     goodsId = 666666,
     marketId = 22,
     limit = 10,
     categoryId = 1,
     storeId = 4444,
     storeName = Nike 官方旗舰店,
     page = 1,
     floorId = 333
 }
 */

- (IBAction)mantleModelToJson:(id)sender {
    
    // 测试：将部分参数置空
    self.mantleModel.userId = nil;
    self.mantleModel.cityCode = nil;
    
    // 模型 -> JSON 字典
    NSError *error = nil;
    NSDictionary *jsonDictionary = [MTLJSONAdapter JSONDictionaryFromModel:self.mantleModel error:&error];
    NSLog(@"模型 -> JSON 字典:\n%@",jsonDictionary);
}
/**
 !!!: 当属性为空时，Mantle 也会自动帮你转换为 <null>
 2020-07-24 17:39:13.287184+0800 MantleDemo[50839:16283507] 模型 -> JSON 字典:
 {
     userId = <null>,
     cityCode = <null>,
     brandId = 55555,
     goodsId = 666666,
     marketId = 22,
     categoryId = 1,
     limit = 10,
     storeId = 4444,
     storeName = Nike 官方旗舰店,
     page = 1,
     floorId = 333
 }

 */

- (IBAction)yyModelJsonToModel:(id)sender {
    
    YYCommonRequestModel *yyModel = [YYCommonRequestModel modelWithJSON:self.jsonData];
    NSLog(@"JSON 字典 -> 模型:\n%@",yyModel);
    
    self.yyModel = yyModel;
    
}
/**
 2020-07-24 17:39:14.680268+0800 MantleDemo[50839:16283507] JSON 字典 -> 模型:
 <YYCommonRequestModel: 0x280550480> {
     brandId = 55555;
     categoryId = 1;
     cityCode = 320200;
     floorId = 333;
     goodsId = 666666;
     limit = 10;
     marketId = 22;
     page = 1;
     storeId = 4444;
     storeName = "Nike 官方旗舰店";
     userId = 123
 }
 */


- (IBAction)yyModelModelToJson:(id)sender {
    // 测试：将部分参数置空
    self.yyModel.userId = nil;
    self.yyModel.cityCode = nil;
    
    // 模型 -> JSON 字典
    NSDictionary *jsonDictionary = [self.yyModel modelToJSONObject];
    NSLog(@"模型 -> JSON 字典:\n%@",jsonDictionary);
}
/**
  !!!: 当属性为空时，YYModel 自动忽略
 2020-07-24 17:39:19.114875+0800 MantleDemo[50839:16283507] 模型 -> JSON 字典:
 {
     limit = 10,
     storeId = 4444,
     storeName = Nike 官方旗舰店,
     goodsId = 666666,
     categoryId = 1,
     page = 1,
     brandId = 55555,
     marketId = 22,
     floorId = 333
 }
 */

@end
