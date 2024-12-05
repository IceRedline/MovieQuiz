//
//  MovieQuizUITests.swift
//  MovieQuizUITests
//
//  Created by Артем Табенский on 29.11.2024.
//

import XCTest

final class MovieQuizUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
        continueAfterFailure = false
    }
    
    override func tearDownWithError() throws {
        app.terminate()
        app = nil
    }
    
    func testYesButton() throws {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        app.buttons["Yes"].tap()
        
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertTrue(firstPoster.exists)
        XCTAssertTrue(secondPoster.exists)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testNoButton() throws {
        sleep(3)
        let firstPoster = app.images["Poster"]
        let firstPosterData = firstPoster.screenshot().pngRepresentation
        
        
        app.buttons["No"].tap()
        
        sleep(3)
        let secondPoster = app.images["Poster"]
        let secondPosterData = secondPoster.screenshot().pngRepresentation
        
        let indexLabel = app.staticTexts["Index"]
        
        XCTAssertTrue(firstPoster.exists)
        XCTAssertTrue(secondPoster.exists)
        XCTAssertNotEqual(firstPosterData, secondPosterData)
        XCTAssertEqual(indexLabel.label, "2/10")
    }
    
    func testAlertAppear() {
        while app.staticTexts["Index"].label != "10/10" {
            sleep(2)
            if app.buttons["Да"].isEnabled{
                app.buttons["Да"].tap()
            }
        }
        sleep(4)
        
        let alertCount = app.alerts.count
        let alertTitle = app.alerts.firstMatch.label
        
        let alertButtonTitle = app.alerts.firstMatch.buttons.firstMatch.label
        
        sleep(2)
        
        XCTAssertGreaterThan(alertCount, 0)
        XCTAssertEqual(alertTitle, "Этот раунд окончен!")
        XCTAssertEqual(alertButtonTitle, "Сыграть еще раз")
        
    }
    
    func testAlertDisappear() {
        while app.staticTexts["Index"].label != "10/10" {
            sleep(2)
            if app.buttons["Да"].isEnabled{
                app.buttons["Да"].tap()
            }
        }
        sleep(4)
        
        app.alerts.firstMatch.buttons.firstMatch.tap()
        
        sleep(3)
        
        let questionNumber = app.staticTexts["Index"].label
        let alertExists = app.alerts.firstMatch.exists
        
        XCTAssertEqual(questionNumber, "1/10")
        XCTAssertEqual(alertExists, false)
        
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
