//
//  iOS_Maps_TestTests.m
//  iOS Maps TestTests
//
//  Created by kumaran V on 21/02/17.
//  Copyright © 2017 Kumaran. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "FirstViewController.h"
@interface iOS_Maps_TestTests : XCTestCase
@property (nonatomic) FirstViewController *mapViewController;
@end

@implementation iOS_Maps_TestTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    NSLog(@"test Begin");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}
- (void)testJsonWrite {
    CLLocationCoordinate2D location;;
    location.latitude=19.14;
    location.longitude=73.10;
    BOOL result = [self.mapViewController writeToJSON:location withTitle:@"Test"];
    XCTAssertEqual((BOOL)TRUE, result, @"Json write failed!");
}
- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
