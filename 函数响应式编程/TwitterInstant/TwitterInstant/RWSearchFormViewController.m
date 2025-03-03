//
//  RWSearchFormViewController.m
//  TwitterInstant
//
//  Created by Colin Eberhardt on 02/12/2013.
//  Copyright (c) 2013 Colin Eberhardt. All rights reserved.
//

#import "RWSearchFormViewController.h"
#import "RWSearchResultsViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

#import "RWTweet.h"
#import <NSArray+LinqExtensions.h>

typedef NS_ENUM(NSUInteger, RWTwitterInstantError) {
    RWTwitterInstantErrorAccessDenied,
    RWTwitterInstantErrorNoTwitterAccounts,
    RWTwitterInstantErrorInvalidResponse,
};

static NSString *const RWTwitterInstantDomain = @"TwitterInstant";

@interface RWSearchFormViewController ()

@property (weak, nonatomic) IBOutlet UITextField *searchText;
@property (strong, nonatomic) RWSearchResultsViewController *resultsViewController;

@property (strong, nonatomic) ACAccountStore *accountStore;
@property (strong, nonatomic) ACAccountType *twitterAccountType;

@end

@implementation RWSearchFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"Twitter Instant";

    [self styleTextField:self.searchText];
    
    self.resultsViewController = self.splitViewController.viewControllers[0];
    
    /**
     ┌──────────────┐ NSString ┌─────┐ UIColor ┌─────────────┐
     │rac_textSignal├─────────►│ map ├────────►│subscribeNext│
     └──────────────┘          └─────┘         └─────────────┘
     */
    @weakify(self)
    [[self.searchText.rac_textSignal
      map:^id _Nullable (NSString *_Nullable value) {
          return [self isValidSearchText:value] ? UIColor.whiteColor : UIColor.yellowColor;
      }] subscribeNext:^(UIColor *color) {
          @strongify(self)
          self.searchText.backgroundColor = color;
      }];
    
    self.accountStore = [[ACAccountStore alloc] init];
    self.twitterAccountType = [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [[[[[[[self requestAccessToTwitterSignal]
      then:^RACSignal * _Nonnull {
        @strongify(self)
        return self.searchText.rac_textSignal;
    }] filter:^BOOL(id  _Nullable value) { // 过滤任何无效的搜索字符串
        @strongify(self)
        return [self isValidSearchText:value];
    }] throttle:0.5]
       flattenMap:^__kindof RACSignal * _Nullable(id  _Nullable value) {
        @strongify(self)
        return [self signalForSearchWithText:value];
    }] deliverOn:[RACScheduler mainThreadScheduler]] // 切换到主线程执行 UI 更新
     subscribeNext:^(NSDictionary *jsonSearchResult) {
        NSArray *statuses = jsonSearchResult[@"statuses"];
        // NSArray<NSDictionary> -> NSArray<RWTweet>
        NSArray *tweets = [statuses linq_select:^id(id tweet) {
            return [RWTweet tweetWithStatus:tweet];
        }];
        [self.resultsViewController displayTweets:tweets];
    } error:^(NSError * _Nullable error) {
        NSLog(@"An error occurred: %@", error);
    }];
    
}

- (RACSignal *)requestAccessToTwitterSignal {
    // 1. 定义一个错误
    NSError *accessError = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorAccessDenied userInfo:nil];
    
    // 2. 创建一个信号
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        
        // 3. 请求访问 Twitter
        @strongify(self)
        [self.accountStore requestAccessToAccountsWithType:self.twitterAccountType options:nil completion:^(BOOL granted, NSError *error) {
            
            // 4. 处理请求响应
            if (!granted) {
                [subscriber sendError:accessError];
            } else {
                [subscriber sendNext:nil];
                [subscriber sendCompleted];
            }
        }];
        return nil;
    }];
}

- (SLRequest *)requestforTwitterSearchWithText:(NSString *)text {
    NSURL *url = [NSURL URLWithString:@"https://twitter.com/search"];
    NSDictionary *params = @{@"q":text};
    
    SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodGET URL:url parameters:params];
    return request;
}

- (RACSignal *)signalForSearchWithText:(NSString *)text {
    // 1. 定义错误
    NSError *noAccountsError = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorNoTwitterAccounts userInfo:nil];
    NSError *invalidResponseError = [NSError errorWithDomain:RWTwitterInstantDomain code:RWTwitterInstantErrorInvalidResponse userInfo:nil];
    
    // 2. 创建信号 block
    @weakify(self)
    return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        @strongify(self)
        
        // 3.创建请求
        SLRequest *request = [self requestforTwitterSearchWithText:text];
        
        // 4.请求 twitter 账户
        NSArray *twitterAccounts = [self.accountStore accountsWithAccountType:self.twitterAccountType];
        if (twitterAccounts.count == 0) {
            [subscriber sendError:noAccountsError];
        } else {
            [request setAccount:twitterAccounts.lastObject];
            
            // 5. 执行请求
            [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                if (urlResponse.statusCode == 200) {
                    
                    // 6. 一旦请求成功，解析响应
                    NSDictionary *timelineData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingAllowFragments error:nil];
                    [subscriber sendNext:timelineData];
                    [subscriber sendCompleted];
                } else {
                    // 7. 发送请求失败的错误信号
                    [subscriber sendError:invalidResponseError];
                }
            }];
        }
        
        return nil;
    }];
}

- (BOOL)isValidSearchText:(NSString *)text {
    return text.length > 2;
}

- (void)styleTextField:(UITextField *)textField {
    CALayer *textFieldLayer = textField.layer;
    textFieldLayer.borderColor = [UIColor grayColor].CGColor;
    textFieldLayer.borderWidth = 2.0f;
    textFieldLayer.cornerRadius = 0.0f;
}

@end
