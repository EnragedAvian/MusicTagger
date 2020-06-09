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
        
        guard let readSongItems = defaults.object(forKey: AppleMusicInterface.allSongTagsDefaultsKey) as? TagDict else {
            print("Could not load tagged songs")
            return
        }
        songTagDict = readSongItems
        
        guard let readAlbumItems = defaults.object(forKey: AppleMusicInterface.allAlbumTagsDefaultsKey) as? TagDict else {
            print("Could not load tagged albums")
            return
        }
        albumTagDict = readAlbumItems
        
        guard let readPlaylistItems = defaults.object(forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey) as? TagDict else {
            print("Could not load tagged playlists")
            return
        }
        playlistTagDict = readPlaylistItems
        
        /*for tagName in allTags {
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
        }*/
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
    
    func createTag(tagName: String) -> Bool {
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
    
    /*func checkSongExists(songID: String) -> Bool {
        for mySong in completeLibrarySongs.items {
            
        }
        return false;
    }*/
    
    func tagMedia(mediaID: String, tagName: String, tagType: mediaType) -> Bool {
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
                newMediaTags = allSongs[mediaID]
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
                unwrappedNewMediaTags.append(tagName)
            }
            
            switch (tagType) {
            case .song:
                allSongs[mediaID] = unwrappedNewMediaTags
                defaults.set(allSongs, forKey: AppleMusicInterface.allSongsDefaultsKey)
            case .album:
                allAlbums[mediaID] = unwrappedNewMediaTags
                defaults.set(allAlbums, forKey: AppleMusicInterface.allAlbumsDefaultsKey)
            case .playlist:
                allPlaylists[mediaID] = unwrappedNewMediaTags
                defaults.set(allAlbums, forKey: AppleMusicInterface.allPlaylistsDefaultsKey)
            }
            
            var newMediaTagDict: [String]?
            switch (tagType) {
            case .song:
                newMediaTagDict = songTagDict[tagName]
            case .album:
                newMediaTagDict = albumTagDict[tagName]
            case .playlist:
                newMediaTagDict = playlistTagDict[tagName]
            }
            
            if newMediaTagDict == nil {
                newMediaTagDict = [String]()
            }
            
            guard var unwrappedNewMediaTagDict: [String] = newMediaTagDict else {
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
                defaults.set(songTagDict, forKey: AppleMusicInterface.allSongTagsDefaultsKey)
            case .album:
                albumTagDict[tagName] = unwrappedNewMediaTagDict
                defaults.set(songTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            case .playlist:
                playlistTagDict[tagName] = unwrappedNewMediaTagDict
                defaults.set(songTagDict, forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey)
            }
            
            return true
        }
        
        return false
    }
    
    /*func tagSong(songID: String, tagName: String) -> Bool {
        let songFilter = MPMediaPropertyPredicate(value: songID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([songFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        if query.items != nil && ValidateTag(tagName: tagName) {
            var newSongTags = allSongs[songID]
            if newSongTags == nil {
                newSongTags = [String]()
            }
            var hasTag = false
            for item in newSongTags! {
                if item == tagName {
                    hasTag = true
                }
            }
            
            if (!hasTag) {
                newSongTags?.append(tagName)
            }
            
            allSongs[songID] = newSongTags
            
            var newSongTagDict = songTagDict[tagName]
            if newSongTagDict == nil {
                newSongTagDict = [String]()
            }
            var hasSong = false
            for item in newSongTagDict! {
                if item == songID {
                    hasSong = true
                }
            }
            
            if (!hasSong) {
                newSongTagDict?.append(songID)
            }

            songTagDict[tagName] = newSongTagDict
            
            defaults.set(allSongs, forKey: AppleMusicInterface.allSongsDefaultsKey)
            defaults.set(songTagDict, forKey: AppleMusicInterface.allSongTagsDefaultsKey)
            
            return true;
        }
        
        return false;
    }
    
    func tagAlbum(albumID: String, tagName: String) -> Bool {
        let albumFilter = MPMediaPropertyPredicate(value: albumID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([albumFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        if query.items != nil && ValidateTag(tagName: tagName) {
            var newAlbumTags = allAlbums[albumID]
            if newAlbumTags == nil {
                newAlbumTags = [String]()
            }
            var hasTag = false
            for item in newAlbumTags! {
                if item == tagName {
                    hasTag = true
                }
            }
            
            if (!hasTag) {
                newAlbumTags?.append(tagName)
            }
            
            allAlbums[albumID] = newAlbumTags
            
            var newAlbumTagDict = albumTagDict[tagName]
            if newAlbumTagDict == nil {
                newAlbumTagDict = [String]()
            }
            var hasAlbum = false
            for item in newAlbumTagDict! {
                if item == albumID {
                    hasAlbum = true
                }
            }
            
            if (!hasAlbum) {
                newAlbumTagDict?.append(albumID)
            }

            albumTagDict[tagName] = newAlbumTagDict
            
            defaults.set(allAlbums, forKey: AppleMusicInterface.allAlbumsDefaultsKey)
            defaults.set(albumTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            
            return true;
        }
        
        return false;
    }
    
    func tagPlaylist(playlistID: String, tagName: String) -> Bool {
        let playlistFilter = MPMediaPropertyPredicate(value: playlistID, forProperty: MPMediaPlaylistPropertyPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([playlistFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        if query.items != nil && ValidateTag(tagName: tagName) {
            var newPlaylistTags = allPlaylists[playlistID]
            if newPlaylistTags == nil {
                newPlaylistTags = [String]()
            }
            var hasTag = false
            for item in newPlaylistTags! {
                if item == tagName {
                    hasTag = true
                }
            }
            
            if (!hasTag) {
                newPlaylistTags?.append(tagName)
            }
            
            allPlaylists[playlistID] = newPlaylistTags
            
            var newPlaylistTagDict = playlistTagDict[tagName]
            if newPlaylistTagDict == nil {
                newPlaylistTagDict = [String]()
            }
            var hasPlaylist = false
            for item in newPlaylistTagDict! {
                if item == playlistID {
                    hasPlaylist = true
                }
            }
            
            if (!hasPlaylist) {
                newPlaylistTagDict?.append(playlistID)
            }

            playlistTagDict[tagName] = newPlaylistTagDict
            
            defaults.set(allPlaylists, forKey: AppleMusicInterface.allPlaylistsDefaultsKey)
            defaults.set(playlistTagDict, forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey)
            
            return true;
        }
        
        
        return false;
    }*/
    
    func removeTagMedia(mediaID: String, tagName: String, tagType: mediaType) -> Bool {
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
                defaults.set(allSongs, forKey: AppleMusicInterface.allSongsDefaultsKey)
            case .album:
                allAlbums[mediaID] = unwrappedNewMediaTags
                defaults.set(allAlbums, forKey: AppleMusicInterface.allAlbumsDefaultsKey)
            case .playlist:
                allPlaylists[mediaID] = unwrappedNewMediaTags
                defaults.set(allPlaylists, forKey: AppleMusicInterface.allPlaylistsDefaultsKey)
            }
            
            var newMediaTagDict: [String]?
            
            switch(tagType) {
            case .song:
                newMediaTagDict = songTagDict[tagName]
            case .album:
                newMediaTagDict = albumTagDict[tagName]
            case.playlist:
                newMediaTagDict = playlistTagDict[tagName]
            }
            
            if newMediaTagDict == nil {
                newMediaTagDict = [String]()
            }
            
            guard var unwrappedNewMediaTagDict: [String] = newMediaTagDict else {
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
                defaults.set(songTagDict, forKey: AppleMusicInterface.allSongTagsDefaultsKey)
            case .album:
                albumTagDict[tagName] = unwrappedNewMediaTagDict
                defaults.set(albumTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            case .playlist:
                playlistTagDict[tagName] = unwrappedNewMediaTagDict
                defaults.set(playlistTagDict, forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey)
            }
            
            return true
            
        }
        
        return false
    }
    
    /*func removeTagSong(songID: String, tagName: String) -> Bool {
        let songFilter = MPMediaPropertyPredicate(value: songID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([songFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        if query.items != nil && ValidateTag(tagName: tagName) {
            var newSongTags = allSongs[songID]
            if newSongTags == nil {
                newSongTags = [String]()
            }
            
            guard var unwrappedNewSongTags: [String] = newSongTags else {
                print ("Error unwrapping variable")
                return false
            }
            
            for i in 0..<unwrappedNewSongTags.count {
                if unwrappedNewSongTags[i] == tagName {
                    unwrappedNewSongTags.remove(at: i)
                    break
                }
            }
            
            allSongs[songID] = unwrappedNewSongTags
            
            var newSongTagDict = songTagDict[tagName]
            if newSongTagDict == nil {
                newSongTagDict = [String]()
            }
            
            guard var unwrappedNewSongTagDict: [String] = newSongTagDict else {
                print ("Error unwrapping variable")
                return false
            }
            
            for i in 0..<unwrappedNewSongTagDict.count {
                if unwrappedNewSongTagDict[i] == songID {
                    unwrappedNewSongTagDict.remove(at: i)
                    break
                }
            }

            songTagDict[tagName] = unwrappedNewSongTagDict
            
            defaults.set(allSongs, forKey: AppleMusicInterface.allSongsDefaultsKey)
            defaults.set(songTagDict, forKey: AppleMusicInterface.allSongTagsDefaultsKey)
            
            return true;
        }
        
        return false;
    }
    
    func removeTagAlbum(albumID: String, tagName: String) -> Bool {
        let albumFilter = MPMediaPropertyPredicate(value: albumID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([albumFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        if query.items != nil && ValidateTag(tagName: tagName) {
            var newAlbumTags = allAlbums[albumID]
            if newAlbumTags == nil {
                newAlbumTags = [String]()
            }
            
            guard var unwrappedNewAlbumTags: [String] = newAlbumTags else {
                print ("Error unwrapping variable")
                return false
            }
            
            for i in 0..<unwrappedNewAlbumTags.count {
                if unwrappedNewAlbumTags[i] == tagName {
                    unwrappedNewAlbumTags.remove(at: i)
                    break
                }
            }
            
            allAlbums[albumID] = unwrappedNewAlbumTags
            
            var newAlbumTagDict = albumTagDict[tagName]
            if newAlbumTagDict == nil {
                newAlbumTagDict = [String]()
            }
            
            guard var unwrappedNewAlbumTagDict: [String] = newAlbumTagDict else {
                print ("Error unwrapping variable")
                return false
            }
            
            for i in 0..<unwrappedNewAlbumTagDict.count {
                if unwrappedNewAlbumTagDict[i] == albumID {
                    unwrappedNewAlbumTagDict.remove(at: i)
                    break
                }
            }

            albumTagDict[tagName] = unwrappedNewAlbumTagDict
            
            defaults.set(allAlbums, forKey: AppleMusicInterface.allAlbumsDefaultsKey)
            defaults.set(albumTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            
            return true;
        }
        
        return false;
    }*/
    
    /*func deleteTag(tagName: String) -> Bool {
        if ValidateTag(tagName: tagName) {
            if songTagDict[tagName] == nil {
                songTagDict[tagName] = [String]()
            }
            
            var unwrapped
        }
    }*/
    
    /*func removeTag(tagName: String) -> Bool {
        if ValidateTag(tagName: tagName) {
            if songTagDict[tagName] != nil {P
                for song in
            }
        }
        print ("Tag does not exist")
        return false;
    }*/
    
    /*func returnSongTags(songID: String) -> [String] {
        
    }*/
    
}

typealias TagDict = [String: [String]]

enum mediaType {
    case song
    case album
    case playlist
}
