//
//  EDUPointServicesTests.swift
//  EDUPointServicesTests
//
//  Created by Alan Chu on 1/28/19.
//  Copyright © 2019 Aeta. All rights reserved.
//

import XCTest
import XMLParsing
@testable import EDUPointServices

class EDUPointServicesTests: XCTestCase {
    var decoder: XMLDecoder!
    
    override func setUp() {
        self.decoder = XMLDecoder()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/DD/YYYY"
        dateFormatter.locale = Locale(identifier: "en_US")
        
        decoder.dataDecodingStrategy = .deferredToData
        decoder.dateDecodingStrategy = .formatted(dateFormatter)
    }
    
    func testChildList() throws {
        guard let xml = Bundle(for: type(of: self)).url(forResource: "ChildList", withExtension: "xml") else { XCTFail("Failed to load xml"); return }
        
        let data = try Data(contentsOf: xml)
        let child = try self.decoder.decode(Child.self, from: data)
        
        XCTAssertEqual(child.childName, "John Doe")
        XCTAssertEqual(child.grade, "10")
        XCTAssertEqual(child.organizationName, "Main St. High School")
        XCTAssertEqual(child.studentGU, "ABCDEF-12345-FEDCBA-54321")
    }
}
