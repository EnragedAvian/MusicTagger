//
//  PlaylistTagSelectorCell.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit

// Broadly similar to TagSelectorCell, only instead of adding tags to a piece of media, this marks tags for the creation of a new playlist
class PlaylistTagSelectorCell: UITableViewCell {

    var chosen = false
    @IBOutlet weak var tagName: UILabel!
    @IBOutlet weak var addButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func pressTag(_ sender: Any) {
        guard let tagText: String = tagName.text else {
            print ("Could not read tag text")
            return
        }
        
        guard var readMarkedTags: [String] = UserDefaults.standard.stringArray(forKey: "markedTags") else {
            print("could not read tags")
            return
        }
        
        
        
        if !chosen {
            addButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
            var alreadyPresent = false
            for item in readMarkedTags {
                if item == tagName.text {
                    alreadyPresent = true
                }
            }
            
            if !alreadyPresent {
                readMarkedTags.append(tagText)
            }
            chosen = true
            
        } else {
            addButton.setImage(UIImage(systemName: "plus.circle"), for: UIControl.State.normal)

            for item in 0..<readMarkedTags.count {
                if readMarkedTags[item] == tagName.text {
                    readMarkedTags.remove(at: item)
                    break
                }
            }
            chosen = false
            
        }
        
        print(readMarkedTags)
        
        UserDefaults.standard.set(readMarkedTags, forKey: "markedTags")
    }
}
