//
//  Song.swift
//  SwiftUI-MusicPlayer
//
//  Created by Jordan Christensen on 4/3/20.
//  Copyright © 2020 Mazjap Co. All rights reserved.
//

import SwiftUI

class Song: ObservableObject {
    let albumTitle: String
    let artistName: String
    let title: String
    let id:  Int
    let artwork: UIImage = UIImage(named: "Placeholder")!; #warning("Replace with actual image")
    
    init(albumTitle: String, artistName: String, songTitle: String, songId: Int) {
        self.albumTitle = albumTitle
        self.artistName = artistName
        self.title = songTitle
        self.id = songId
    }
}

struct Album {
    let albumTitle: String
    let songs: [Song]
}
