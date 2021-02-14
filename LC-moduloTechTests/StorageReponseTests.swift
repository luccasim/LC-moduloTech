//
//  StorageReponseTests.swift
//  LC-moduloTechTests
//
//  Created by owee on 14/02/2021.
//

import XCTest
@testable import LC_moduloTech

class StorageReponseTests: XCTestCase {

    func testParsingLocalJSON() throws {
        
        let bundle = Bundle.init(identifier: "fr.test.LC-moduloTech")
        let url = bundle?.url(forResource: "storageReponse.json", withExtension: nil)!
        let data = try Data(contentsOf: url!)
        
        let reponse = try JSONDecoder().decode(StorageWS.StorageReponse.self, from: data)
        
        print(reponse)
        
    }

}
