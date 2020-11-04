//
//  PlayerManager.swift
//  PracticePlayer
//
//  Created by Roy Wu on 2020/10/27.
//

import Foundation
import AVFoundation
import MediaPlayer
import Kingfisher

protocol PlayerManagerProtocol: AnyObject {
    func onProgressChange(_ seconds: Double)
    func onRateChange(_ rate: Float)
    func onEpisodeChange(_ index: Int, duration: Double)
}

class PlayerManager: NSObject {
    
    static let shared = PlayerManager()
    private override init() {
        player = AVPlayer()
        super.init()
        
        setupNotificationsAndObserver()
        setupRemoteCommandCenter()
        setAudioSession()
    }
    
    deinit {
        removeNotificationsAndObserver()
    }
    
    private var player: AVPlayer
    
    private var episodes: [EpisodeModel]?
    private var playingIndex: Int = 0
    
    private var timeObserver: Any?
    private var playerObserver: NSKeyValueObservation?
    
    private var playerItemStatusObserver: NSKeyValueObservation?
    private var playerItemErrorObserver: NSKeyValueObservation?
    private var playerItemLoadedTimeObserver: NSKeyValueObservation?
    
    weak var delegate: PlayerManagerProtocol?
    
    
    func setEpisodes(_ episodes: [EpisodeModel]?) {
        self.episodes = episodes
    }
    
    func changeIndex(_ index: Int) {
        playingIndex = index
        setNewPlayerItem(index, isAutoPlay: true)
    }
    
    // MARK: - player operation
    func togglePlayPause() {
        if player.timeControlStatus == .paused {
            play(nil)
        } else {
            player.pause()
            setNowPlayingItemChange(nil, second: nil)
        }
    }
    
    func nextTrack() {
        guard let episodes = episodes else { return }
        
        if (playingIndex + 1) >= episodes.count {
            print("no more track")
            return
        }
        
        playingIndex += 1
        setNewPlayerItem(playingIndex, isAutoPlay: true)
    }
    
    func previousTrack() {
        guard let episodes = episodes else { return }
        
        if (playingIndex - 1) < 0 || (playingIndex - 1) >= episodes.count {
            print("no more track")
            return
        }
        
        playingIndex -= 1
        setNewPlayerItem(playingIndex, isAutoPlay: true)
    }
    
    func seek(to seconds: TimeInterval) {
        player.seek(to: CMTimeMake(value: Int64(seconds), timescale: 1))
        setNowPlayingItemChange(nil, second: seconds)
    }
    
