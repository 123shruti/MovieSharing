//
//  MovieGridTableViewCell.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//

import UIKit

class MovieGridTableViewCell: UITableViewCell {
    
    @IBOutlet weak var moviewCollectionView: UICollectionView!
    let pendingOperations = DownloadingOperations()
    var records : [Item]? = []
    var delegate:MovieGridSelectedCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        setupUI()
    }
    
    private func setupUI() {
        moviewCollectionView.register(UINib(nibName: String(describing: MovieCollectionViewCell.self), bundle: .main), forCellWithReuseIdentifier: String(describing: MovieCollectionViewCell.self))
        moviewCollectionView.dataSource = self
        moviewCollectionView.delegate = self
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func reloadCell() {
        moviewCollectionView.reloadData()
    }
    
}

//MARK: collectionView dataSources & delegates
extension MovieGridTableViewCell: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return records?.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MovieCollectionViewCell.self), for: indexPath)
        if let moviewCell = cell as? MovieCollectionViewCell{
            let item = records?[indexPath.row]
            switch item?.imageStatus {
            case .new:
                break
            case .downloaded, .failed , .none:
                break
            }
            
            moviewCell.setData(record: item)
            if let photo = item {
                startOperations(photoRecord: photo, indexPath: indexPath)
            }
            

        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let item = records?[indexPath.row] {
            delegate?.SelectedCell(item: item)
        }
        
    }
    func startOperations(photoRecord: Item, indexPath: IndexPath) {
        
        if( photoRecord.imageStatus == PhotoRecordState.new) {
            startDownload(photoRecord: photoRecord, at: indexPath)
        }
    }
    
    func startDownload(photoRecord: Item, at indexPath: IndexPath) {
        
        guard pendingOperations.downloadsInProgress[indexPath] == nil else {
            return
        }
        
        let downloader = ImageDownloadManager(model: photoRecord)
        
        downloader.completionBlock = {
            if downloader.isCancelled {
                return
            }
            
            DispatchQueue.main.async {
                self.pendingOperations.downloadsInProgress.removeValue(forKey: indexPath)
                self.moviewCollectionView.reloadData()
                
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}


protocol MovieGridSelectedCellDelegate: AnyObject {
    func SelectedCell(item: Item)
}
