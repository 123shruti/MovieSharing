//
//  MovieViewController.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//

import UIKit

class MovieViewController: UIViewController {

    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var movieTableView: UITableView!
    var viewModel: MovieViewModel!
    let pendingOperations = DownloadingOperations()

    var loaderView: LoaderView!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupUI()
    }
    
    private func setupUI() {
        //set title color in segment
        let titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.black]
        segmentedControl.setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        segmentedControl.setTitleTextAttributes(titleTextAttributes, for: .selected)
        
        //Register cells on tableView & CollectionView
        movieTableView.register(UINib(nibName: String(describing: MovieGridTableViewCell.self), bundle: .main), forCellReuseIdentifier: String(describing: MovieGridTableViewCell.self))
        movieTableView.register(UINib(nibName: String(describing: MovieListTableViewCell.self), bundle: .main), forCellReuseIdentifier: String(describing: MovieListTableViewCell.self))
        
        movieTableView.dataSource = self
        movieTableView.delegate = self
        segmentedControl.selectedSegmentIndex = 0
        viewModel = MovieViewModel()
        viewModel.delegate = self
        viewModel.fetchData()
        
        loaderView = LoaderView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        loaderView.loader.startAnimating()
        self.view.addSubview(loaderView)
        
    }
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        viewModel.viewType = sender.selectedSegmentIndex == 0 ? MovieViewType.grid : MovieViewType.list
        movieTableView.reloadData()
    }
    
}
//MARK: tableView dataSources & delegates
extension MovieViewController: UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2 //new & old movies
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Latest Videos"
        }else {
            return "Previous Videos"
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.viewType == .list {
            if(section == 0) {
                return viewModel.latestRecord?.count ?? 0
            }
            return viewModel?.OldRecords?.count ?? 0
        } else {
            return 1
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var item: Item?
        var gridRecords:Array<Item> = []
        if(indexPath.section == 0) {
            gridRecords = viewModel.latestRecord ?? []
            item = viewModel.latestRecord?[indexPath.row]
        } else {
            gridRecords = viewModel.OldRecords ?? []
            item = viewModel.OldRecords?[indexPath.row]
        }
        
        if(viewModel.viewType == .grid) {
            
            let cellGrid = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieGridTableViewCell.self), for: indexPath)
            
            if let movieCell = cellGrid as? MovieGridTableViewCell{
                movieCell.records = gridRecords
                movieCell.delegate = self
                movieCell.reloadCell()
            }
            return cellGrid
            
        } else {
            
            let cellList = tableView.dequeueReusableCell(withIdentifier: String(describing: MovieListTableViewCell.self), for: indexPath)
            
            if let moviewCell = cellList as? MovieListTableViewCell{
                switch item?.imageStatus {
                case .new:
                    break
                case .downloaded, .failed , .none:
                    break
                }
                
                moviewCell.setData(record: item)
                
                if let photo = item{
                    viewModel?.startOperations(photoRecord: photo, indexPath: indexPath)
                }
            }
            return cellList
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
         var item: Item?
         if(viewModel.viewType == .grid) {
            if indexPath.section == 0 {
                item = viewModel?.latestRecord?[indexPath.row]
            } else {
                item = viewModel?.OldRecords?[indexPath.row]
            }
         } else {
            if indexPath.section == 0 {
                item = viewModel?.latestRecord?[indexPath.row]
            } else {
                item = viewModel?.OldRecords?[indexPath.row]
            }
        }
        
        guard let detailObject = self.storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController else {return}
        detailObject.detailModel = item
        self.navigationController?.pushViewController(detailObject, animated: true)
        
        
    }
}


extension MovieViewController: MovieProtocol,MovieGridSelectedCellDelegate {
    func SelectedCell(item: Item) {
        guard let detailObject = self.storyboard?.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController else {return}
        detailObject.detailModel = item
        self.navigationController?.pushViewController(detailObject, animated: true)
    }
    
    func updateData() {
        
        DispatchQueue.main.async {
            self.movieTableView.reloadData()
            self.loaderView.removeFromSuperview()
        }
    }
}
