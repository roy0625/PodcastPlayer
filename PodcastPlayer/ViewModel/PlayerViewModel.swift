//
//  PlayerViewModel.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/31.
//

import Foundation

protocol PlayerViewModelInput {
    func change(index: Int)
}

protocol PlayerViewModelOutputDelegate: AnyObject {
    func updateData()
}

protocol PlayerViewModelOutput {
    var episodeImageUrl: String { get }
    var episodeTitle: String { get }
    var currentIndex: Int { get }
}

protocol PlayerViewModelType {
    var inputs: PlayerViewModelInput { get }
    var outputs: PlayerViewModelOutput { get }
    var delegate: PlayerViewModelOutputDelegate? { get set }
}

class PlayerViewModel: PlayerViewModelType {
    var inputs: PlayerViewModelInput { return self }
    var outputs: PlayerViewModelOutput { return self }
    weak var delegate: PlayerViewModelOutputDelegate?
    
    private var channel: ChannelModel
    private var nowEpisode: EpisodeModel
    private var index: Int
    
    init(channel: ChannelModel, index: Int) {
        self.channel = channel
        self.index = index
        nowEpisode = channel.episodes[index]
    }
}

extension PlayerViewModel: PlayerViewModelInput {
    func change(index: Int) {
        self.index = index
        nowEpisode = channel.episodes[index]
        delegate?.updateData()
    }
}

extension PlayerViewModel: PlayerViewModelOutput {
    var episodeTitle: String {
        return nowEpisode.title
    }
    
    var episodeImageUrl: String {
        return nowEpisode.image
    }
    
    var currentIndex: Int {
        return index
    }
}

