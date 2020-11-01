//
//  PlayerTest.swift
//  PodcastPlayerTests
//
//  Created by roy on 2020/11/1.
//

import XCTest

class PlayerTest: XCTestCase {
    
    let dummyChannel: ChannelModel = {
        let channel = ChannelModel()
        channel.title = "Hello"
        channel.image = "an image url"
        let episode1 = EpisodeModel()
        episode1.title = "episode 1"
        episode1.image = "image1"
        episode1.summary = "some summary1"
        let episode2 = EpisodeModel()
        episode2.title = "episode 2"
        channel.episodes = [episode1, episode2]
        episode2.image = "image2"
        episode2.summary = "some summary2"
        return channel
    }()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_01_initPlayerModel() throws {
        let playerViewModel = PlayerViewModel(channel: dummyChannel, index: 0)
        XCTAssert(playerViewModel.outputs.episodeTitle == "episode 1")
        XCTAssert(playerViewModel.outputs.episodeImageUrl == "image1")
        XCTAssert(playerViewModel.outputs.currentIndex == 0)
    }
    
    func test_02_changeData() throws {
        let playerViewModel = PlayerViewModel(channel: dummyChannel, index: 0)
        playerViewModel.inputs.change(index: 1)
        
        XCTAssert(playerViewModel.outputs.episodeTitle == "episode 2")
        XCTAssert(playerViewModel.outputs.episodeImageUrl == "image2")
        XCTAssert(playerViewModel.outputs.currentIndex == 1)
    }
}
