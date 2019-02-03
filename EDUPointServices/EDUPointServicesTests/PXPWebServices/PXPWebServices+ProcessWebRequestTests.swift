//
//  PXPWebServices+ProcessWebRequestTests.swift
//  EDUPointServicesTests
//
//  Created by Alan Chu on 1/31/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import XCTest
@testable import EDUPointServices

class PXPWebServices_ProcessWebRequestTests: XCTestCase {
    func testProcessWebRequest() {
        let expectation = self.expectation(description: "pxpwebservices")
        
        let services = PXPWebServices(userID: TestENVs.edupointUserID.value!, password: TestENVs.edupointPassword.value!, edupointBaseURL: URL(string: TestENVs.edupointBaseURL.value!)!)
        services.processWebRequest(methodToRun: .ChildList, parameters: nil, type: Child.self).then { child in
            print(child)
            XCTAssert(child != nil)
        }.catch { error in
            XCTFail(error.localizedDescription)
        }.always {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3000, handler: nil)
    }
}
