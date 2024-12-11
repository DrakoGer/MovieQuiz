//
//  ArrayTests.swift
//  MovieQuiz
//
//  Created by Yura on 09.12.24.
//


import XCTest
@testable import MovieQuiz // Для импорта нашего приложения

class ArrayTests: XCTestCase {
    func testGetValueInRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        //When
        let value = array[safe: 2]
        //Then
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 2)
    }
    
    func testGetValueOutRange() throws {
        //Given
        let array = [1, 1, 2, 3, 5]
        //When
        let value = array[safe: 20]
        //Then
        XCTAssertNil(value)
    }
    
}
