//
//  _____Tests.m
//  百思不得姐Tests
//
//  Created by cyz on 16/10/26.
//  Copyright © 2016年 yuze. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "User.h"
#import "NSObject+YZProperty.h"

@interface _____Tests : XCTestCase

@end

@implementation _____Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testYZProperty {
    NSArray *arrray =[User YZproperties];
    NSLog(@"test完成数组=%@",arrray);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
