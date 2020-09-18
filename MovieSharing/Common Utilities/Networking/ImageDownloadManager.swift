//
//  ImageDownloadManager.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//


import Foundation
import UIKit

var imageCache = NSCache<NSString, UIImage>()

class DownloadingOperations {
    lazy var downloadsInProgress: [IndexPath: Operation] = [:]
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Downloading_queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
}

class ImageDownloadManager: Operation {
    
    let  photoModel:Item!
    
    init( model: Item) {
        self.photoModel = model
    }
    
    override func main() {
        
        if isCancelled {
            return
        }
        let url = self.photoModel.snippet?.thumbnails?.medium?.url ?? ""
        
        // check cached image
        
        guard let imgURL = URL(string: url) else { return }
        let key = imgURL.absoluteString as NSString
        
        if let cachedImage = imageCache.object(forKey: key)  {
            self.photoModel.image = cachedImage.pngData()
            self.photoModel.imageStatus = PhotoRecordState.downloaded
            return
        }
        
        
        guard let imageData = try? Data(contentsOf: imgURL) else { return }
        
        if isCancelled {
            return
        }
        
        
        if !imageData.isEmpty {
            guard let image = UIImage(data: imageData) else{return}
            DispatchQueue.main.async {
                imageCache.setObject(image, forKey: key )
            }
            
            photoModel.image = image.pngData()
            photoModel.imageStatus = PhotoRecordState.downloaded
        } else {
            photoModel.imageStatus = PhotoRecordState.failed
            //photoModel.image = UIImage(named: "splash")
        }
    }
}
