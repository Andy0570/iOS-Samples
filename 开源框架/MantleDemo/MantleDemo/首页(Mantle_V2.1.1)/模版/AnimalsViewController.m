//
//  AnimalsViewController.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/30.
//  Copyright © 2020 Qilin Hu. All rights reserved.
//

#import "AnimalsViewController.h"

// Model
#import "Animals.h"
#import "XYUser.h"

@interface AnimalsViewController ()

@end

@implementation AnimalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self testXYUser];
}


- (void)jsonToModel {
    
    NSError *error = nil;
    
    // JSON 字典 -> 模型
    Animals *animals = [MTLJSONAdapter modelOfClass:Animals.class
                                 fromJSONDictionary:@{}
                                              error:&error];
    
    // 模型 -> JSON 字典
    NSDictionary *JSONDictionary = [MTLJSONAdapter JSONDictionaryFromModel:animals
                                                                     error:&error];
    
    // JSON 数组 -> NSArray
    NSArray *modelArray = [MTLJSONAdapter modelsOfClass:Animals.class
                                          fromJSONArray:@[]
                                                  error:&error];
    
    // NSArray -> JSON 数组
    NSArray *JSONArray = [MTLJSONAdapter JSONArrayFromModels:modelArray
                                                       error:&error];
    
    
    NSLog(@"%@",JSONDictionary);
    NSLog(@"%@", JSONArray);
}

- (void)testXYUser {
    NSDictionary *JSONDictionary = @{
        @"name": @"john",
        @"created_at": @"2013-07-02 16:40:00 +0000",
        @"plan": @"lite"
    };
    
    NSError *error = nil;
    XYUser *user = [MTLJSONAdapter modelOfClass:XYUser.class
                             fromJSONDictionary:JSONDictionary
                                          error:&error];
    if (error) {
        NSLog(@"%@",error);
        return;
    }
    NSLog(@"\n%@",user);
}

@end
