//
//  Album.swift
//  ios-albums
//
//  Created by De MicheliStefano on 04.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class Album: Decodable {
    
    let id: String
    let name: String
    let artist: String
    let genres: [String]
    let coverURLs: [URL]
    let songs: [Song]
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case artist
        case genres
        case coverURLs = "coverArt"
        case songs
            
        enum CoverURLCodingKeys: String, CodingKey {
            case url
        }

    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.artist = try container.decode(String.self, forKey: .artist)
        self.genres = try container.decode([String].self, forKey: .genres)
        // TODO: Cover URL
        var coverArtContainer = try container.nestedUnkeyedContainer(forKey: .coverURLs)
        var coverURLs: [URL] = []
        while !coverArtContainer.isAtEnd {
            let coverURL = try coverArtContainer.decode(URL.self)
            coverURLs.append(coverURL)
        }
        
        self.coverURLs = coverURLs
        
        var songsContainer = try container.nestedUnkeyedContainer(forKey: .songs)
        var songs: [Song] = []
        while !songsContainer.isAtEnd {
            let song = try songsContainer.decode(Song.self)
            songs.append(song)
        }
        self.songs = songs
    }
    
}

class Song: Decodable {
    
    let id: String
    let name: String
    let duration: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case duration
        
        enum DurationCodingKeys: String, CodingKey {
            case duration
        }
        
        enum NameCodingKeys: String, CodingKey {
            case title
        }
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try container.decode(String.self, forKey: .id)
        
        let nameContainer = try container.nestedContainer(keyedBy: CodingKeys.NameCodingKeys.self, forKey: .name)
        self.name = try nameContainer.decode(String.self, forKey: .title)
    
        let durationContainer = try container.nestedContainer(keyedBy: CodingKeys.DurationCodingKeys.self, forKey: .duration)
        self.duration = try durationContainer.decode(String.self, forKey: .duration)
    }
    
}
