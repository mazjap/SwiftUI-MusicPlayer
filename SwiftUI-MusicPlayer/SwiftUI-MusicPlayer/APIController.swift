//
//  APIController.swift
//  SwiftUI-MusicPlayer
//
//  Created by Jordan Christensen on 4/4/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import Foundation
import MediaPlayer

enum NetworkError: Error {
    case badURL
    case encodingError
    case responseError
    case otherError(Error)
    case noData
    case badDecode
    case noToken
}

class APIController {
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    var songQueue = [MPMediaItem]()
    
    init() {
        for song in getSongs() {
            if let songMedia = getSongMedia(songId: song.id) {
                songQueue.append(songMedia)
            }
        }
        
        musicPlayer.setQueue(with: MPMediaItemCollection(items: songQueue))
        setQueue(songs: songQueue)
        playMusic()
    }
    
    func getSongs() -> [Song] {
        let albumsQuery = MPMediaQuery.albums()
        let albumItems: [MPMediaItemCollection] = albumsQuery.collections! as [MPMediaItemCollection]
        var songs: [Song] = []

        for album in albumItems {
            let albumItems: [MPMediaItem] = album.items as [MPMediaItem]
            
            for song in albumItems {
                guard let albumTitle = song.value(forProperty: MPMediaItemPropertyAlbumTitle) as? String,
                    let artistName = song.value(forProperty: MPMediaItemPropertyArtist) as? String,
                    let songTitle = song.value( forProperty: MPMediaItemPropertyTitle ) as? String,
                    let songId = song.value(forProperty: MPMediaItemPropertyPersistentID) as? Int
                    //let songArtwork = song.value(forProperty: MPMediaItemPropertyArtwork)
                    else { return [] }
                
                let tempSong: Song = Song(albumTitle: albumTitle, artistName: artistName, songTitle: songTitle, songId: songId)//, songArtwork: songArtwork)
                songs.append(tempSong)
            }
        }

        return songs
    }

    func getSongMedia(songId: Int) -> MPMediaItem? {
        let property: MPMediaPropertyPredicate = MPMediaPropertyPredicate( value: songId, forProperty: MPMediaItemPropertyPersistentID )

        let query: MPMediaQuery = MPMediaQuery()
        query.addFilterPredicate( property )

        let items: [MPMediaItem] = query.items! as [MPMediaItem]

        return items[items.count - 1]

    }
    
    func fetchSongArtwork(from url: String, completion: @escaping (Result<UIImage, NetworkError>) -> Void) {
        guard let imageURL = URL(string: url) else {
            completion(.failure(.badURL))
            return
        }
        
        let request = URLRequest(url: imageURL)
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                completion(.failure(.otherError(error)))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            let image = UIImage(data: data)
            
            if let image = image {
                completion(.success(image))
            } else {
                completion(.failure(.badDecode))
            }
        }.resume()
    }
    
    func playMusic() {
        musicPlayer.play()
    }
    
    func pauseMusic() {
        musicPlayer.pause()
    }
    
    func playPause(bool: Bool) {
        if bool {
            playMusic()
        } else {
            pauseMusic()
        }
    }
    
    func isPlaying() -> Bool {
        return musicPlayer.playbackState == .playing
    }
    
    func enqueue(songs: [MPMediaItem]) {
        songQueue.append(contentsOf: songs)
    }
    
    func setQueue(songs: [MPMediaItem]) {
        songQueue = songs
    }
    
    func skipSong() {
        musicPlayer.skipToNextItem()
    }
    
    func goBackSong() {
        if musicPlayer.currentPlaybackTime > 15 {
            musicPlayer.skipToBeginning()
        } else {
            musicPlayer.skipToPreviousItem()
        }
    }
    
    func getCurrentTime() -> String {
        let time = musicPlayer.currentPlaybackTime
        var seconds = String(Int(time.remainder(dividingBy: 60)))
        
        if seconds.count == 1 {
            seconds += "0"
        }
        
        return "\(Int(time / 60)):\(seconds)"
    }
    
    func getTotalTime() -> String {
        guard let time = musicPlayer.nowPlayingItem?.value(forProperty: MPMediaItemPropertyPlaybackDuration) as? TimeInterval else { return "" }
        var seconds = String(Int(time.remainder(dividingBy: 60)))
        
        if seconds.count == 1 {
            seconds += "0"
        }
        
        return "\(Int(time / 60)):\(seconds)"
    }
}
