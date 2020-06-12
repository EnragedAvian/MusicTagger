//
//  SampleAlbumCell.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/9/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

// Mirror of SampleSongCell with minor changes to account for album
class SampleAlbumCell: UITableViewCell {

    @IBOutlet weak var albumCover: UIImageView!
    @IBOutlet weak var albumName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var mediaID = MPMediaEntityPersistentID()
    var cellMediaType: mediaType? = nil
    
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
        
        let albumFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([albumFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        controller.SetQueueQuery(query: query)
        
        controller.Play()
    }
    
    @IBAction func pressMoreInfo(_ sender: Any) {
        let albumFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([albumFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        guard let unwrappedQueryItems: [MPMediaItem] = query.items else {
            print("Couldn't unwrap query")
            return
        }
        
        if unwrappedQueryItems.count > 0 {
            UserDefaults.standard.set(unwrappedQueryItems[0].albumPersistentID, forKey: "collectionID")
        }
        
        UserDefaults.standard.set("album", forKey: "detailType")
        
    }
    
    

}
