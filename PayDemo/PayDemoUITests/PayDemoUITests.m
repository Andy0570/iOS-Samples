//
//  PayDemoUITests.m
//  PayDemoUITests
//
//  Created by Qilin Hu on 2019/8/5.
//  Copyright © 2019 Qilin Hu. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "PayDemoUITests-Swift.h"

@interface PayDemoUITests : XCTestCase

@end

@implementation PayDemoUITests

- (void)setUp {
    // Put setup code here. This method is called before the invocation of each test method in the class.

    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;

    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    [Snapshot setupSnapshot:app];
    [app launch];
    

    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElementQuery *elementsQuery = [app.scrollViews[@"intro_scroll"].otherElements containingType:XCUIElementTypeButton identifier:@", "];
    [[[[elementsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@", "] elementBoundByIndex:0] tap];
    [[[[elementsQuery childrenMatchingType:XCUIElementTypeButton] matchingIdentifier:@", "] elementBoundByIndex:1] tap];
    
    
    [app.buttons[@"\u7acb\u5373\u4f53\u9a8c"] tap];
    [Snapshot snapshot:@"01LoginScreen" timeWaitingForIdle:10];
    
    [app.tables.staticTexts[@"\u8ba2\u5355\u793a\u4f8b\u9875\u9762"] tap];
    [Snapshot snapshot:@"02LoginScreen" timeWaitingForIdle:10];
    
    [app.navigationBars[@"\u652f\u4ed8\u8ba2\u5355"].buttons[@"\u9996\u9875"] tap];
    
}

@end
