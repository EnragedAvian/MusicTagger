//
//  SampleAlbumCell.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/9/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

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
        super.setSelected(selected, animated: animated)

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
    
    
    

}
