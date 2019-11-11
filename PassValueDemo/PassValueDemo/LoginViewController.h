//
//  LoginViewController.h
//  PassValueDemo
//
//  Created by ToninTech on 2017/3/15.
//  Copyright © 2017年 ToninTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuccessLoginDelegate.h"

@interface LoginViewController : UIViewController

@property (nonatomic,assign) NSInteger index;

@property (nonatomic, assign) NSObject<SuccessLoginDelegate> *delegate;

@end
