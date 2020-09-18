//
//  AppEnums.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//


import Foundation

enum MovieViewType {
    case grid
    case list
}

enum APIs: String {
    //case api = "https://www.googleapis.com/youtube/v3/videos?part=snippet%2CcontentDetails%2Cstatistics&chart=mostPopular&regionCode=US&key=AIzaSyALG0HiK7E6qrwXBybjoz6cHPJ8L0p3FmQ"
    case api = "https://www.googleapis.com/youtube/v3/playlists?part=snippet%2CcontentDetails&channelId=UC_x5XG1OV2P6uZZ5FSM9Ttw&maxResults=50&key=AIzaSyALG0HiK7E6qrwXBybjoz6cHPJ8L0p3FmQ"
    
    case apiKey = "AIzaSyALG0HiK7E6qrwXBybjoz6cHPJ8L0p3FmQ"
}
