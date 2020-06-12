//
//  GeneratedPlaylistSongCell.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

// Song cell presented in the view of a generated playlist
class GeneratedPlaylistSongCell: UITableViewCell {

    var mediaID = MPMediaEntityPersistentID()
    var cellMediaType: mediaType? = nil
    
    // Link the various parameters in the cell
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    // Queue the song and play it when the play button is pressed
    @IBAction func pressPlay(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        
        let songFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([songFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        controller.SetQueueQuery(query: query)
        
        controller.Play()
    }

}
