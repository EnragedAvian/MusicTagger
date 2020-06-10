//
//  TagSelectorCell.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

class TagSelectorCell: UITableViewCell {

    var masterMediaType = mediaType.song
    var masterMediaID = MPMediaEntityPersistentID()
    var enabled = false
    
    @IBOutlet weak var tagNameLabel: UILabel!
    @IBOutlet weak var selectTagButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func pressAddTag(_ sender: Any) {
        let tagController = (UIApplication.shared.delegate as! AppDelegate).tagController
        
        guard let unwrappedStringText: String = tagNameLabel.text else {
                       print ("coult not read tag name")
                       return
                   }
        
        if (!enabled) {
            if (tagController.tagMedia(mediaID: masterMediaID, tagName: unwrappedStringText, tagType: masterMediaType)) {
                print ("Tag Added")
                print(tagController.returnMediaTags(mediaID: masterMediaID, myMediaType: masterMediaType))
                print(tagController.returnAlbumsWithTag(tagName: unwrappedStringText))
                selectTagButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
                enabled = true
            }
        } else {
            if (tagController.removeTagMedia(mediaID: masterMediaID, tagName: unwrappedStringText, tagType: masterMediaType)) {
                print ("Tag Removed")
                selectTagButton.setImage(UIImage(systemName: "plus.circle"), for: UIControl.State.normal)
                enabled = false
            }
        }
    }
    

}
