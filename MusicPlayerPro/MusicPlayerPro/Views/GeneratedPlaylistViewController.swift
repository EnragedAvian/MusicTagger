//
//  GeneratedPlaylistViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

class GeneratedPlaylistViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var playlistTable: UITableView!

    var generatedPlaylist = MPMediaItemCollection(items: [MPMediaItem]())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tagController = (UIApplication.shared.delegate as! AppDelegate).tagController
        var allSongIDs = [MPMediaEntityPersistentID]()
        
        guard let readTags: [String] = UserDefaults.standard.stringArray(forKey: "markedTags") else {
            print("could not read tags")
            return
        }
        
        for tag in readTags {
            
            
            
            
            let allAlbums = tagController.returnAlbumsWithTag(tagName: tag)
            for item in allAlbums {
                let albumFilter = MPMediaPropertyPredicate(value: item, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
                
                let filterSet = Set([albumFilter])
                
                let query = MPMediaQuery(filterPredicates: filterSet)
                
                guard let unwrappedQuery: [MPMediaItem] = query.items else {
                    print ("Couldn't unwrap query collection")
                    return
                }
                
                for song in unwrappedQuery {
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
            
            let allPlaylists = tagController.returnPlaylistsWithTag(tagName: tag)
            print("all playlists")
            print(allPlaylists)
            for item in allPlaylists {
                let masterPlaylistQuery = MPMediaQuery.playlists()
                
                guard let masterPlaylistCollection: [MPMediaItemCollection] = masterPlaylistQuery.collections else {
                    print("Could not read playlists from library")
                    return
                }
                
                var identifiedPlaylist = MPMediaItemCollection(items: [])
                
                for myCollection in masterPlaylistCollection {
                    if myCollection.value(forProperty: MPMediaPlaylistPropertyPersistentID) as? MPMediaEntityPersistentID == item {
                        identifiedPlaylist = myCollection
                    }
                }
                
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
            
            let allSongs = tagController.returnSongsWithTag(tagName: tag)
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
            
            var newMediaCollection = [MPMediaItem]()
            
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
            
            generatedPlaylist = MPMediaItemCollection(items: newMediaCollection)
            
            //print(generatedPlaylist.items)
            
            playlistTable.dataSource = self
            playlistTable.rowHeight = 60
            
        }
        
        
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return generatedPlaylist.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier: "prototypeGeneratedPlaylistCell") as? GeneratedPlaylistSongCell { // attempt to import prototype cell from storyboard
            
            let artist = generatedPlaylist.items[indexPath.row].artist
            let name = generatedPlaylist.items[indexPath.row].title
            let songID = generatedPlaylist.items[indexPath.row].persistentID
            
            
            let albumCover = generatedPlaylist.items[indexPath.row].artwork
            
            myCell.cellMediaType = .song
            myCell.songName.text = name
            myCell.artistName.text = artist
            myCell.mediaID = songID
            
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
