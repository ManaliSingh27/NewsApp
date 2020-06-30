//
//  NetworkManagerTests.swift
//  NewsAppTests
//
//  Created by Manali Mogre on 30/06/2020.
//  Copyright © 2020 Manali Mogre. All rights reserved.
//

import XCTest
@testable import NewsApp

class NetworkManagerTests: XCTestCase {

    var networkManager : NetworkManager!
          let mockSession = MockURLSession()
          var newData : Data!

          override func setUp() {
              // Put setup code here. This method is called before the invocation of each test method in the class.
              super.setUp()
              networkManager = NetworkManager(session: mockSession)
          }
          

          override func tearDown() {
              // Put teardown code here. This method is called after the invocation of each test method in the class.
          }

          func test_correct_url_called()
          {
            let url = UrlEndpoint.getNewsUrl(query: "nl").url
              networkManager.downloadData(url: url!, completion: {_ in
                  
              })
              XCTAssert(mockSession.lastUrl == url)
          }
         
          func test_Resume_Called()
          {
              let dataTask = MockURLSessionDataTask()
              mockSession.nextDataTask = dataTask
            let url = UrlEndpoint.getNewsUrl(query: "nl").url
              networkManager.downloadData(url: url!, completion: {_ in
              })
              XCTAssert(dataTask.resumeWasCalled == true)
          }
          
          func test_get_data()
          {
            let url = UrlEndpoint.getNewsUrl(query: "nl").url
              let exp = expectation(description: "Wait for url to load.")

              let networkManager = NetworkManager(session: URLSession.shared)
              networkManager.downloadData(url: url!, completion: {[weak self](result)  in
                  switch(result)
                  {
                  case .Success(let data):
                      self!.newData = data
                      exp.fulfill()

                  case .Error(let string):
                      print(string)
                  }
              })
              waitForExpectations(timeout: 5, handler: nil)
              XCTAssertNotNil(newData)
          }


}
