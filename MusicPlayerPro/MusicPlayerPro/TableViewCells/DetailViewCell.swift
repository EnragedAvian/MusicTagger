//
//  DetailViewCell.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

// Cell defining the "detail view" song cell
class DetailViewCell: UITableViewCell {

    @IBOutlet weak var contentName: UILabel!
    var contentID = MPMediaEntityPersistentID()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        // super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pressShowTags(_ sender: Any) {
        UserDefaults.standard.set(contentID, forKey: "tagViewID")
        UserDefaults.standard.set("song", forKey: "tagViewType")
    }
}
