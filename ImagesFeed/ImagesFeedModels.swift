//
//  ImagesFeedModels.swift
//  ImagesFeed
//
//  Created by Илья Бочков on 10.06.24.
//

import Foundation

struct CuratedPhotoLinks: Decodable, Equatable, Hashable {
    let medium: URL
    let original: URL
}

struct CuratedPhoto: Decodable, Identifiable, Equatable, Hashable {
    let photographerName: String
    let links: CuratedPhotoLinks
    let id: String
    
    init(from decoder: Decoder, pageIndex: Int) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let apiID = try container.decode(Int.self, forKey: .apiID)
        self.photographerName = try container.decode(String.self, forKey: .photographerName)
        self.links = try container.decode(CuratedPhotoLinks.self, forKey: .links)
        // Заметил, что апи иногда присылает на разных страницах одинаковые модельки картинки
        // Одинаковые id ломают коллекцию, поэтому добавляю к id картинки номер страницы
        // В реальном проекте вместо этого стоило бы просто подправить апи)
        self.id = "\(pageIndex)\(apiID)"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let apiID = try container.decode(Int.self, forKey: .apiID)
        self.photographerName = try container.decode(String.self, forKey: .photographerName)
        self.links = try container.decode(CuratedPhotoLinks.self, forKey: .links)
        self.id = String(apiID)
    }
    
    private enum CodingKeys: String, CodingKey {
        case apiID = "id"
        case photographerName = "photographer"
        case links = "src"
    }
}

struct CuratedPhotosPage: Decodable {
    let photos: [CuratedPhoto]
    let page: Int
    let nextPage: URL?
    
    var isLastPage: Bool {
        nextPage == nil
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.page = try container.decode(Int.self, forKey: .page)
        self.nextPage = try container.decodeIfPresent(URL.self, forKey: .nextPage)
        
        var photosContainer = try container.nestedUnkeyedContainer(forKey: .photos)
        var photos: [CuratedPhoto] = []
        while !photosContainer.isAtEnd {
            let nestedDecoder = try photosContainer.superDecoder()
            let photo = try CuratedPhoto(from: nestedDecoder, pageIndex: page)
            photos.append(photo)
        }
        self.photos = photos
    }
    
    enum CodingKeys: String, CodingKey {
        case photos
        case page
        case nextPage = "next_page"
    }
}
