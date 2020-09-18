//
//  MovieListTableViewCell.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//

import UIKit

class MovieListTableViewCell: UITableViewCell {

    @IBOutlet weak var posterView: UIView!
    @IBOutlet weak var posterImage: UIImageView!
    @IBOutlet weak var posterTitle: UILabel!
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
        posterView.layer.shadowOffset = CGSize(width: 0, height: 8)
        posterView.layer.shadowRadius = 8
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setData(record: Item?) {
        posterTitle.text = record?.snippet?.title
        if let imageData = record?.image {
             posterImage.image = UIImage(data: imageData)
        }
       
    }
}
