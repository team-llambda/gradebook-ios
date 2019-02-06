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
    var services: PXPWebServices!
    
    override func setUp() {
        services = PXPWebServices(userID: TestENVs.edupointUserID.value!,
                                  password: TestENVs.edupointPassword.value!,
                                  edupointBaseURL: URL(string: TestENVs.edupointBaseURL.value!)!)
    }
    
    func testProcessWebRequest() {
        let expectation = self.expectation(description: "pxpwebservices")

        services.processWebRequest(methodToRun: .childList, type: Child.self).then { child in
            print(child)
        }.catch { error in
            XCTFail(error.localizedDescription)
        }.always {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3000, handler: nil)
    }
    
    func testGradebook() {
        let expectation = self.expectation(description: "pxpwebservices")
        
        services.processWebRequest(methodToRun: .gradebook(reportingPeriod: 1), type: Gradebook.self).then { gradebook in
            print(gradebook)
        }.catch { error in
            XCTFail(error.localizedDescription)
        }.always {
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 3000, handler: nil)
    }
}
