//
//  EpisodeViewModel.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/31.
//

import Foundation

protocol EpisodeViewModelInput {
    func change(index: Int)
}

protocol EpisodeViewModelOutputDelegate: AnyObject {
    func updateData()
}

protocol EpisodeViewModelOutput {
    var channelTitle: String { get }
    var episodeImageUrl: String { get }
    var episodeTitle: String { get }
    var episodeSummary: String { get }
    var channelModel: ChannelModel { get }
    var currentIndex: Int { get }
}

protocol EpisodeViewModelType {
    var inputs: EpisodeViewModelInput { get }
    var outputs: EpisodeViewModelOutput { get }
    var delegate: EpisodeViewModelOutputDelegate? { get set }
}

class EpisodeViewModel: EpisodeViewModelType {
    var inputs: EpisodeViewModelInput { return self }
    var outputs: EpisodeViewModelOutput { return self }
    weak var delegate: EpisodeViewModelOutputDelegate?
    
    private var channel: ChannelModel
    private var nowEpisode: EpisodeModel
    private var index: Int
    
    init(channel: ChannelModel, index: Int) {
        self.channel = channel
        self.index = index
        nowEpisode = channel.episodes[index]
    }
}

extension EpisodeViewModel: EpisodeViewModelInput {
    func change(index: Int) {
        self.index = index
        nowEpisode = channel.episodes[index]
        delegate?.updateData()
    }
}

extension EpisodeViewModel: EpisodeViewModelOutput {
    var channelTitle: String {
        return channel.title
    }
    
    var episodeTitle: String {
        return nowEpisode.title
    }
    
    var episodeImageUrl: String {
        return nowEpisode.image
    }
    
    var episodeSummary: String {
        return nowEpisode.summary
    }
    
    var channelModel: ChannelModel {
        return channel
    }
    
    var currentIndex: Int {
        return index
    }
}

