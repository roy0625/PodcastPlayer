//
//  EpisodeViewController.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/26.
//

import UIKit

class EpisodeViewController: UIViewController {
    
    private var viewModel: EpisodeViewModelType!
    
    @IBOutlet weak private var channelTitleLabel: UILabel!
    @IBOutlet weak private var episodeTitleLabel: UILabel!
    @IBOutlet weak private var coverImageView: UIImageView!
    @IBOutlet weak private var summaryTextView: UITextView!
    @IBOutlet weak private var playButton: UIButton!

    static func instantiate(with viewModel: EpisodeViewModelType) -> EpisodeViewController {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "EpisodeViewController") as! EpisodeViewController
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        setupView()
        updateView()
    }
    
    private func setupView() {
        coverImageView.layer.cornerRadius = 10
        coverImageView.clipsToBounds = true
    }
    
    private func updateView() {
        channelTitleLabel.text = viewModel.outputs.channelTitle
        episodeTitleLabel.text = viewModel.outputs.episodeTitle
        coverImageView.kf.setImage(with: URL(string: viewModel.outputs.episodeImageUrl))
        summaryTextView.text = viewModel.outputs.episodeSummary
    }
    
    // MARK: - Button Actions
    @IBAction private func playButtonClick(_ sender: Any) {
        let playerViewModel = PlayerViewModel(channel: viewModel.outputs.channelModel, index: viewModel.outputs.currentIndex)
        let vc = PlayerViewController.instantiate(with: playerViewModel)
        self.present(vc, animated: true, completion: nil)
        
        PlayerManager.shared.changeIndex(viewModel.outputs.currentIndex)
    }
}

extension EpisodeViewController: EpisodeViewModelOutputDelegate {
    func updateData() {
        updateView()
    }
}

