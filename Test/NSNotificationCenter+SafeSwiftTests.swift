//
//  NSNotificationCenter+SafeSwiftTests.swift
//  edX
//
//  Created by Akiva Leffert on 6/22/15.
//  Copyright (c) 2015 edX. All rights reserved.
//

import edX
import UIKit
import XCTest

class NSNotificationCenter_SafeSwiftTests: XCTestCase {
    
    private let TestNotificationName = "NSNotificationCenter_SafeSwiftTests"
    
    func testActionFires() {
        let fired = MutableBox<Bool>(false)
        let removable = addNotificationObserver(self, name: TestNotificationName) { (notification, observer, removable) -> Void in
            fired.value = true
        }
        NSNotificationCenter.defaultCenter().postNotificationName(TestNotificationName, object: nil)
        XCTAssertTrue(fired.value)
        removable.remove()
    }
    
    func testClearedOnDealloc() {
        let fired = MutableBox<Bool>(false)
        func make() {
            let object = NSObject()
            addNotificationObserver(object, name: TestNotificationName) { (_, _, _) -> Void in
                fired.value = true
            }
        }
        
        make()
        NSNotificationCenter.defaultCenter().postNotificationName(TestNotificationName, object: nil)
        XCTAssertFalse(fired.value)
    }
    
    func testManualRemove() {
        let fired = MutableBox<Bool>(false)
        let removable = addNotificationObserver(self, name: TestNotificationName) { (notification, observer, removable) -> Void in
            fired.value = true
        }
        removable.remove()
        NSNotificationCenter.defaultCenter().postNotificationName(TestNotificationName, object: nil)
        XCTAssertFalse(fired.value)
    }
    
}
