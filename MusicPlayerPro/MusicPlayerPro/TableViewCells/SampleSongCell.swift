//
//  SampleCell.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/9/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

class SampleSongCell: UITableViewCell {

    var mediaID = MPMediaEntityPersistentID()
    var cellMediaType: mediaType? = nil
    
    @IBOutlet weak var songName: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var albumCover: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        //super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func pressPlay(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        
        let songFilter = MPMediaPropertyPredicate(value: mediaID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([songFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        controller.SetQueueQuery(query: query)
        
        controller.Play()
    }
    
}
