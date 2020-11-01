//
//  HomeTest.swift
//  PodcastPlayerTests
//
//  Created by roy on 2020/11/1.
//

import XCTest

class HomeTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_01_getSuccessData() throws {
        let homeViewModel = HomeViewModel(api: DummyChannelAPI())
        homeViewModel.inputs.refresh()
        
        XCTAssert(homeViewModel.outputs.coverImageUrl == "an image url")
        XCTAssert(homeViewModel.outputs.episodes.count == 2)
        XCTAssert(homeViewModel.outputs.errorMessage == nil)
        
        let episode1 = homeViewModel.outputs.episodes[0]
        XCTAssert(episode1.pubDate == "2020/10/12")
        
        let episode2 = homeViewModel.outputs.episodes[1]
        XCTAssert(episode2.pubDate == "2020/10/19")
    }
    
    func test_02_getFailureData() throws {
        let homeViewModel = HomeViewModel(api: DummyErrorChannelAPI())
        homeViewModel.inputs.refresh()
        
        XCTAssert(homeViewModel.outputs.channelModel == nil)
        XCTAssert(homeViewModel.outputs.errorMessage == "發生了一些錯誤，請稍後再試")
    }
}

class DummyChannelAPI: ChannelAPIType {
    func fetchChannel(completion: @escaping (ChannelModel?, Error?) -> Void) {
        let channel = ChannelModel()
        channel.title = "Hello"
        channel.image = "an image url"
        let episode1 = EpisodeModel()
        episode1.title = "episode 1"
        episode1.pubDate = "Sun, 11 Oct 2020 22:00:25 +0000"
        let episode2 = EpisodeModel()
        episode2.title = "episode 2"
        episode2.pubDate = "Sun, 18 Oct 2020 22:00:14 +0000"
        channel.episodes = [episode1, episode2]
        completion(channel, nil)
    }
}

class DummyErrorChannelAPI: ChannelAPIType {
    func fetchChannel(completion: @escaping (ChannelModel?, Error?) -> Void) {
        completion(nil, NSError())
    }
}
