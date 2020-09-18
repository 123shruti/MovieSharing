//
//  DetailHeaderTableViewCell.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//

import UIKit

class DetailHeaderTableViewCell: UITableViewCell {
    @IBOutlet weak var backPosterImageView: UIImageView!
    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var totalViewsLabel: UILabel!
    @IBOutlet weak var rateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    private func setupUI() {
        posterImage.layer.cornerRadius = 6
        posterImage.layer.masksToBounds = true
        
        posterView.layer.shadowColor = UIColor.darkGray.cgColor
        posterView.layer.shadowOpacity = 0.5
        posterView.layer.shadowOffset = CGSize(width: 0, height: 4)
        posterView.layer.shadowRadius = 4
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(records: Item?) {
        titleLable.text = records?.snippet?.title
        totalViewsLabel.text = "\(records?.contentDetails?.itemCount ?? 0) Items"
        rateLabel.text = "9.7"
        
        if let imageData = records?.image {
            posterImage.image = UIImage(data: imageData)
            backPosterImageView.image = posterImage.image
        }
    }
    
}
