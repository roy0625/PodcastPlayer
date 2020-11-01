//
//  EpisodeTableViewCell.swift
//  PodcastPlayer
//
//  Created by roy on 2020/10/26.
//

import UIKit
import Kingfisher

class EpisodeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var coverImage: UIImageView!
    
    func update(model: EpisodeModel) {
        titleLabel.text = model.title
        dateLabel.text = model.pubDate
        let url = URL(string: model.image)
        coverImage.kf.setImage(with: url)
    }
}
