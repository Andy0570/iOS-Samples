//
//  HQLMainPageMenu.m
//  UICollectionView
//
//  Created by Qilin Hu on 2020/8/18.
//  Copyright © 2020 Shanghai Haidian Information Technology Co.Ltd. All rights reserved.
//

#import "HQLMainPageMenu.h"

// Framework
#import "CAPSPageMenu.h"

// Controller
#import "HQLMainPageViewController.h"
#import "HQLSubPageViewController.h"

@interface HQLMainPageMenu ()

@property (nonatomic, strong) CAPSPageMenu *pageMenu;

@end

@implementation HQLMainPageMenu

#pragma mark - View life cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    
}

#pragma mark - Custom Accessors





@end
