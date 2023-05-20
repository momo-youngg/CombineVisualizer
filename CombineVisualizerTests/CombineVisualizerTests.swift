//
//  CombineVisualizerTests.swift
//  CombineVisualizerTests
//
//  Created by momo on 2023/05/04.
//

import XCTest
@testable import CombineVisualizer
import Combine

class CombineVisualizerTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        var bag = Set<AnyCancellable>()
        let subject = CZPassthroughSubject(inner: PassthroughSubject<Int, Never>(), uuid: UUID())
        subject
            .czSubscribe(on: DispatchQueue.global(qos: .utility))
            .czReceive(on: DispatchQueue.global(qos: .background))
            .sink { num in print(num) }
            .store(in: &bag)
        
        let date1 = Date().timeIntervalSince1970
        while Date().timeIntervalSince1970 - date1 < 3 { }

        subject.send(1)
        subject.send(2)
        subject.send(3)
        
        let date2 = Date().timeIntervalSince1970
        while Date().timeIntervalSince1970 - date2 < 3 { }
        bag.removeAll()
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
}
