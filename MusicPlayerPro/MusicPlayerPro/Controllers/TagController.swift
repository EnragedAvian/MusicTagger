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
    
    var allSongs = ItemDict()
    var allAlbums = ItemDict()
    var allPlaylists = ItemDict()
    
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
        
        print(allTags)
        
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
        print("refresh tags called")
        
        if defaults.array(forKey: AppleMusicInterface.allTagsDefaultsKey) != nil {
            print("reading from memory")
            guard let readTags = defaults.array(forKey: AppleMusicInterface.allTagsDefaultsKey) as? [String] else {
                allTags = [String]()
                print("Could not load tags from memory")
                return
            }
            
            allTags = readTags
        }

        
        if defaults.data(forKey: AppleMusicInterface.allSongTagsDefaultsKey) != nil {
            guard let readSongItems = defaults.data(forKey: AppleMusicInterface.allSongTagsDefaultsKey) else {
                print("Could not load tagged songs")
                return
            }
            
            let unwrappedReadSongItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readSongItems)
            
            guard let convertedSongItems = unwrappedReadSongItems as? TagDict else {
                print("Could not load tagged songs")
                return
            }
            
            songTagDict = convertedSongItems
        }
        
        
        
        if defaults.data(forKey: AppleMusicInterface.allAlbumTagsDefaultsKey) != nil {
            guard let readAlbumItems = defaults.data(forKey: AppleMusicInterface.allAlbumTagsDefaultsKey) else {
                print("Could not load tagged albums")
                return
            }
            
            let unwrappedReadAlbums = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readAlbumItems as Data)
            
            guard let convertedReadAlbums = unwrappedReadAlbums as? TagDict else {
                print("Could not load tagged albums")
                return
            }
            
            albumTagDict = convertedReadAlbums
        }
        
        
        
        if defaults.data(forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey) != nil {
            guard let readPlaylistItems = defaults.data(forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey) else {
                print("Could not load tagged playlists")
                return
            }
            
            let unwrappedReadPlaylistItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readPlaylistItems as Data)
            
            guard let convertedPlaylistItems = unwrappedReadPlaylistItems as? TagDict else {
                print("Could not load tagged playlists")
                return
            }
            
            playlistTagDict = convertedPlaylistItems
        }
        
        
        
        if defaults.data(forKey: AppleMusicInterface.allSongsDefaultsKey) != nil {
            guard let readSongTagItems = defaults.data(forKey: AppleMusicInterface.allSongsDefaultsKey) else {
                print("Could not load song tags")
                return
            }
            
            let unwrappedReadSongTagItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readSongTagItems as Data)
            
            guard let convertedSongTagItems = unwrappedReadSongTagItems as? ItemDict else {
                print("could not load song tags")
                return
            }
            
            allSongs = convertedSongTagItems
        }
        
        
        
        if defaults.data(forKey: AppleMusicInterface.allAlbumsDefaultsKey) != nil {
            guard let readAlbumTagItems = defaults.data(forKey: AppleMusicInterface.allAlbumsDefaultsKey) else {
                print("Could not load album tags")
                return
            }
            
            let unwrappedReadAlbumTagItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readAlbumTagItems as Data)
            
            guard let convertedAlbumTagItems = unwrappedReadAlbumTagItems as? ItemDict else {
                print("could not load album tags")
                return
            }
            
            allAlbums = convertedAlbumTagItems
            //print("All albums:")
            //print(allAlbums)
        }
        
        
        
        if defaults.data(forKey: AppleMusicInterface.allPlaylistsDefaultsKey) != nil {
            guard let readPlaylistTagItems = defaults.data(forKey: AppleMusicInterface.allPlaylistsDefaultsKey) else {
                print("Could not load playlist tags")
                return
            }
            
            let unwrappedReadPlaylistTagItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readPlaylistTagItems as Data)
            
            guard let convertedPlaylistTagItems = unwrappedReadPlaylistTagItems as? ItemDict else {
                print("could not load playlist tags")
                return
            }
            
            allPlaylists = convertedPlaylistTagItems
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
    
    func returnSongsWithTag(tagName: String) -> [MPMediaEntityPersistentID] {
        if ValidateTag(tagName: tagName) {
            guard let returnSongs: [MPMediaEntityPersistentID] = songTagDict[tagName] else {
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
    
    func returnAlbumsWithTag(tagName: String) -> [MPMediaEntityPersistentID] {
        if ValidateTag(tagName: tagName) {
            guard let returnAlbums: [MPMediaEntityPersistentID] = albumTagDict[tagName] else {
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
    
    func returnPlaylistsWithTag(tagName: String) -> [MPMediaEntityPersistentID] {
        print("returning playlists")
        if ValidateTag(tagName: tagName) {
            guard let returnPlaylists: [MPMediaEntityPersistentID] = playlistTagDict[tagName] else {
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
    
    func returnMediaTags(mediaID: MPMediaEntityPersistentID, myMediaType: mediaType) -> [String] {
        switch (myMediaType) {
        case .song:
            guard let unwrappedTags: [String] = allSongs[mediaID] else {
                return []
            }
            return unwrappedTags
        case .album:
            guard let unwrappedTags: [String] = allAlbums[mediaID] else {
                print("error reading album tags")
                return []
            }
            return unwrappedTags
        case .playlist:
            guard let unwrappedTags: [String] = allPlaylists[mediaID] else {
                return []
            }
            return unwrappedTags
        }
    }
    
    func createTag(tagName: String) -> Bool {
        if !ValidateTag(tagName: tagName) {
            allTags.append(tagName)
            
            defaults.set(allTags, forKey: AppleMusicInterface.allTagsDefaultsKey)
            
            if songTagDict[tagName] == nil {
                songTagDict[tagName] = []
            }
            
            let archivedSongTagDict = try? NSKeyedArchiver.archivedData(withRootObject: songTagDict, requiringSecureCoding: false)
            
            defaults.set(archivedSongTagDict, forKey: AppleMusicInterface.allSongTagsDefaultsKey)
            
            if albumTagDict[tagName] == nil {
                albumTagDict[tagName] = []
            }
            
            let archivedAlbumTagDict = try? NSKeyedArchiver.archivedData(withRootObject: albumTagDict, requiringSecureCoding: false)
            
            defaults.set(archivedAlbumTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            
            if playlistTagDict[tagName] == nil {
                playlistTagDict[tagName] = []
            }
            
            let archivedPlaylistTagDict = try? NSKeyedArchiver.archivedData(withRootObject: playlistTagDict, requiringSecureCoding: false)
            
            defaults.set(archivedPlaylistTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            
            print(allTags)
            
            return true
        }
        print ("Tag already exists")
        return false;
    }
    
    /*func checkSongExists(songID: String) -> Bool {
        for mySong in completeLibrarySongs.items {
            
        }
        return false;
    }*/
    
    func tagMedia(mediaID: MPMediaEntityPersistentID, tagName: String, tagType: mediaType) -> Bool {
        var mediaFilter: MPMediaPropertyPredicate
        var mediaProperty: String
        
        switch (tagType) {
        case .song:
            mediaProperty = MPMediaItemPropertyPersistentID
        case .album:
            mediaProperty = MPMediaItemPropertyAlbumPersistentID
        case .playlist:
            mediaProperty = MPMediaPlaylistPropertyPersistentID
        }
        
        mediaFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: mediaProperty, comparisonType: .equalTo)
        
        let filterSet = Set([mediaFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        if query.items != nil && ValidateTag(tagName: tagName) {
            var newMediaTags: [String]?
            switch (tagType) {
            case .song:
                newMediaTags = allSongs[mediaID]
            case .album:
                newMediaTags = allAlbums[mediaID]
            case .playlist:
                newMediaTags = allPlaylists[mediaID]
            }
            
            if newMediaTags == nil {
                newMediaTags = [String]()
            }
            
            guard var unwrappedNewMediaTags: [String] = newMediaTags else {
                print ("Error unwrapping variable")
                return false
            }
            
            var hasTag = false
            for item in unwrappedNewMediaTags {
                if item == tagName {
                    hasTag = true
                }
            }
            
            if (!hasTag) {
                print("adding tag")
                unwrappedNewMediaTags.append(tagName)
            }
            
            switch (tagType) {
            case .song:
                allSongs[mediaID] = unwrappedNewMediaTags
                
                let archivedAllSongs = try? NSKeyedArchiver.archivedData(withRootObject: allSongs, requiringSecureCoding: false)
                
                defaults.set(archivedAllSongs, forKey: AppleMusicInterface.allSongsDefaultsKey)
            case .album:
                allAlbums[mediaID] = unwrappedNewMediaTags
                
                let archivedAllAlbums = try? NSKeyedArchiver.archivedData(withRootObject: allAlbums, requiringSecureCoding: false)
                
                defaults.set(archivedAllAlbums, forKey: AppleMusicInterface.allAlbumsDefaultsKey)
            case .playlist:
                allPlaylists[mediaID] = unwrappedNewMediaTags
                
                let archivedAllAplaylists = try? NSKeyedArchiver.archivedData(withRootObject: allPlaylists, requiringSecureCoding: false)
                
                defaults.set(archivedAllAplaylists, forKey: AppleMusicInterface.allPlaylistsDefaultsKey)
            }
            
            var newMediaTagDict: [MPMediaEntityPersistentID]?
            switch (tagType) {
            case .song:
                newMediaTagDict = songTagDict[tagName]
            case .album:
                newMediaTagDict = albumTagDict[tagName]
            case .playlist:
                newMediaTagDict = playlistTagDict[tagName]
            }
            
            if newMediaTagDict == nil {
                newMediaTagDict = [MPMediaEntityPersistentID]()
            }
            
            guard var unwrappedNewMediaTagDict: [MPMediaEntityPersistentID] = newMediaTagDict else {
                print ("Error unwrapping variable")
                return false
            }
            
            var hasMedia = false
            for item in unwrappedNewMediaTagDict {
                if item == mediaID {
                    hasMedia = true
                }
            }
            
            if (!hasMedia) {
                unwrappedNewMediaTagDict.append(mediaID)
            }
            
            switch (tagType) {
            case .song:
                songTagDict[tagName] = unwrappedNewMediaTagDict
                
                let archivedSongTagDict = try? NSKeyedArchiver.archivedData(withRootObject: songTagDict, requiringSecureCoding: false)
                
                defaults.set(archivedSongTagDict, forKey: AppleMusicInterface.allSongTagsDefaultsKey)
            case .album:
                albumTagDict[tagName] = unwrappedNewMediaTagDict
                
                let archivedAlbumTagDict = try? NSKeyedArchiver.archivedData(withRootObject: albumTagDict, requiringSecureCoding: false)
                
                defaults.set(archivedAlbumTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            case .playlist:
                playlistTagDict[tagName] = unwrappedNewMediaTagDict
                
                let archivedPlaylistTagDict = try? NSKeyedArchiver.archivedData(withRootObject: playlistTagDict, requiringSecureCoding: false)
                
                defaults.set(archivedPlaylistTagDict, forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey)
            }
            
            return true
        }
        
        return false
    }
    
    func removeTagMedia(mediaID: MPMediaEntityPersistentID, tagName: String, tagType: mediaType) -> Bool {
        var mediaFilter: MPMediaPropertyPredicate
        switch(tagType) {
        case .song:
            mediaFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        case .album:
            mediaFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
        case .playlist:
            mediaFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaPlaylistPropertyPersistentID, comparisonType: .equalTo)
        }
        
        let filterSet = Set([mediaFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        if query.items != nil && ValidateTag(tagName: tagName) {
            var newMediaTags: [String]?
            switch (tagType) {
            case .song:
                newMediaTags = allSongs[mediaID]
            case .album:
                newMediaTags = allAlbums[mediaID]
            case .playlist:
                newMediaTags = allPlaylists[mediaID]
            }
            
            if newMediaTags == nil {
                newMediaTags = [String]()
            }
            
            guard var unwrappedNewMediaTags: [String] = newMediaTags else {
                print("Error unwrapping variable")
                return false
            }
            
            for i in 0..<unwrappedNewMediaTags.count {
                if unwrappedNewMediaTags[i] == tagName {
                    unwrappedNewMediaTags.remove(at: i)
                    break
                }
            }
            
            switch (tagType) {
            case .song:
                allSongs[mediaID] = unwrappedNewMediaTags
                
                let archivedAllSongs = try? NSKeyedArchiver.archivedData(withRootObject: allSongs, requiringSecureCoding: false)
                
                defaults.set(archivedAllSongs, forKey: AppleMusicInterface.allSongsDefaultsKey)
            case .album:
                allAlbums[mediaID] = unwrappedNewMediaTags
                
                let archivedAllAlbums = try? NSKeyedArchiver.archivedData(withRootObject: allAlbums, requiringSecureCoding: false)
                
                defaults.set(archivedAllAlbums, forKey: AppleMusicInterface.allAlbumsDefaultsKey)
            case .playlist:
                allPlaylists[mediaID] = unwrappedNewMediaTags
                
                let archivedAllPlaylists = try? NSKeyedArchiver.archivedData(withRootObject: allPlaylists, requiringSecureCoding: false)
                
                defaults.set(archivedAllPlaylists, forKey: AppleMusicInterface.allPlaylistsDefaultsKey)
            }
            
            var newMediaTagDict: [MPMediaEntityPersistentID]?
            
            switch(tagType) {
            case .song:
                newMediaTagDict = songTagDict[tagName]
            case .album:
                newMediaTagDict = albumTagDict[tagName]
            case.playlist:
                newMediaTagDict = playlistTagDict[tagName]
            }
            
            if newMediaTagDict == nil {
                newMediaTagDict = [MPMediaEntityPersistentID]()
            }
            
            guard var unwrappedNewMediaTagDict: [MPMediaEntityPersistentID] = newMediaTagDict else {
                print ("Error unwrapping variable")
                return false
            }
            
            for i in 0..<unwrappedNewMediaTagDict.count {
                if unwrappedNewMediaTagDict[i] == mediaID {
                    unwrappedNewMediaTagDict.remove(at: i)
                    break
                }
            }
            
            switch (tagType) {
            case .song:
                songTagDict[tagName] = unwrappedNewMediaTagDict
                
                let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: songTagDict, requiringSecureCoding: false)
                
                defaults.set(archivedData, forKey: AppleMusicInterface.allSongTagsDefaultsKey)
            case .album:
                albumTagDict[tagName] = unwrappedNewMediaTagDict
                
                let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: albumTagDict, requiringSecureCoding: false)
                defaults.set(archivedData, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            case .playlist:
                playlistTagDict[tagName] = unwrappedNewMediaTagDict
                
                let archivedData = try? NSKeyedArchiver.archivedData(withRootObject: playlistTagDict, requiringSecureCoding: false)
                defaults.set(archivedData, forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey)
            }
            
            return true
            
        }
        
        return false
    }
}

typealias TagDict = [String: [UInt64]]
typealias ItemDict = [UInt64: [String]]

enum mediaType {
    case song
    case album
    case playlist
}
