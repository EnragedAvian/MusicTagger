//
//  SampleTableViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/9/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

class SampleTableViewController: UIViewController, UITableViewDataSource {
    
    @IBOutlet weak var songTable: UITableView!
    
    var allSongs = [MPMediaItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let readSongsQuery = MPMediaQuery.songs()
        
        guard let songCollection: [MPMediaItem] = readSongsQuery.items else {
            print ("Could not read songs from library")
            allSongs = []
            return
        }
        
        allSongs = songCollection
        
        songTable.rowHeight = 60
        songTable.dataSource = self
        
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    // Return the number of rows in the section
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of names in the array, limited to 100
        return allSongs.count
    }
    
    // Define the creation of a UITableViewCell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier: "prototypeCell") as? SampleCell { // attempt to import prototype cell from storyboard
            // Retrieve values for rank, name, and score from the arrays
            
            //print("success")
            
            let artist = allSongs[indexPath.row].artist
            let name = allSongs[indexPath.row].title
            let songID = allSongs[indexPath.row].persistentID
            
            
            let albumCover = allSongs[indexPath.row].artwork
            
            myCell.cellMediaType = .song
            myCell.songName.text = name
            myCell.artistName.text = artist
            myCell.mediaID = songID
            
            guard let unwrappedAlbumCover = albumCover?.image(at: CGSize(width: 120, height: 120)) else {
                return myCell
            }
            
            myCell.albumCover.image = unwrappedAlbumCover

            // return this cell
            return myCell
        }
        // otherwise, return a default table view cell (should never occur but included for the sake of error handling)
        return SampleCell()
    }
    
}
