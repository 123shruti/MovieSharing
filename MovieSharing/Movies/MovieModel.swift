//
//  MovieModel.swift
//  MovieSharing
//
//  Created by Shruti on 18/09/20.
//  Copyright © 2020 Shruti. All rights reserved.
//

import Foundation

enum PhotoRecordState {
    case new
    case downloaded
    case failed
}


// MARK: - MovieModel
class MovieModel: Codable {
    let kind, etag, nextPageToken: String?
    let pageInfo: PageInfo?
    let items: [Item]?
    
    init(kind: String?, etag: String?, nextPageToken: String?, pageInfo: PageInfo?, items: [Item]?) {
        self.kind = kind
        self.etag = etag
        self.nextPageToken = nextPageToken
        self.pageInfo = pageInfo
        self.items = items
    }
}

// MARK: - Item
class Item: Codable {
    let kind: Kind?
    let etag, id: String?
    let snippet: Snippet?
    let contentDetails: ContentDetails?
    var image:Data? = nil
    lazy var imageStatus: PhotoRecordState? = .new
    
    init(kind: Kind?, etag: String?, id: String?, snippet: Snippet?, contentDetails: ContentDetails?) {
        self.kind = kind
        self.etag = etag
        self.id = id
        self.snippet = snippet
        self.contentDetails = contentDetails
    }
}

// MARK: - ContentDetails
class ContentDetails: Codable {
    let itemCount: Int?
    
    init(itemCount: Int?) {
        self.itemCount = itemCount
    }
}

enum Kind: String, Codable {
    case youtubePlaylist = "youtube#playlist"
}

// MARK: - Snippet
class Snippet: Codable {
    let publishedAt: String?
    var publishedDate: Date? = nil
    let channelID: ChannelID?
    let title, snippetDescription: String?
    let thumbnails: Thumbnails?
    let channelTitle: ChannelTitle?
    let localized: Localized?
    
    enum CodingKeys: String, CodingKey {
        case publishedAt
        case channelID = "channelId"
        case title
        case snippetDescription = "description"
        case thumbnails, channelTitle, localized
    }
    
    init(publishedAt: String?, channelID: ChannelID?, title: String?, snippetDescription: String?, thumbnails: Thumbnails?, channelTitle: ChannelTitle?, localized: Localized?) {
        self.publishedAt = publishedAt
        self.channelID = channelID
        self.title = title
        self.snippetDescription = snippetDescription
        self.thumbnails = thumbnails
        self.channelTitle = channelTitle
        self.localized = localized
        
        let dateFormatter = DateFormatter()
        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let date = dateFormatter.date(from:publishedAt ?? "")!
        self.publishedDate = date
    }
}

enum ChannelID: String, Codable {
    case ucX5XG1OV2P6UZZ5FSM9Ttw = "UC_x5XG1OV2P6uZZ5FSM9Ttw"
}

enum ChannelTitle: String, Codable {
    case googleDevelopers = "Google Developers"
}

// MARK: - Localized
class Localized: Codable {
    let title, localizedDescription: String?
    
    enum CodingKeys: String, CodingKey {
        case title
        case localizedDescription = "description"
    }
    
    init(title: String?, localizedDescription: String?) {
        self.title = title
        self.localizedDescription = localizedDescription
    }
}

// MARK: - Thumbnails
class Thumbnails: Codable {
    let thumbnailsDefault, medium, high, standard: Default?
    let maxres: Default?
    
    enum CodingKeys: String, CodingKey {
        case thumbnailsDefault = "default"
        case medium, high, standard, maxres
    }
    
    init(thumbnailsDefault: Default?, medium: Default?, high: Default?, standard: Default?, maxres: Default?) {
        self.thumbnailsDefault = thumbnailsDefault
        self.medium = medium
        self.high = high
        self.standard = standard
        self.maxres = maxres
    }
}

// MARK: - Default
class Default: Codable {
    let url: String?
    let width, height: Int?
    
    init(url: String?, width: Int?, height: Int?) {
        self.url = url
        self.width = width
        self.height = height
    }
}

// MARK: - PageInfo
class PageInfo: Codable {
    let totalResults, resultsPerPage: Int?
    
    init(totalResults: Int?, resultsPerPage: Int?) {
        self.totalResults = totalResults
        self.resultsPerPage = resultsPerPage
    }
}


class SavedMovie: Codable {
    var items: [Item]?
    init(items: [Item]?) {
        self.items = items
    }
}
