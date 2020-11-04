//
//  PlayerViewController.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/26.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak private var coverImageView: UIImageView!
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var timeSlider: UISlider!
    @IBOutlet weak private var playPauseButton: UIButton!
    @IBOutlet weak private var timeLabel: UILabel!
    @IBOutlet weak private var endTimeLabel: UILabel!
    
    private var viewModel: PlayerViewModelType!
    
    static func instantiate(with viewModel: PlayerViewModelType) -> PlayerViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "PlayerViewController") as! PlayerViewController
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        viewModel.delegate = self
        PlayerManager.shared.delegate = self
        setupView()
        updateView()
    }
    
    private func setupView() {
        timeSlider.isContinuous = false
        
        let thumbImage = UIImage(named: "dot")
        timeSlider.setThumbImage(thumbImage, for: .normal)
        timeSlider.setThumbImage(thumbImage, for: .highlighted)
        timeSlider.setThumbImage(thumbImage, for: .selected)
        timeSlider.setThumbImage(thumbImage, for: .disabled)
        
        coverImageView.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
    }
    
    private func updateView() {
        coverImageView.kf.setImage(with: URL(string: viewModel.outputs.episodeImageUrl))
        titleLabel.text = viewModel.outputs.episodeTitle
    }
    
    private func getTimeString(_ seconds: Double) -> String {
        let min: Int = Int(seconds) / 60
        let sec: Int = Int(seconds) % 60

        var minStr: String
        if min < 10 {
            minStr = "0\(min)"
        } else {
            minStr = "\(min)"
        }

        var secStr: String
        if sec < 10 {
            secStr = "0\(sec)"
        } else {
            secStr = "\(sec)"
        }

        return "\(minStr):\(secStr)"
    }
    
    // MARK: - Button Actions
    @IBAction private func closeButtonClick(_ sender: Any) {
        dismiss(animated: true, completion: {})
    }
    
    @IBAction private func previousButtonClick(_ sender: Any) {
        PlayerManager.shared.previousTrack()
    }
    
    @IBAction private func nextButtonClick(_ sender: Any) {
        PlayerManager.shared.nextTrack()
    }
    
    @IBAction private func playPauseButtonClick(_ sender: Any) {
        PlayerManager.shared.togglePlayPause()
    }
    
    @IBAction private func timeSlderChange(_ sender: UISlider) {
        PlayerManager.shared.seek(to: TimeInterval(sender.value))
    }
}

// MARK: - PlayerViewModelOutputDelegate
extension PlayerViewController: PlayerViewModelOutputDelegate {
    func updateData() {
        updateView()
    }
}

// MARK: - PlayerManagerProtocol
extension PlayerViewController: PlayerManagerProtocol {
    func onEpisodeChange(_ index: Int, duration: Double) {
        timeSlider.minimumValue = 0
        timeSlider.maximumValue = Float(duration)
        endTimeLabel.text = getTimeString(duration)
        
        viewModel.inputs.change(index: index)
    }
   
    func onProgressChange(_ seconds: Double) {
        //print("onProgressChange: \(seconds)")
        let currentTime = getTimeString(seconds)
        timeLabel.text = currentTime
        timeSlider.value = Float(seconds)
    }

    func onRateChange(_ rate: Float) {
        if rate == 0 {
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        }
    }
}
