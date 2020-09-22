//
//  MovieClubTests.swift
//  MovieClubTests
//
//  Created by Mistry, Dharay Paresh on 22/09/20.
//  Copyright © 2020 Mistry, Dharay Paresh. All rights reserved.
//

import XCTest
@testable import MovieClub

class MovieClubTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        let movie1 = Movie(title: "bad boys", id: 0, vote_average: 2, original_language: "en", release_date: "", poster_path: "", overview: "")
        let movie2 = Movie(title: "good boys", id: 0, vote_average: 2, original_language: "en", release_date: "", poster_path: "", overview: "")
        let result = SearchUtility.getSearches(searchString: "boys bad", baseValues: [movie1,movie2])
        assert(result.count == 1)
        assert(result[0].title == movie1.title)
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
