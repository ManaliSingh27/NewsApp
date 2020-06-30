//
//  HelperTests.swift
//  NewsAppTests
//
//  Created by Manali Mogre on 30/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import XCTest
@testable import NewsApp

class HelperTests: XCTestCase {

    override func setUp() {
        ImageCache.saveImage(image: UIImage(named: "NewsPlaceholder"), url:URL(string: "www.testurl.com")! )
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testCacheGetImage() {
        let image: UIImage? = ImageCache.getImage(url: URL(string: "www.testurl.com")!)
        XCTAssertNotNil(image)
    }
    
    func testUrlEnpoint() {
        let url:URL? = UrlEndpoint.getNewsUrl(query: "nl").url
        XCTAssertNotNil(url)
        XCTAssertEqual(url?.absoluteString, "https://newsapi.org/v2/top-headlines?country=nl")
        
    }
    
    func testDateFormatter() {
        let dateString = "2020-06-30T15:55:49Z"
        let formattedDateString: String? = dateString.dateFormattedString
        XCTAssertNotNil(formattedDateString)
        XCTAssertEqual(formattedDateString, "Jun 30,2020")
    }
}
