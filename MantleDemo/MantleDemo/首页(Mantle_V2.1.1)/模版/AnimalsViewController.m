//
//  AnimalsViewController.m
//  MantleDemo
//
//  Created by Qilin Hu on 2020/4/27.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "AnimalsViewController.h"

// Model
#import "Animals.h"

@interface AnimalsViewController ()

@end

@implementation AnimalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

@end
