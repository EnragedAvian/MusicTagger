//
//  SongTableViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/9/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

// View controller which handles the table of all songs/playlists/albums
class SongTableViewController: UITableViewController {

    // connect the category selector and table view controllers
    @IBOutlet weak var categorySelector: UISegmentedControl!
    @IBOutlet var myTableView: UITableView!
    
    // create variables holding all songs, albums, and playlists
    var allSongs = [MPMediaItem]()
    var allAlbums = [MPMediaItemCollection]()
    var allPlaylists = [MPMediaItemCollection]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Query all songs and store them
        let readSongsQuery = MPMediaQuery.songs()
        
        guard let songCollection: [MPMediaItem] = readSongsQuery.items else {
            print("Could not read songs from library")
            return
        }
        
        allSongs = songCollection
        
        // Query all albums and store them
        let readAlbumsQuery = MPMediaQuery.albums()
        //print(readAlbumsQuery)
        guard let albumCollection: [MPMediaItemCollection] = readAlbumsQuery.collections else {
            print("Could not read albums from library")
            return
        }
        allAlbums = albumCollection
        
        // Query all playlists and store them
        let readPlaylistsQuery = MPMediaQuery.playlists()
        //print(readPlaylistsQuery)
        guard let playlistCollection: [MPMediaItemCollection] = readPlaylistsQuery.collections else {
            print("Could not read playlists from library")
            return
        }
        allPlaylists = playlistCollection
        
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // reload the table data when the category selector is changed
    @IBAction func valueChanged(_ sender: Any) {
        myTableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    // Define the number of rows in each section based on the number of items in each collection
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if categorySelector.selectedSegmentIndex == 0 {
            return allSongs.count
        }
        if categorySelector.selectedSegmentIndex == 1 {
            return allAlbums.count
        }
        if categorySelector.selectedSegmentIndex == 2 {
            return allPlaylists.count
        }
        return 0
    }

    // Define the creation of a UITableViewCell
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // add cells depending on what index the view selector is at
        switch (categorySelector.selectedSegmentIndex) {
        case 0:
            // Add a new cell of type SampleSongCell
            if let myCell = tableView.dequeueReusableCell(withIdentifier: "prototypeSongCell") as? SampleSongCell { // attempt to import prototype cell from storyboard
                
                // read the artist, name, and song ID
                let artist = allSongs[indexPath.row].artist
                let name = allSongs[indexPath.row].title
                let songID = allSongs[indexPath.row].persistentID
                
                // read the album cover of the song
                let albumCover = allSongs[indexPath.row].artwork
                
                // Write the song, name, artist, and mediaID cover to the cell
                myCell.cellMediaType = .song
                myCell.songName.text = name
                myCell.artistName.text = artist
                myCell.mediaID = songID
                
                // Convert the album art into a usable format
                if albumCover != nil {
                    myCell.albumCover.image = albumCover?.image(at: CGSize(width: 150, height: 150))
                } else {
                    myCell.albumCover.image = UIImage(systemName: "music.note.list")
                    myCell.albumCover.image?.withTintColor(UIColor.lightText)
                }
                
                // return this cell
                return myCell
            }
        case 1:
            // add a new cell of type SampleAlbumCell
            if let myCell = tableView.dequeueReusableCell(withIdentifier: "prototypeAlbumCell") as? SampleAlbumCell { // attempt to import prototype cell from storyboard
                
                // read the artist, name, and album ID
                let artist = allAlbums[indexPath.row].items[0].albumArtist
                let name = allAlbums[indexPath.row].items[0].albumTitle
                let albumID = allAlbums[indexPath.row].items[0].albumPersistentID
                
                // read the album cover
                let albumCover = allAlbums[indexPath.row].items[0].artwork
                
                // write the name, artist, and album ID
                myCell.cellMediaType = .album
                myCell.albumName.text = name
                myCell.artistName.text = artist
                myCell.mediaID = albumID
                
                // Convert the album art into a usable format
                if albumCover != nil {
                    myCell.albumCover.image = albumCover?.image(at: CGSize(width: 150, height: 150))
                } else {
                    myCell.albumCover.image = UIImage(systemName: "music.note.list")
                    myCell.albumCover.image?.withTintColor(UIColor.lightText)
                }
                
                // return this cell
                return myCell
            }
        case 2:
            // add a new cell of type SamplePlaylistCell
            if let myCell = tableView.dequeueReusableCell(withIdentifier: "prototypePlaylistCell") as? SamplePlaylistCell { // attempt to import prototype cell from storyboard
                
                // Read the name and playlistID
                guard let name = allPlaylists[indexPath.row].value(forProperty: MPMediaPlaylistPropertyName) as? String else {
                    print("could not read playlist name")
                    return myCell
                }
                guard let playlistID = allPlaylists[indexPath.row].value(forProperty: MPMediaPlaylistPropertyPersistentID) as? MPMediaEntityPersistentID else {
                    print("could not read playlist ID")
                    return myCell
                }
                
                // read the artwork
                var playlistCover: MPMediaItemArtwork?
                
                if allPlaylists[indexPath.row].items.count > 0 {
                    playlistCover = allPlaylists[indexPath.row].items[0].artwork
                }
                
                // Fill all data fields in the cell
                myCell.cellMediaType = .playlist
                myCell.playlistName.text = name
                myCell.mediaID = playlistID
                
                // print(playlistID)
                
                // Convert the playlist cover into a readable format
                if playlistCover != nil {
                    myCell.playlistArt.image = playlistCover?.image(at: CGSize(width: 150, height: 150))
                } else {
                    myCell.playlistArt.image = UIImage(systemName: "music.note.list")
                    myCell.playlistArt.image?.withTintColor(UIColor.lightText)
                }
                
                // return this cell
                return myCell
            }
        default:
            // otherwise, return a default table view cell (should never occur but included for the sake of error handling)
            return SampleSongCell()
        }
        
        return SampleSongCell()
    }
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
