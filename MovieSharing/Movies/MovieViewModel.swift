//
//  MovieViewModel.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//

import Foundation

class MovieViewModel {
    var viewType: MovieViewType = .grid
    weak var delegate: MovieProtocol?
    var OldRecords: [Item]?
    var latestRecord: [Item]?
    let pendingOperations = DownloadingOperations()
    
    func fetchData() {
        
        WebServices.requestHttp(urlString: APIs.api.rawValue, method: .Get, param: nil, decode: { (json) -> MovieModel? in
            guard let response = json as? MovieModel else{
                return nil
            }
            return response
            
        }) { [weak self] (result) in
            
            switch result {
            case .success(let list) :
                print(list?.items?.count ?? 0)//all 50
                let getDate = list?.items?.first?.snippet?.publishedAt?.components(separatedBy: "T")
                let dates = getDate?.first?.components(separatedBy: "-")
                let latestDate = (dates?.first ?? "") + "-" + (dates?[1] ?? "")
                self?.OldRecords = list?.items
                
                self?.latestRecord = list?.items?.filter({($0.snippet?.publishedAt?.contains(latestDate))!})
                print(self?.latestRecord?.count ?? 0)//new 3
                self?.latestRecord?.forEach { (item) in
                    
                    self?.OldRecords?.removeAll(where: {$0.id == item.id})
                    
                }
                
                print(self?.OldRecords?.count ?? 0)//old 47
                
                // self?.records = list
                self?.delegate?.updateData()
            case .failure(let error) :
                print(error.localizedDescription)
                
                break
            }
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
                self.delegate?.updateData()
                
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
    
    func filterData()  {
        
    }
}


//protocol to update data on view

protocol MovieProtocol:AnyObject {
    func updateData()
}
