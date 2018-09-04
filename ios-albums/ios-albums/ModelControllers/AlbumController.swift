//
//  AlbumController.swift
//  ios-albums
//
//  Created by De MicheliStefano on 04.09.18.
//  Copyright © 2018 De MicheliStefano. All rights reserved.
//

import Foundation

class AlbumController {
    
    var albums: [Album] = []
    var baseURL: URL = URL(string: "https://stefanojournal.firebaseio.com/")!
    
    func getAlbums(completion: @escaping (Error?) -> Void) {
        let url = baseURL.appendingPathExtension("json")
        let request = URLRequest(url: url)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(error)
                return
            }
            
            guard let data = data else { completion(NSError()); return }
            
            do {
                let decodedData = try Array(JSONDecoder().decode([String : Album].self, from: data).values)
                self.albums = decodedData
                completion(nil)
            } catch {
                NSLog("Could not decode data: \(error)")
                completion(error)
            }
        }.resume()
    }
    
    func put(album: Album, completion: @escaping (Error?) -> Void = { _ in }) {
        let url = baseURL.appendingPathComponent(album.id)
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        do {
            //let encodedData = try JSONEncoder().encode(album)
            //request.httpBody = encodedData
        } catch {
            NSLog("Could not encode data: \(error)")
            completion(error)
        }
        
        URLSession.shared.dataTask(with: request) { (_, _, error) in
            if let error = error {
                completion(error)
                return
            }
            
            completion(nil)
            
        }.resume()
    }
    
    func update(album: Album, name: String, artist: String, genres: [String], coverURLs: [URL], songs: [Song]) {
        guard let index = albums.index(of: album) else { return }
        var album = albums[index]
        album.name = name
        album.artist = artist
        album.genres = genres
        album.coverURLs = coverURLs
        album.songs = songs
        albums.remove(at: index)
        albums.insert(album, at: index)
        put(album: album)
    }
    
    func createAlbum(with name: String, artist: String, genres: [String], coverURLs: [URL], songs: [Song], id: String = UUID().uuidString ) {
        let album = Album(name: name, artist: artist, genres: genres, coverURLs: coverURLs, songs: songs)
        albums.append(album)
        put(album: album)
    }
    
    func createSong(with name: String, artist: String, genres: [String], coverURLs: [URL], songs: [Song], id: String = UUID().uuidString ) {
        let album = Album(name: name, artist: artist, genres: genres, coverURLs: coverURLs, songs: songs)
        albums.append(album)
        put(album: album)
    }
    
    func testDecodingExampleAlbum() {
        guard let url = Bundle.main.url(forResource: "exampleAlbum", withExtension: "json") else { print("Could not find URL"); return }
        
        do {
            let albums = try Data(contentsOf: url)
            _ = try JSONDecoder().decode(Album.self, from: albums)
            print("Success")
        } catch {
            NSLog("Could not decode albums: \(error)")
        }
    }
    
}
