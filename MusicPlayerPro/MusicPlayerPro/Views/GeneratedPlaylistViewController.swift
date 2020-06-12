//
//  GeneratedPlaylistViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

// View controller handling generated playlists using tags
class GeneratedPlaylistViewController: UIViewController, UITableViewDataSource {
    
    // connection to table holding all generated songs int he playlist
    @IBOutlet weak var playlistTable: UITableView!

    // variable containing a mediaItemCollection representing the gnerated playlist
    var generatedPlaylist = MPMediaItemCollection(items: [MPMediaItem]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create alias for the tag controller initialized in AppDelegate
        let tagController = (UIApplication.shared.delegate as! AppDelegate).tagController
        // create variable holding the IDs of all songs to be added
        var allSongIDs = [MPMediaEntityPersistentID]()
        
        // attempt to read all tags to be used to generate the playlist from userDefaults
        guard let readTags: [String] = UserDefaults.standard.stringArray(forKey: "markedTags") else {
            print("could not read tags")
            return
        }
        
        // for every tag to be utilized
        for tag in readTags {
            // return all all albums with the given tag
            let allAlbums = tagController.returnAlbumsWithTag(tagName: tag)
            // for every album returned
            for item in allAlbums {
                // generate a filter used to read the given album from the user's library
                let albumFilter = MPMediaPropertyPredicate(value: item, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
                
                let filterSet = Set([albumFilter])
                
                let query = MPMediaQuery(filterPredicates: filterSet)
                
                guard let unwrappedQuery: [MPMediaItem] = query.items else {
                    print ("Couldn't unwrap query collection")
                    return
                }
                
                // for every song in the read album
                for song in unwrappedQuery {
                    // Check and see if the song has already been added to the playlist (to avoid duplicates)
                    var written = false
                    for writtenID in allSongIDs {
                        if writtenID == song.persistentID {
                            written = true
                        }
                    }
                    // if not writted, add the song ID to the allSongIDs array
                    if (!written) {
                        allSongIDs.append(song.persistentID)
                    }
                }
                
            }
            
            // Perform the same function but with playlists
            let allPlaylists = tagController.returnPlaylistsWithTag(tagName: tag)
            //print("all playlists")
            //print(allPlaylists)
            for item in allPlaylists {
                // create a master query for every playlist since a query can't be conducted for each individual playlist ID
                let masterPlaylistQuery = MPMediaQuery.playlists()
                
                guard let masterPlaylistCollection: [MPMediaItemCollection] = masterPlaylistQuery.collections else {
                    print("Could not read playlists from library")
                    return
                }
                
                var identifiedPlaylist = MPMediaItemCollection(items: [])
                
                // for every playlist on the system, check and see if it matches the defined ID. If it does, add it to the identifiedPlaylist collection
                for myCollection in masterPlaylistCollection {
                    if myCollection.value(forProperty: MPMediaPlaylistPropertyPersistentID) as? MPMediaEntityPersistentID == item {
                        identifiedPlaylist = myCollection
                    }
                }
                
                // Attempt to add every song in the playlist to the master song ID list, provided the song isn't already present in the list
                for song in identifiedPlaylist.items {
                    var written = false
                    for writtenID in allSongIDs {
                        if writtenID == song.persistentID {
                            written = true
                        }
                    }
                    if (!written) {
                        allSongIDs.append(song.persistentID)
                    }
                }
                
            }
            
            // return all songs with the given tag
            let allSongs = tagController.returnSongsWithTag(tagName: tag)
            // Add the song to the allSongIDs list if not already present
            for item in allSongs {
                var written = false
                for writtenID in allSongIDs {
                    if writtenID == item {
                        written = true
                    }
                }
                if (!written) {
                    allSongIDs.append(item)
                }
            }
            
            // generate a new MediaCollection that is currently empty
            var newMediaCollection = [MPMediaItem]()
            
            // add every song matching the id in allSongIDs to this new Media Collection playlist
            for item in allSongIDs {
                let songFilter = MPMediaPropertyPredicate(value: item, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
                
                let filterSet = Set([songFilter])
                
                let query = MPMediaQuery(filterPredicates: filterSet)
                
                guard let unwrappedQuery: [MPMediaItem] = query.items else {
                    print ("Couldn't unwrap query collection")
                    return
                }
                
                if unwrappedQuery.count > 0 {
                    newMediaCollection.append(unwrappedQuery[0])
                }
            }
            
            // Assign the generated playlist all the items in the new media collection
            generatedPlaylist = MPMediaItemCollection(items: newMediaCollection)
            
            //print(generatedPlaylist.items)
            
            // define parameters for the table in the view
            playlistTable.dataSource = self
            playlistTable.rowHeight = 60
            
        }
    }
    
    // return the number of rows in the playlist
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generatedPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier: "prototypeGeneratedPlaylistCell") as? GeneratedPlaylistSongCell { // attempt to import prototype cell from storyboard
            
            // read the artist, name, and song ID from the given song
            let artist = generatedPlaylist.items[indexPath.row].artist
            let name = generatedPlaylist.items[indexPath.row].title
            let songID = generatedPlaylist.items[indexPath.row].persistentID
            
            // read the artwork for the given song
            let albumCover = generatedPlaylist.items[indexPath.row].artwork
            
            // Write all read values to the table cell
            myCell.cellMediaType = .song
            myCell.songName.text = name
            myCell.artistName.text = artist
            myCell.mediaID = songID
            
            // Convert the album cover into a presentable image
            if albumCover != nil {
                myCell.albumArt.image = albumCover?.image(at: CGSize(width: 150, height: 150))
            } else {
                myCell.albumArt.image = UIImage(systemName: "music.note.list")
                myCell.albumArt.image?.withTintColor(UIColor.lightText)
            }
            
            // return this cell
            return myCell
        }
        
        return UITableViewCell()
    }
    
    // Function which defines the playPlaylist button, which queues and plays all songs in the current generated playlist through the master music controller
    @IBAction func playPlaylist(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        controller.SetQueue(queue: generatedPlaylist)
        controller.Play()
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
