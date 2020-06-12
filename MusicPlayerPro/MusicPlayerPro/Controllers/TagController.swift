//
//  TagController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/8/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import Foundation
import MediaPlayer

// type aliases for dictionaries using tags as keys for media items and media items as keys for tags, allowing quick lookups for keys and items in either direction
typealias TagDict = [String: [UInt64]]
typealias ItemDict = [UInt64: [String]]

// mediaType enumeration used throughout the app to determine what type of media ID is being referenced to
enum mediaType {
    case song
    case album
    case playlist
}


// Custom tag controller class which creates, manages, and assigns tags to various media items
class TagController {
    
    //variables containing all songs, albums, and playlists read from the user's library
    var completeLibrarySongs = MPMediaItemCollection(items: [])
    var completeLibraryAlbums = MPMediaItemCollection(items: [])
    var completeLibraryPlaylists = MPMediaItemCollection(items: [])
    
    // variable containing all tags created by the user
    var allTags = [String]()
    
    // variables containing dictionaries which use tags as keys to return all media items associated with the tag
    var songTagDict = TagDict()
    var albumTagDict = TagDict()
    var playlistTagDict = TagDict()
    
    // variables containing dictionaires which use media items as keys to return all tags associated with the item
    var allSongs = ItemDict()
    var allAlbums = ItemDict()
    var allPlaylists = ItemDict()
    
    // creating variable which allows easy access to UserDefaults
    var defaults = UserDefaults.standard
    
    init() {
        RefreshLibrary()
        
        // Refresh all tags to memory by reading them from UserDefaults
        RefreshTags()
        
        // print all read tags
        print(allTags)
        
    }
    
    // Refreshlibrary function which loads all stored songs in the user's library
    func RefreshLibrary() -> Void {
        // read all songs, albums, and playlists from the user's library and attempt to store them in variables
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
    
    // Function which refreshes all tags stored im memory
    func RefreshTags() -> Void {
        // print("refresh tags called")
        
        // If tags can be read from memory, do so
        if defaults.array(forKey: AppleMusicInterface.allTagsDefaultsKey) != nil {
            print("reading from memory")
            guard let readTags = defaults.array(forKey: AppleMusicInterface.allTagsDefaultsKey) as? [String] else {
                allTags = [String]()
                print("Could not load tags from memory")
                return
            }
            
            allTags = readTags
        }

        // If songTagDict can be read from memory, do so
        if defaults.data(forKey: AppleMusicInterface.allSongTagsDefaultsKey) != nil {
            guard let readSongItems = defaults.data(forKey: AppleMusicInterface.allSongTagsDefaultsKey) else {
                print("Could not load tagged songs")
                return
            }
            
            // Unarchive items read from UserDefaults as custom structures can't be stored without being unarchived first
            let unwrappedReadSongItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readSongItems)
            
            guard let convertedSongItems = unwrappedReadSongItems as? TagDict else {
                print("Could not load tagged songs")
                return
            }
            
            // Store read files as a tag-first dictionary for all songs
            songTagDict = convertedSongItems
        }
        
        // If albumTagDict can be read from memory, do so
        if defaults.data(forKey: AppleMusicInterface.allAlbumTagsDefaultsKey) != nil {
            guard let readAlbumItems = defaults.data(forKey: AppleMusicInterface.allAlbumTagsDefaultsKey) else {
                print("Could not load tagged albums")
                return
            }
            
            // Unarchive items read from UserDefaults as custom structures can't be stored without being unarchived first
            let unwrappedReadAlbums = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readAlbumItems as Data)
            
            guard let convertedReadAlbums = unwrappedReadAlbums as? TagDict else {
                print("Could not load tagged albums")
                return
            }
            
            // Store read files as a tag-first dictionary for all albums
            albumTagDict = convertedReadAlbums
        }
        
        // If playlistTagDict can be read from memory, do so
        if defaults.data(forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey) != nil {
            guard let readPlaylistItems = defaults.data(forKey: AppleMusicInterface.allPlaylistTagsDefaultsKey) else {
                print("Could not load tagged playlists")
                return
            }
            
            // Unarchive items read from UserDefaults as custom structures can't be stored without being unarchived first
            let unwrappedReadPlaylistItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readPlaylistItems as Data)
            
