//
//  SamplePlaylistCell.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/9/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

// Mirror of SampleSongCell with minor changes to account for the playlist
class SamplePlaylistCell: UITableViewCell {

    var mediaID = MPMediaEntityPersistentID()
    var cellMediaType: mediaType? = nil
    
    @IBOutlet weak var moreInfoButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var playlistName: UILabel!
    @IBOutlet weak var playlistArt: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pressPlay(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        
        let playlistFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaPlaylistPropertyPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([playlistFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        //print(query.collections)
        
        controller.SetQueueQuery(query: query)
        
        controller.Play()
    }
    
    @IBAction func pressMoreInfo(_ sender: Any) {
        //let playlistFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaPlaylistPropertyPersistentID, comparisonType: .equalTo)
        
        print(mediaID)
        
        /*let filterSet = Set([playlistFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        guard let unwrappedQueryItems: [MPMediaItemCollection] = query.collections else {
            print("Couldn't unwrap query")
            return
        }*/
        
        UserDefaults.standard.set(mediaID, forKey: "collectionID")
        
        /*if unwrappedQueryItems.count > 0 {
            
            guard let playlistID = unwrappedQueryItems[0].value(forProperty: MPMediaPlaylistPropertyPersistentID) as? MPMediaEntityPersistentID else {
                print("could not read playlist ID")
                return
            }
            print("Playlist ID: " + String(playlistID))
            UserDefaults.standard.set(playlistID, forKey: "collectionID")
            print(UserDefaults.standard.value(forKey: "collectionID"))
        }*/
        
        UserDefaults.standard.set("playlist", forKey: "detailType")
        
    }
}
