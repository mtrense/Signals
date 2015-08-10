//
//  SignalsTests.swift
//  SignalsTests
//
//  Created by Tuomas Artman on 16.10.2014.
//  Copyright (c) 2014 Tuomas Artman. All rights reserved.
//

import UIKit
import XCTest

class SignalQueueTests: XCTestCase {
    
    var emitter:SignalEmitter = SignalEmitter();
    
    override func setUp() {
        super.setUp()
        emitter = SignalEmitter()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testBasicFiring() {
        let expectation = expectationWithDescription("queuedDispatch")

        emitter.onInt.listen(self, callback: { (argument) in
            XCTAssertEqual(argument, 1, "Last data catched")
            expectation.fulfill()
        }).queueAndDelayBy(0.1)

        emitter.onInt.fire(1);

        waitForExpectationsWithTimeout(0.15, handler: nil)
    }
    
    func testDispatchQueueing() {
        let expectation = expectationWithDescription("queuedDispatch")
 
        emitter.onInt.listen(self, callback: { (argument) in
            XCTAssertEqual(argument, 3, "Last data catched")
            expectation.fulfill()
        }).queueAndDelayBy(0.1)
        
        emitter.onInt.fire(1);
        emitter.onInt.fire(2);
        emitter.onInt.fire(3);
        
        waitForExpectationsWithTimeout(0.15, handler: nil)
    }
    
    func testNoQueueTimeFiring() {
        let expectation = expectationWithDescription("queuedDispatch")

        emitter.onInt.listen(self, callback: { (argument) in
            XCTAssertEqual(argument, 3, "Last data catched")
            expectation.fulfill()
        }).queueAndDelayBy(0.0)
        
        emitter.onInt.fire(1);
        emitter.onInt.fire(2);
        emitter.onInt.fire(3);
        
        waitForExpectationsWithTimeout(0.05, handler: nil)
    }
    
    func testConditionalListening() {
        let expectation = expectationWithDescription("queuedDispatch")
        
        emitter.onIntAndString.listen(self, callback: { (argument1, argument2) -> Void in
            XCTAssertEqual(argument1, 2, "argument1 catched")
            XCTAssertEqual(argument2, "test2", "argument2 catched")
            expectation.fulfill()
            
        }).queueAndDelayBy(0.01).filter { $0 == 2 && $1 == "test2" }
        
        emitter.onIntAndString.fire((intArgument:1, stringArgument:"test"))
        emitter.onIntAndString.fire((intArgument:1, stringArgument:"test2"))
        emitter.onIntAndString.fire((intArgument:2, stringArgument:"test2"))
        emitter.onIntAndString.fire((intArgument:1, stringArgument:"test3"))
        
        waitForExpectationsWithTimeout(0.02, handler: nil)
    }
    
    func testCancellingListeners() {
        let expectation = expectationWithDescription("queuedDispatch")
        
        let listener = emitter.onIntAndString.listen(self, callback: { (argument1, argument2) -> Void in
            XCTFail("Listener should have been canceled")
        }).queueAndDelayBy(0.01)
        
        emitter.onIntAndString.fire((intArgument:1, stringArgument:"test"))
        emitter.onIntAndString.fire((intArgument:1, stringArgument:"test"))
        listener.cancel()
        
        dispatch_after( dispatch_time(DISPATCH_TIME_NOW, Int64(0.05 * Double(NSEC_PER_SEC))), dispatch_get_main_queue()) {
            // Cancelled listener didn't dispatch
            expectation.fulfill()
        }
        waitForExpectationsWithTimeout(0.1, handler: nil)
    }
    
    func testListeningNoData() {
        let expectation = expectationWithDescription("queuedDispatch")
        var dispatchCount = 0

        emitter.onNoParams.listen(self, callback: { () -> Void in
            dispatchCount++
            XCTAssertEqual(dispatchCount, 1, "Dispatched only once")
            expectation.fulfill()
        }).queueAndDelayBy(0.01)
        
        emitter.onNoParams.fire()
        emitter.onNoParams.fire()
        emitter.onNoParams.fire()
        
        waitForExpectationsWithTimeout(0.05, handler: nil)
    }
}
