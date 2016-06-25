//
//  UserAgentGenerationOperation.swift
//  edX
//
//  Created by Akiva Leffert on 12/10/15.
//  Copyright © 2015 edX. All rights reserved.
//

import XCTest
@testable import edX

class UserAgentGenerationOperationTests : XCTestCase {
    func testLoadBasic() {
        let queue = NSOperationQueue()
        let operation = UserAgentGenerationOperation()
        queue.addOperation(operation)
        waitForStream(operation.t_resultStream) {
            let agent = $0.value!
            // Random part of the standard user agent string, to make sure we got something
            XCTAssertTrue(agent.containsString("KHTML, like Gecko"))
        }
    }
    
    func testOverride() {
        let userDefaults = OEXMockUserDefaults()
        let userDefaultsMock = userDefaults.installAsStandardUserDefaults()
        let expectation = expectationWithDescription("User agent overriden")
        UserAgentOverrideOperation.overrideUserAgent {
            expectation.fulfill()
        }
        waitForExpectations()
        
        let queue = NSOperationQueue()
        let operation = UserAgentGenerationOperation()
        queue.addOperation(operation)
        waitForStream(operation.t_resultStream) {
            let agent = $0.value!
            // Random part of the standard user agent string, to make sure we got something
            XCTAssertTrue(agent.containsString(UserAgentGenerationOperation.appVersionDescriptor))
        }

        userDefaultsMock.remove()
    }
}