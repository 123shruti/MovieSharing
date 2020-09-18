//
//  MovieDetailViewController.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    
    @IBOutlet weak var fabBarButton: UIBarButtonItem!
    
    var viewModel: MovieDetailViewModel?
    var detailModel: Item?
    var isFavorite : Bool = false
    @IBOutlet weak var detailTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
        
    }
    
    private func setupUI() {
        detailTableView.register(UINib(nibName: String(describing: DetailHeaderTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DetailHeaderTableViewCell.self))
        detailTableView.register(UINib(nibName: String(describing: DetailsDecriptionTableViewCell.self), bundle: nil), forCellReuseIdentifier: String(describing: DetailsDecriptionTableViewCell.self))
        detailTableView.dataSource = self
        
        detailTableView.tableFooterView = UIView(frame: .zero)
        
        viewModel = MovieDetailViewModel()
        viewModel?.detailModel = self.detailModel
        viewModel?.delegate = self
        viewModel?.checkSavedObject()
    }
    
    @IBAction func favButton(_ sender: UIBarButtonItem) {
        if(isFavorite) {
            viewModel?.removeSavedObject()
        
            setFavStatus(isFav: true)
            
        }else{
            guard let item = detailModel else{return}
            viewModel?.saveObject(item: [item])
            
            setFavStatus(isFav: false)
        }
        
    }
    
    private func setFavStatus(isFav:Bool) {
        if(isFav) {
            isFavorite = false
            fabBarButton.image = UIImage(named: "favoriteUnsel")
        } else{
            isFavorite = true
            fabBarButton.image = UIImage(named: "favoriteSel")
        }
    }
    
}

extension MovieDetailViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailHeaderTableViewCell.self), for: indexPath)
            if let detailCell = cell as? DetailHeaderTableViewCell {
                detailCell.setData(records: detailModel)
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: DetailsDecriptionTableViewCell.self), for: indexPath)
            if let detailCell = cell as? DetailsDecriptionTableViewCell {
                detailCell.setData(records: detailModel)
            }
            return cell
        }
        
    }
}

extension MovieDetailViewController : MovieDetailDelegate {
    func updateTable() {
        self.detailTableView.reloadData()
    }
    
    func updateFavoriteStatus(isFav: Bool) {
        self.setFavStatus(isFav: isFav)
    }
    
    
}
