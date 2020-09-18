//
//  FavouritesViewController.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//

import UIKit

class FavouritesViewController: UIViewController {
    
    var searchController: UISearchController?
    @IBOutlet weak var favoriteTableView: UITableView!
    var viewModel: FavoriteViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        
        //Register cells on tableView & CollectionView
        favoriteTableView.register(UINib(nibName: String(describing: MovieListTableViewCell.self), bundle: .main), forCellReuseIdentifier: String(describing: MovieListTableViewCell.self))
        
        favoriteTableView.dataSource = self
        favoriteTableView.delegate = self
        
        viewModel = FavoriteViewModel()
        viewModel?.delegate = self
        
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchBar.placeholder = "search movie title"
        searchController?.searchBar.delegate = self
        searchController?.showsSearchResultsController = true
      
        //self.definesPresentationContext = true
        searchController?.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel?.checkSavedObject()
    }
    
}

//MARK: tableView dataSources & delegates
extension FavouritesViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel?.searchObject?.count ?? 0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieListTableViewCell.self), for: indexPath)
        if let moviewCell = cell as? MovieListTableViewCell{
            moviewCell.setData(record: viewModel?.searchObject?[indexPath.row])
        }
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let item = viewModel?.searchObject?[indexPath.row]
         
        guard let detailObject = self.storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController else {return}
        detailObject.detailModel = item
        self.navigationController?.pushViewController(detailObject, animated: true)
    }
    
}

extension FavouritesViewController: FavoriteDelegate {
    func updateData() {
        
        self.favoriteTableView.reloadData()
    }
    
}
//MARK:- searchBar  delegate
extension FavouritesViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.count > 0 {
            let objects = viewModel?.savedObjects?.items?.filter({($0.snippet?.title ?? "").contains(searchText)})
            self.viewModel?.searchObject = objects
            
        } else {
            self.viewModel?.searchObject = self.viewModel?.savedObjects?.items
        }
        updateData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.viewModel?.searchObject = self.viewModel?.savedObjects?.items
        updateData()
    }
}
