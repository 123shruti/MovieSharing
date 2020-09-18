//
//  MovieDetailViewModel.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//
import Foundation


class MovieDetailViewModel {
    let pendingOperations = DownloadingOperations()
    var detailModel: Item?
    var delegate: MovieDetailDelegate?
     func saveObject(item: [Item]) {
         let savingObject = SavedMovie(items: item)
        do {
            let encoder = JSONEncoder()
            let decoder = JSONDecoder()
            if let data  = UserDefaults.standard.data(forKey: "favorites") {
                 let objects = try decoder.decode(SavedMovie.self, from: data)
                savingObject.items?.append(contentsOf: objects.items ?? [])
            }
            
            let object = try encoder.encode(savingObject)
            
            UserDefaults.standard.set(object, forKey: "favorites")
            UserDefaults.standard.synchronize()
        }catch let error {
            print(error.localizedDescription)
        }
    }
    
    func removeSavedObject() {
        do{
            let decoder = JSONDecoder()
            if let data  = UserDefaults.standard.data(forKey: "favorites") {
                let objects = try decoder.decode(SavedMovie.self, from: data)
                let isSaved = objects.items?.filter({$0.id == detailModel?.id})
                objects.items?.removeAll(where: {$0.id == detailModel?.id})
                let encoder = JSONEncoder()
                let object = try encoder.encode(objects)
                
                UserDefaults.standard.set(object, forKey: "favorites")
                UserDefaults.standard.synchronize()
                
                if(isSaved?.count ?? 0 > 0) {
                    self.delegate?.updateFavoriteStatus(isFav: false)
                } else {
                     self.delegate?.updateFavoriteStatus(isFav: true)
                }
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
    }
    
     func checkSavedObject() {
        do{
            let decoder = JSONDecoder()
            if let data  = UserDefaults.standard.data(forKey: "favorites") {
                let objects = try decoder.decode(SavedMovie.self, from: data)
                let isSaved = objects.items?.filter({$0.id == detailModel?.id})
                if(isSaved?.count ?? 0 > 0) {
                    self.delegate?.updateFavoriteStatus(isFav: false)
                } else {
                     self.delegate?.updateFavoriteStatus(isFav: true)
                }
            }
            
        } catch let err {
            print(err.localizedDescription)
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
                self.delegate?.updateTable()
                
            }
        }
        
        pendingOperations.downloadsInProgress[indexPath] = downloader
        pendingOperations.downloadQueue.addOperation(downloader)
    }
}
protocol MovieDetailDelegate: AnyObject {
    func updateTable()
    func updateFavoriteStatus(isFav: Bool)
}