    // MARK: - player settings
    private func setAudioSession() {
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback)
            try session.setActive(true)
        } catch {
            print("audioSession error: \(error)")
        }
    }
    
    private func setupNotificationsAndObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(playToEnd), name: .AVPlayerItemDidPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(failToPlay(toEnd:)), name: .AVPlayerItemFailedToPlayToEndTime, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(playbackStall(_:)), name: .AVPlayerItemPlaybackStalled, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleInterruption(_:)), name: AVAudioSession.interruptionNotification, object: nil)
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: CMTimeMake(value: 1, timescale: 1), queue: DispatchQueue.main, using: { time in
            let seconds: Double = CMTimeGetSeconds(time)
            self.delegate?.onProgressChange(seconds)
        })
        
        playerObserver = player.observe(\.rate, options:  [.new, .old], changeHandler: { [weak self] (player, change) in
            self?.delegate?.onRateChange(player.rate)
        })
    }
    
    private func removeNotificationsAndObserver() {
        NotificationCenter.default.removeObserver(self)
        
        if let timeObserver = timeObserver {
            player.removeTimeObserver(timeObserver)
            self.timeObserver = nil
        }
        
        if let observer = playerObserver {
            observer.invalidate()
            playerObserver = nil
        }
    }
    
    // MARK: - Notification funcs
    @objc private func playToEnd() {
        nextTrack()
    }
    
    @objc private func failToPlay(toEnd notification: Notification?) {
        print("AVPlayerItemFailedToPlayToEndTimeNotification, info: \(notification?.userInfo ?? [:])")
    }
    
    @objc private func playbackStall(_ notification: Notification?) {
        print("AVPlayerItemPlaybackStalledNotification, info: \(notification?.userInfo ?? [:])")
    }
    
    @objc private func handleInterruption(_ notification: Notification?) {
        let typeInt = notification?.userInfo?[AVAudioSessionInterruptionTypeKey] as? UInt ?? 0
        let type = AVAudioSession.InterruptionType(rawValue: typeInt) ?? .ended
        
        switch type {
        case AVAudioSession.InterruptionType.began:
            print("An interuption began.")
        case AVAudioSession.InterruptionType.ended:
            print("An interuption end. \(notification?.userInfo ?? [:])")
        default:
            break
        }
        
        let options = AVAudioSession.InterruptionOptions(rawValue: (notification?.userInfo?[AVAudioSessionInterruptionOptionKey] as? NSNumber)?.uintValue ?? 0)
        if options == AVAudioSession.InterruptionOptions.shouldResume {
            print("Resume")
            play(nil)
        }
    }
    
    // MARK: - playerItem KVO
    private func addPlayerItemObserver(_ playerItem: AVPlayerItem) {
        playerItemStatusObserver = playerItem.observe(\.status, options: [.old, .new], changeHandler: { [weak self] item, change in
            guard let self = self else { return }
            
            switch item.status {
            case .readyToPlay:
                print("Ready to play.")
                self.delegate?.onEpisodeChange(self.playingIndex, duration: CMTimeGetSeconds(item.duration))
            case .failed:
                print("PlayerItem error: \(item.error.debugDescription)")
            case .unknown:
                print("PlayerItem is not ready.")
            default:
                break
            }
        })
    }
    
    private func removePlayerItemObserver(_ playerItem: AVPlayerItem?) {
        playerItemStatusObserver?.invalidate()
        playerItemStatusObserver = nil
    }
    
    // MARK: - play
    private func play(_ episode: EpisodeModel?) {
        player.play()
        setNowPlayingItemChange(episode, second: nil)
    }
    
    private func setNewPlayerItem(_ index: Int, isAutoPlay: Bool)
    {
        if player.currentItem != nil
        {
            removePlayerItemObserver(player.currentItem)
        }
        
        guard let episode = episodes?[index],
              let url = URL(string: episode.url)
        else { return }
        
        let playerItem = AVPlayerItem(url: url)
        
        // add observer
        addPlayerItemObserver(playerItem)
        
        player.replaceCurrentItem(with: playerItem)
        playingIndex = index
        
        if isAutoPlay {
            play(episode)
        }
    }
    
    // MARK: - update nowPlayingInfo
    private func setNowPlayingItemChange(_ episode: EpisodeModel?, second: Double?) {
        var dic: [String : Any] = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [:]
        if let duration = player.currentItem?.asset.duration {
            dic[MPMediaItemPropertyPlaybackDuration] = CMTimeGetSeconds(duration)
        }
        
        if let second = second {
            dic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = second
        } else {
            dic[MPNowPlayingInfoPropertyElapsedPlaybackTime] = CMTimeGetSeconds(player.currentTime())
        }
        
        dic[MPNowPlayingInfoPropertyPlaybackRate] = player.rate
        MPNowPlayingInfoCenter.default().nowPlayingInfo = dic
        
        guard let episode = episode else { return }
        dic[MPMediaItemPropertyTitle] = episode.title
        let resource = ImageResource(downloadURL: URL(string: episode.image)!)
        KingfisherManager.shared.retrieveImage(with: resource) { result in
            switch result {
            case .success(let value):
                var albumArt: MPMediaItemArtwork?
                albumArt = MPMediaItemArtwork(boundsSize: CGSize(width: 100, height: 100), requestHandler: { size in
                    return value.image
                })
                if let albumArt = albumArt {
                    dic[MPMediaItemPropertyArtwork] = albumArt
                }
                MPNowPlayingInfoCenter.default().nowPlayingInfo = dic
                
            case .failure(let error):
                print("Error: \(error)")
            }
        }
    }
    
    // MARK: - setup MPRemoteCommentCenter
    private func setupRemoteCommandCenter() {
        let commandCenter = MPRemoteCommandCenter.shared()
        
        commandCenter.togglePlayPauseCommand.addTarget(handler: { [weak self] event in
            self?.togglePlayPause()
            return .success
        })
        commandCenter.togglePlayPauseCommand.isEnabled = true
        
        // previous and next
        commandCenter.nextTrackCommand.addTarget(handler: { [weak self] event in
            self?.nextTrack()
            return .success
        })
        commandCenter.nextTrackCommand.isEnabled = true
        
        commandCenter.previousTrackCommand.addTarget(handler: { [weak self] event in
            self?.previousTrack()
            return .success
        })
        commandCenter.previousTrackCommand.isEnabled = true
        
        // seek
        commandCenter.changePlaybackPositionCommand.addTarget(handler: { [weak self] event in
            if let positionEvent = event as? MPChangePlaybackPositionCommandEvent
            {
                self?.seek(to: positionEvent.positionTime)
                print("remote seek : \(positionEvent.positionTime)")
            }
            return .success
        })
        commandCenter.changePlaybackPositionCommand.isEnabled = true
    }
}
