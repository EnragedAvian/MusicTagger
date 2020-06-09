//
//  TagController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/8/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import Foundation
import MediaPlayer

class TagController {
    
    var completeLibrarySongs: MPMediaItemCollection
    var completeLibraryAlbums: MPMediaItemCollection
    var completeLibraryPlaylists: MPMediaItemCollection
    var allTags = [String]()
    
    var songTagDict = TagDict()
    var albumTagDict = TagDict()
    var playlistTagDict = TagDict()
    
    var allSongs = TagDict()
    var allAlbums = TagDict()
    var allPlaylists = TagDict()
    
    var defaults = UserDefaults.standard
    
    init() {
        let allSongsQuery = MPMediaQuery.songs()
        
        guard let songCollection: [MPMediaItem] = allSongsQuery.items else {
            completeLibrarySongs = MPMediaItemCollection.init()
            completeLibraryAlbums = MPMediaItemCollection.init()
            completeLibraryPlaylists = MPMediaItemCollection.init()
            return
        }
        
        completeLibrarySongs = MPMediaItemCollection.init(items: songCollection)
        
        let allAlbumsQuery = MPMediaQuery.albums()
        
        guard let albumCollection: [MPMediaItem] = allAlbumsQuery.items else {
            completeLibraryAlbums = MPMediaItemCollection.init()
            completeLibraryPlaylists = MPMediaItemCollection.init()
            return
        }
        
        completeLibraryAlbums = MPMediaItemCollection.init(items: albumCollection)
        
        let allPlaylistsQuery = MPMediaQuery.playlists()
        
        guard let playlistCollection: [MPMediaItem] = allPlaylistsQuery.items else {
            completeLibraryPlaylists = MPMediaItemCollection.init()
            return
        }
        
        completeLibraryPlaylists = MPMediaItemCollection.init(items: playlistCollection)
        
        RefreshTags()
        
        
        
    }
    
    func RefreshLibrary() -> Void {
        let allSongsQuery = MPMediaQuery.songs()
        
        guard let songCollection: [MPMediaItem] = allSongsQuery.items else {
            completeLibrarySongs = MPMediaItemCollection.init()
            completeLibraryAlbums = MPMediaItemCollection.init()
            completeLibraryPlaylists = MPMediaItemCollection.init()
            print("Could not load songs from memory")
            return
        }
        
        completeLibrarySongs = MPMediaItemCollection.init(items: songCollection)
        
        let allAlbumsQuery = MPMediaQuery.albums()
        
        guard let albumCollection: [MPMediaItem] = allAlbumsQuery.items else {
            completeLibraryAlbums = MPMediaItemCollection.init()
            completeLibraryPlaylists = MPMediaItemCollection.init()
            print("Could not load albums from memory")
            return
        }
        
        completeLibraryAlbums = MPMediaItemCollection.init(items: albumCollection)
        
        let allPlaylistsQuery = MPMediaQuery.playlists()
        
        guard let playlistCollection: [MPMediaItem] = allPlaylistsQuery.items else {
            completeLibraryPlaylists = MPMediaItemCollection.init()
            return
        }
        
        completeLibraryPlaylists = MPMediaItemCollection.init(items: playlistCollection)
    }
    
    func RefreshTags() -> Void {
        guard let readTags = defaults.array(forKey: AppleMusicInterface.allTagsDefaultsKey) as? [String] else {
            allTags = [String]()
            print("Could not load tags from memory")
            return
        }
        
        allTags = readTags
        
        for tagName in allTags {
            guard let readSongItems = defaults.array(forKey: "SongTag-" + tagName) as? [String] else {
                print("Could not load songs for tag " + tagName)
                break
            }
            songTagDict[tagName] = readSongItems
            
            guard let readAlbumItems = defaults.array(forKey: "AlbumTag-" + tagName) as? [String] else {
                print("Could not load Albums for tag " + tagName)
                break
            }
            albumTagDict[tagName] = readAlbumItems
            
            guard let readPlaylistItems = defaults.array(forKey: "PlaylistTag-" + tagName) as? [String] else {
                print("Could not load Playlists for tag " + tagName)
                break
            }
            playlistTagDict[tagName] = readPlaylistItems
        }
    }
    
    func ValidateTag(tagName: String) -> Bool {
        for myTag in allTags {
            if myTag == tagName {
                return true
            }
        }
        return false
    }
    
    func returnSongsWithTag(tagName: String) -> [String] {
        if ValidateTag(tagName: tagName) {
            guard let returnSongs: [String] = songTagDict[tagName] else {
                print("Could not find songs with given tag name")
                return []
            }
            if returnSongs.count > 0 {
                return returnSongs
            }
        }
        print("No songs found")
        return []
    }
    
    func returnAlbumsWithTag(tagName: String) -> [String] {
        if ValidateTag(tagName: tagName) {
            guard let returnAlbums: [String] = albumTagDict[tagName] else {
                print("Could not find albums with given tag name")
                return []
            }
            if returnAlbums.count > 0 {
                return returnAlbums
            }
        }
        print("No albums found")
        return []
    }
    
    func returnPlaylistsWithTag(tagName: String) -> [String] {
        if ValidateTag(tagName: tagName) {
            guard let returnPlaylists: [String] = playlistTagDict[tagName] else {
                print("Could not find playlists with given tag name")
                return []
            }
            if returnPlaylists.count > 0 {
                return returnPlaylists
            }
        }
        print("No playlists found")
        return []
    }
    
    func addTag(tagName: String) -> Bool {
        if !ValidateTag(tagName: tagName) {
            allTags.append(tagName)
            defaults.set(allTags, forKey: AppleMusicInterface.allTagsDefaultsKey)
            
            if songTagDict[tagName] == nil {
                songTagDict[tagName] = []
            }
            defaults.set(songTagDict, forKey: AppleMusicInterface.allSongTagsDefaultsKey)
            
            if albumTagDict[tagName] == nil {
                albumTagDict[tagName] = []
            }
            defaults.set(albumTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            
            if playlistTagDict[tagName] == nil {
                playlistTagDict[tagName] = []
            }
            defaults.set(playlistTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            
        }
        print ("Tag already exists")
        return false;
    }
    
    //func removeTag(tagName:)
    
    /*func returnSongTags(songID: String) -> [String] {
        
    }*/
    
}

typealias TagDict = [String: [String]]
