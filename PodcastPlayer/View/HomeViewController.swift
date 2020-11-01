//
//  HomeViewController.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/26.
//

import UIKit
import Kingfisher

class HomeViewController: UIViewController {
    private var viewModel: HomeViewModelType = HomeViewModel(api: ChannelAPI())
    
    @IBOutlet weak private var errorButton: UIButton!
    @IBOutlet weak private var indicator: UIActivityIndicatorView!
    @IBOutlet weak private var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup UI
        setupView()
        
        // setup viewModel
        viewModel.delegate = self
        viewModel.inputs.refresh()
    }
    
    private func setupView() {
        tableview.tableFooterView = UIView(frame: .zero)
        tableview.delegate = self
        tableview.dataSource = self
        tableview.estimatedRowHeight = 0
        self.tableview.register(UINib(nibName: "EpisodeTableViewCell", bundle: nil), forCellReuseIdentifier: "EpisodeTableViewCell")
        
        errorButton.isHidden = true
    }
    
    private func updateView() {
        if let errorMessage = viewModel.outputs.errorMessage {
            errorButton.setTitle(errorMessage, for: .normal)
            errorButton.isHidden = false
            return
        }
        
        tableview.reloadData()
        
        // setup tableHeaderView
        guard let imageUrl = viewModel.outputs.coverImageUrl else {
            return
        }
        let length = UIScreen.main.bounds.width
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: length, height: length))
        let url = URL(string: imageUrl)
        imageView.kf.setImage(with: url)
        tableview.tableHeaderView = imageView
        
        // setup playerManager
        PlayerManager.shared.setEpisodes(viewModel.outputs.channelModel?.episodes)
    }
    
    // MARK: Actions
    @IBAction func errorButtonClick(_ sender: Any) {
        viewModel.inputs.refresh()
        errorButton.isHidden = true
    }
}

extension HomeViewController: HomeViewModelOutputDelegate {
    func willLoadData() {
        indicator.startAnimating()
    }
    
    func didLoadData() {
        DispatchQueue.main.async { [weak self] in
            self?.indicator.stopAnimating()
            self?.updateView()
        }
    }
}

// MARK: - UITableViewDataSource
extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.outputs.episodes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: EpisodeTableViewCell = tableview.dequeueReusableCell(withIdentifier: "EpisodeTableViewCell") as? EpisodeTableViewCell
        else { fatalError("Get EpisodeTableViewCell fail") }
        
        let episode = viewModel.outputs.episodes[indexPath.row]
        cell.update(model: episode)
        
        return cell
    }
}
 
// MARK: - UITableViewDelegate
extension HomeViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let channel = viewModel.outputs.channelModel else { return }
        let episodeViewModel = EpisodeViewModel(channel: channel, index: indexPath.row)
        let vc = EpisodeViewController.instantiate(with: episodeViewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}

