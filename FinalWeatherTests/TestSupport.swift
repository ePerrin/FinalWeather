//
//  TestSupport.swift
//  FinalWeather
//
//  Created by Emeric Perrin on 01/02/2017.
//  Copyright © 2017 Emeric. All rights reserved.
//

import XCTest

enum DBError: Error, Equatable {
    case cannotBeEmpty(message: String)
}

func ==(lhs: DBError, rhs: DBError) -> Bool {
    switch (lhs, rhs) {
    case (.cannotBeEmpty(let leftMessage), .cannotBeEmpty(let rightMessage)):
        return leftMessage == rightMessage
    }
}

func XCTAssertThrows<T: Error>(_ error: T, block: () throws -> ()) where T: Equatable {
    do {
        try block()
    }
    catch let e as T {
        XCTAssertEqual(e, error)
    }
    catch {
        XCTFail("Wrong error")
    }
}
