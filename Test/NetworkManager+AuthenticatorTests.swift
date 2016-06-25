//
//  NetworkManager+AuthenticatorTests.swift
//  edX
//
//  Created by Christopher Lee on 5/23/16.
//  Copyright © 2016 edX. All rights reserved.
//

import Foundation

class NetworkManager_AuthenticationTests : XCTestCase {
    
    func authenticatorResponseForRequest(
        response: NSHTTPURLResponse, data: NSData, session: OEXSession, router: MockRouter, waitForLogout: Bool) -> AuthenticationAction {
        let clientId = "dummy client_id"
        let result = NetworkManager.invalidAccessAuthenticator(router, session: session, clientId: clientId, response: response, data: data)
        
        if waitForLogout {
            expectationForPredicate(NSPredicate(format:"self.logoutCalled == true"), evaluatedWithObject: router, handler: nil)
            waitForExpectations()
        }
        return result
    }
    
    func testAuthenticatorDoesNothing() {
        let router = MockRouter()
        let session = OEXSession()
        let response = simpleResponseBuilder(200)
        let data = "{}".dataUsingEncoding(NSUTF8StringEncoding)!
        let result = authenticatorResponseForRequest(response!, data: data, session: session, router: router, waitForLogout: false)
        XCTAssertTrue(result.isProceed)
        XCTAssertFalse(router.logoutCalled)
    }
    
    func testLogoutWithNoRefreshToken() {
        let router = MockRouter()
        let session = OEXSession()
        let response = simpleResponseBuilder(401)
        let data = "{\"error_code\":\"token_expired\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        let result = authenticatorResponseForRequest(response!, data: data, session: session, router: router, waitForLogout: true)
        XCTAssertTrue(result.isProceed)
        XCTAssertTrue(router.logoutCalled)
    }
    
    func testLogoutForErrorsOtherThanExpiredAccessToken() {
        let router = MockRouter()
        let session = sessionWithRefreshTokenBuilder()
        let response = simpleResponseBuilder(401)
        let data = "{\"error_code\":\"token_nonexistent\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        let result = authenticatorResponseForRequest(response!, data: data, session: session, router: router, waitForLogout: true)
        XCTAssertTrue(result.isProceed)
        XCTAssertTrue(router.logoutCalled)
        
    }
    
    func testLogoutWithNonJSONData() {
        let router = MockRouter()
        let session = OEXSession()
        let response = simpleResponseBuilder(200)
        let data = "I AM NOT A JSON".dataUsingEncoding(NSUTF8StringEncoding)!
        let result = authenticatorResponseForRequest(response!, data: data, session: session, router: router, waitForLogout: false)
        XCTAssertTrue(result.isProceed)
        XCTAssertFalse(router.logoutCalled)
    }
    
    func testExpiredAccessTokenReturnsAuthenticate() {
        let router = MockRouter()
        let session = sessionWithRefreshTokenBuilder()
        let response = simpleResponseBuilder(401)
        let data = "{\"error_code\":\"token_expired\"}".dataUsingEncoding(NSUTF8StringEncoding)!
        let result = authenticatorResponseForRequest(response!, data: data, session: session, router: router, waitForLogout: false)
        XCTAssertTrue(result.isAuthenticate)
    }
    

    func sessionWithRefreshTokenBuilder() -> OEXSession {
        let accessToken = OEXAccessToken()
        accessToken.refreshToken = "dummy refresh token"
        let keychain = OEXMockCredentialStorage()
        keychain.storedAccessToken = accessToken
        keychain.storedUserDetails = OEXUserDetails()
        let session = OEXSession(credentialStore: keychain)
        session.loadTokenFromStore()
        return session
    }
    
    func simpleResponseBuilder(statusCode: Int) -> NSHTTPURLResponse?{
        return NSHTTPURLResponse(
            URL: NSURL(),
            statusCode: statusCode,
            HTTPVersion: nil,
            headerFields: nil)
    }
    
    func simpleRequestBuilder() -> NetworkRequest<JSON> {
        return NetworkRequest<JSON> (
            method: HTTPMethod.GET,
            path: "path",
            deserializer: .JSONResponse({(_, json) in .Success(json)}))
    }
}
