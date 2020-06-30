//
//  NewsModelTests.swift
//  NewsAppTests
//
//  Created by Manali Mogre on 30/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import XCTest
@testable import NewsApp
class NewsModelTests: XCTestCase {
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNewsJsonResponse() throws {
        guard
            let path = Bundle.main.path(forResource: "News", ofType: "json")
            else {
                XCTFail("Missing file: News.json")
                return
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: path))
        let response = try JSONDecoder().decode(Articles.self, from: data)
        XCTAssertNotNil(response)
        XCTAssert((response as Any) is Articles)
        
        let newsItems: [News] = response.articles
        let newsItem: News = newsItems.first!
        XCTAssertNotNil(newsItem.author)
        XCTAssertNotNil(newsItem.content)
        XCTAssertNotNil(newsItem.title)
        XCTAssertNotNil(newsItem.description)
        XCTAssertNotNil(newsItem.publishedAt)
        XCTAssertNotNil(newsItem.url)
        XCTAssertNotNil(newsItem.urlToImage)
        XCTAssert((newsItem.author as Any) is String)
        XCTAssert((newsItem.title as Any) is String)
        XCTAssert((newsItem.content as Any) is String)
        XCTAssert((newsItem.description as Any) is String)
        XCTAssert((newsItem.publishedAt as Any) is String)
        XCTAssert((newsItem.url as Any) is String)
        XCTAssert((newsItem.urlToImage as Any) is String)
        
    }
    
}
