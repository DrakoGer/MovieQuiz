//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Yura on 10.12.24.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!

    override func setUpWithError() throws {
        try super.setUpWithError()
        
        app = XCUIApplication()
        app.launch()
        
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        if let app = app {
            app.terminate()
        }
        app = nil
    }
    
    func testYesButton() {
        
        let firstPoster = app.images["Poster"] // для нахождения первого постера
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        app.buttons["Yes"].tap() // чтоб найти кнопку "Да" и нажать на нее
        let secondPoster = app.images["Poster"] // ещё раз находим постер уже следующий постер
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertEqual(firstPosterData, secondPosterData)// проверяем, что постеры разные
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() {
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
                
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "1/10")
    }
    
    func testGameFinish() {
        for _ in 1...10 {
            let noButton = app.buttons["No"]
            XCTAssertTrue(noButton.waitForExistence(timeout: 5), "No button does not exist")
            noButton.tap()
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Game results alert did not appear")
        
        let playAgainButton = alert.buttons["Сыграть ещё раз"]
        XCTAssertTrue(playAgainButton.exists, "Play Again button does not exist")
    }

    func testAlertDismiss() {
        for _ in 1...10 {
            let noButton = app.buttons["No"]
            XCTAssertTrue(noButton.waitForExistence(timeout: 5), "No button does not exist")
            noButton.tap()
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Game results alert did not appear")
        
        let playAgainButton = alert.buttons["Сыграть ещё раз"]
        playAgainButton.tap()
        
        let indexLabel = app.staticTexts["Index"]
        XCTAssertTrue(indexLabel.waitForExistence(timeout: 5), "Index label does not exist")
        XCTAssertEqual(indexLabel.label, "1/10")
    }

}
