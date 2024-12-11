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
        
        //XCUIDevice.shared.orientation = .portrait
        
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
    
    func testYesButton()  {
        sleep(3)
        
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        sleep(3)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
    }
    
    func testNoButton()  {
        sleep(5)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["No"].tap()
        sleep(5)
        
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testGameFinish() {
        sleep(2)
        for _ in 1...10 {
            let noButton = app.buttons["No"]
            sleep(2)
            XCTAssertTrue(noButton.waitForExistence(timeout: 5), "No button does not exist")
            noButton.tap()
        }
        
        let alert = app.alerts["Этот раунд окончен!"]
        XCTAssertTrue(alert.waitForExistence(timeout: 5), "Game results alert did not appear")
        
        let playAgainButton = alert.buttons["Сыграть ещё раз"]
        XCTAssertTrue(playAgainButton.exists, "Play Again button does not exist")
    }

    func testAlertDismiss() {
        sleep(2)
        for _ in 1...10 {
            let noButton = app.buttons["No"]
            sleep(2)
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
