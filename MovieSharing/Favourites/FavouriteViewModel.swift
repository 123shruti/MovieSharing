//
//  FavoriteViewModel.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//

import Foundation

class FavoriteViewModel {
    var savedObjects: SavedMovie?
     var searchObject: [Item]?
    var delegate: FavoriteDelegate?
    func checkSavedObject() {
        do{
            let decoder = JSONDecoder()
            if let data  = UserDefaults.standard.data(forKey: "favorites") {
                let objects = try decoder.decode(SavedMovie.self, from: data)
                self.savedObjects = objects
                self.searchObject = objects.items
                self.delegate?.updateData()
            }
            
        } catch let err {
            print(err.localizedDescription)
        }
    }
}


protocol FavoriteDelegate:AnyObject {
    func updateData()
}
