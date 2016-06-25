//
//  OEXConfigTests.swift
//  edX
//
//  Created by Akiva Leffert on 1/5/16.
//  Copyright © 2016 edX. All rights reserved.
//

import XCTest
@testable import edX

class EnrollmentConfigTests : XCTestCase {
    
    func testCourseEnrollmentNoConfig() {
        let config = OEXConfig(dictionary:[:])
        XCTAssertEqual(config.courseEnrollmentConfig.type, EnrollmentType.Native)
    }
    
    func testCourseEnrollmentEmptyConfig() {
        let config = OEXConfig(dictionary:["COURSE_ENROLLMENT":[:]])
        XCTAssertEqual(config.courseEnrollmentConfig.type, EnrollmentType.Native)
    }
    
    func testCourseEnrollmentWebview() {
        let sampleSearchURL = "http://example.com/course-search"
        let sampleInfoURLTemplate = "http://example.com/{path_id}"
        
        let configDictionary = [
            "COURSE_ENROLLMENT": [
                "TYPE": "webview",
                "WEBVIEW" : [
                    "COURSE_SEARCH_URL" : sampleSearchURL,
                    "COURSE_INFO_URL_TEMPLATE" : sampleInfoURLTemplate,
                    "SEARCH_BAR_ENABLED" : true
                ]
            ]
        ]
        let config = OEXConfig(dictionary: configDictionary)
        XCTAssertEqual(config.courseEnrollmentConfig.type, EnrollmentType.Webview)
        XCTAssertEqual(config.courseEnrollmentConfig.webviewConfig.searchURL!.absoluteString, sampleSearchURL)
        XCTAssertEqual(config.courseEnrollmentConfig.webviewConfig.courseInfoURLTemplate!, sampleInfoURLTemplate)
        //TODO: re-enable once we figure out the compiler's deal
        // XCTAssertTrue(config.courseEnrollmentConfig.webviewConfig.nativeSearchbarEnabled)
    }

}