            guard let convertedPlaylistItems = unwrappedReadPlaylistItems as? TagDict else {
                print("Could not load tagged playlists")
                return
            }
            
            // Store read files as a tag-first dictionary for all playlists
            playlistTagDict = convertedPlaylistItems
        }
        
        // If allSongs can be read from memory, do so
        if defaults.data(forKey: AppleMusicInterface.allSongsDefaultsKey) != nil {
            guard let readSongTagItems = defaults.data(forKey: AppleMusicInterface.allSongsDefaultsKey) else {
                print("Could not load song tags")
                return
            }
            
            // Unarchive items read from UserDefaults as custom structures can't be stored without being unarchived first
            let unwrappedReadSongTagItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readSongTagItems as Data)
            
            guard let convertedSongTagItems = unwrappedReadSongTagItems as? ItemDict else {
                print("could not load song tags")
                return
            }
            
            // Store read files as a song-first dictionary for all tags
            allSongs = convertedSongTagItems
        }
        
        // if allAlbums can be read from memory, do so
        if defaults.data(forKey: AppleMusicInterface.allAlbumsDefaultsKey) != nil {
            guard let readAlbumTagItems = defaults.data(forKey: AppleMusicInterface.allAlbumsDefaultsKey) else {
                print("Could not load album tags")
                return
            }
            
            // Unarchive items read from UserDefaults as custom structures can't be stored without being unarchived first
            let unwrappedReadAlbumTagItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readAlbumTagItems as Data)
            
            guard let convertedAlbumTagItems = unwrappedReadAlbumTagItems as? ItemDict else {
                print("could not load album tags")
                return
            }
            
            // Store read files as an album-first dictionary for all tags
            allAlbums = convertedAlbumTagItems
            //print("All albums:")
            //print(allAlbums)
        }
        
        // if allPlaylists can be read from memory, do so
        if defaults.data(forKey: AppleMusicInterface.allPlaylistsDefaultsKey) != nil {
            guard let readPlaylistTagItems = defaults.data(forKey: AppleMusicInterface.allPlaylistsDefaultsKey) else {
                print("Could not load playlist tags")
                return
            }
            
            // Unarchive items read from UserDefaults as custom structures can't be stored without being unarchived first
            let unwrappedReadPlaylistTagItems = try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(readPlaylistTagItems as Data)
            
            guard let convertedPlaylistTagItems = unwrappedReadPlaylistTagItems as? ItemDict else {
                print("could not load playlist tags")
                return
            }
            
            // Store read files as a playlist-first dictionary for all tags
            allPlaylists = convertedPlaylistTagItems
        }
        
    }
    
    // Function which accepts a tag and checks whether or not it already has been created
    func ValidateTag(tagName: String) -> Bool {
        for myTag in allTags {
            if myTag == tagName {
                return true
            }
        }
        return false
    }
    
    // Function that returns all songs with a given tag as an array of IDs
    func returnSongsWithTag(tagName: String) -> [MPMediaEntityPersistentID] {
        // If the tag input is valid
        if ValidateTag(tagName: tagName) {
            // read all songs from the dictionary and return them if they are found
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
    
    // Function that returns all albums with a given tag as an array of IDs
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
    
    // function that returns all playlists with a given tag as an array of IDs
    func returnPlaylistsWithTag(tagName: String) -> [MPMediaEntityPersistentID] {
        // print("returning playlists")
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
    
    // Function that returns all tags associated with a particular type of media as an array of tags
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
    
    // Function which creates a new tag
    func createTag(tagName: String) -> Bool {
        // if the tag does not already exist...
        if !ValidateTag(tagName: tagName) {
            // append the tag to allTags
            allTags.append(tagName)
            
            // store the new array in userDefaults
            defaults.set(allTags, forKey: AppleMusicInterface.allTagsDefaultsKey)
            
            // If no entry exists for this tag in songTagDict, initialize a new empty array and store it in UserDefaults as well as memory
            if songTagDict[tagName] == nil {
                songTagDict[tagName] = []
            }
            
            let archivedSongTagDict = try? NSKeyedArchiver.archivedData(withRootObject: songTagDict, requiringSecureCoding: false)
            
            defaults.set(archivedSongTagDict, forKey: AppleMusicInterface.allSongTagsDefaultsKey)
            
            // same function but for albums
            if albumTagDict[tagName] == nil {
                albumTagDict[tagName] = []
            }
            
            let archivedAlbumTagDict = try? NSKeyedArchiver.archivedData(withRootObject: albumTagDict, requiringSecureCoding: false)
            
            defaults.set(archivedAlbumTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            
            // same function but for playlists
            if playlistTagDict[tagName] == nil {
                playlistTagDict[tagName] = []
            }
            
            let archivedPlaylistTagDict = try? NSKeyedArchiver.archivedData(withRootObject: playlistTagDict, requiringSecureCoding: false)
            
            defaults.set(archivedPlaylistTagDict, forKey: AppleMusicInterface.allAlbumTagsDefaultsKey)
            
            // print all tags (debugging purpose)
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
    
    // function which tags a piece of media defined by the ID, name of tag, and type of media provided. Returns a boolean indicating whether or not the operation was successful
    func tagMedia(mediaID: MPMediaEntityPersistentID, tagName: String, tagType: mediaType) -> Bool {
        var mediaFilter: MPMediaPropertyPredicate
        var mediaProperty: String
        
        // Change the type of MPMediaPropertyPredicate search based on the type of media
        switch (tagType) {
        case .song:
            mediaProperty = MPMediaItemPropertyPersistentID
        case .album:
            mediaProperty = MPMediaItemPropertyAlbumPersistentID
        case .playlist:
            mediaProperty = MPMediaPlaylistPropertyPersistentID
        }
        
        // generate a predicate which searches the user's library for items matching the predefined terms
        mediaFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: mediaProperty, comparisonType: .equalTo)
        
        // generate filterSet to be used in the query
        let filterSet = Set([mediaFilter])
        
        // perform query on all media items based on this predicate
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        // If the query returned with items and the tag exists
        if query.items != nil && ValidateTag(tagName: tagName) {
            
            // return all tags that exist for this given type of media
            var newMediaTags: [String]?
            switch (tagType) {
            case .song:
                newMediaTags = allSongs[mediaID]
            case .album:
                newMediaTags = allAlbums[mediaID]
            case .playlist:
                newMediaTags = allPlaylists[mediaID]
            }
            
            // If no tags exist, generate a new array for the tags for the piece of media
            if newMediaTags == nil {
                newMediaTags = [String]()
            }
            
            // unwrapp the read tags if possible
            guard var unwrappedNewMediaTags: [String] = newMediaTags else {
                print ("Error unwrapping variable")
                return false
            }
            
            // check to see if the piece of media already has the tag
            var hasTag = false
            for item in unwrappedNewMediaTags {
                if item == tagName {
                    hasTag = true
                }
            }
            
            // If the media doesn't have the tag already, add the tag to the piece of media
            if (!hasTag) {
                print("adding tag")
                unwrappedNewMediaTags.append(tagName)
            }
            
            // depending on the type of media, write the list of tags to the proper location
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
            
            // read all tag-first dictionaries from memory depending on media type
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
            
            // attempt to unwrap the dictionary
            guard var unwrappedNewMediaTagDict: [MPMediaEntityPersistentID] = newMediaTagDict else {
                print ("Error unwrapping variable")
                return false
            }
            
            // Check to see if the piece of media is present in the array of IDs listed for the given tag
            var hasMedia = false
            for item in unwrappedNewMediaTagDict {
                if item == mediaID {
                    hasMedia = true
                }
            }
            
            // If the media ID is not present, add it to the array saved at the tag location
            if (!hasMedia) {
                unwrappedNewMediaTagDict.append(mediaID)
            }
            
            // Write the tag-first dictionary to the appropriate location in memory
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
    
    // Function which removes a tag from a piece of media; broadly similar in functionality to the function above
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

