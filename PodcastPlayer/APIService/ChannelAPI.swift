//
//  ChannelAPI.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/31.
//

import Foundation

struct User: Codable {
    let id: Int
    let name: String?
    let email: String?
}

protocol ChannelAPIType {
    func fetchChannel(completion: @escaping (ChannelModel?, Error?) -> Void)
}

class ChannelAPI: ChannelAPIType {
    func fetchChannel(completion: @escaping (ChannelModel?, Error?) -> Void) {
        APIService.get(urlString: "https://feeds.soundcloud.com/users/soundcloud:users:322164009/sounds.rss") { result in
            switch result {
            case .success(let data):
                let parser = ChannelParser()
                let channel = parser.parse(data: data)
                completion(channel, nil)
            case .failure(let error):
                completion(nil, error)
            }
        }
    }
}

