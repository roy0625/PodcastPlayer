//
//  HomeViewModel.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/30.
//

import Foundation


protocol HomeViewModelInput {
    func refresh()
}

protocol HomeViewModelOutputDelegate: AnyObject {
    func willLoadData()
    func didLoadData()
}

protocol HomeViewModelOutput {
    var coverImageUrl: String? { get }
    var episodes: [EpisodeModel] { get }
    var errorMessage: String? { get }
    var channelModel: ChannelModel? { get }
}

protocol HomeViewModelType {
    var inputs: HomeViewModelInput { get }
    var outputs: HomeViewModelOutput { get }
    var delegate: HomeViewModelOutputDelegate? { get set }
}

class HomeViewModel: HomeViewModelType {
    var inputs: HomeViewModelInput { return self }
    var outputs: HomeViewModelOutput { return self }
    weak var delegate: HomeViewModelOutputDelegate?
    
    private var channel: ChannelModel?
    private var error: Error?

    private var channelAPI: ChannelAPIType
    
    init(api: ChannelAPIType) {
        channelAPI = api
    }
    
    private func fetchData() {
        delegate?.willLoadData()
        channelAPI.fetchChannel { [weak self] channelModel, error in
            if let channelModel = channelModel {
                self?.handleChannel(channelModel)
                self?.channel = channelModel
                self?.error = nil
            } else {
                self?.error = error
            }
            self?.delegate?.didLoadData()
        }
    }
    
    private func handleChannel(_ channel: ChannelModel) {
        let newEpisodes = channel.episodes.map { [weak self] model -> EpisodeModel in
            guard let self = self else { return model }
            model.pubDate = self.handleDate(model.pubDate)
            return model
        }
        channel.episodes = newEpisodes
    }
    
    // 把日期轉換成適當的格式
    private func handleDate(_ dateString: String) -> String {
        // string to date
        // Sun, 18 Oct 2020 22:00:14 +0000
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "eee, dddd MMM yyyy HH:mm:ss xx"
        guard let date = dateFormatter.date(from: dateString) else {
            print("get date fail")
            return ""
        }
        
        // date to format string
        dateFormatter.dateFormat = "yyyy/MM/dd"
        dateFormatter.locale = Locale(identifier: "zh_Hant_TW")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Taipei")
        let dateFormatString: String = dateFormatter.string(from: date)
        return dateFormatString
    }
}

extension HomeViewModel: HomeViewModelInput {
    func refresh() {
        fetchData()
    }
}

extension HomeViewModel: HomeViewModelOutput {
    var coverImageUrl: String? {
        return channel?.image
    }
    
    var episodes: [EpisodeModel] {
        return channel?.episodes ?? []
    }
    
    var errorMessage: String? {
        if error != nil {
            return "發生了一些錯誤，請稍後再試"
        }
        return nil
    }
    
    var channelModel: ChannelModel? {
        return channel
    }
}
