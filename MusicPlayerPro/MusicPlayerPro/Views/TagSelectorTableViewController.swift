//
//  TagSelectorTableViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

// Table view controller for the tag selector
class TagSelectorTableViewController: UITableViewController {

    var masterMediaType = mediaType.song
    var masterMediaID = MPMediaEntityPersistentID()
    var allTags = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // load the type and ID of the content to be tagged from memory
        let preLoadType = UserDefaults.standard.string(forKey: "tagViewType")
        let preLoadID = UserDefaults.standard.object(forKey: "tagViewID")
    
        guard let collectionTypeString: String = preLoadType else {
            print("Can't determine type of album/playlist")
            return
        }
        
        var collectionType = mediaType.song
        
        // convert the collection type from string to mediaType
        switch (collectionTypeString) {
        case "album":
            collectionType = mediaType.album
        case "playlist":
            collectionType = mediaType.playlist
        default:
            collectionType = mediaType.song
        }
        
        masterMediaType = collectionType
        
        // convert the ID into MPMediaEntityPersistent ID type
        guard let unwrappedPreLoadID = preLoadID as? MPMediaEntityPersistentID else {
            print("Can't read id of preload ID")
            return
        }
        
        masterMediaID = unwrappedPreLoadID
        
        let controller = (UIApplication.shared.delegate as! AppDelegate).tagController
        
        // refresh tags of the tag controller
        controller.RefreshTags()
        
        allTags = controller.allTags
        
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier: "prorotypeTagSelector") as? TagSelectorCell {
            // create table cell for each tag
            print("making tag cell")
            
            let content = allTags[indexPath.row]
            
            // Assign name, masterMediaId, and masterMediaType to each of the cells
            myCell.tagNameLabel.text = content
            myCell.masterMediaID = masterMediaID
            myCell.masterMediaType = masterMediaType
            
            let controller = (UIApplication.shared.delegate as! AppDelegate).tagController
            
            // return all existing tags for the given media
            let mediaTags = controller.returnMediaTags(mediaID: masterMediaID, myMediaType: masterMediaType)
            
            var hasTag = false
            
            // check and see if the media already has that tag
            for item in mediaTags {
                if item == content {
                    hasTag = true
                    print("already has tag")
                }
            }
            
            // If the tag is found, change the background of the select tag button to represent this state
            if hasTag {
                myCell.selectTagButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
                myCell.enabled = true
            }
            
            return myCell
        }
        
        print("returning empty")
        return UITableViewCell()
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let controller = (UIApplication.shared.delegate as! AppDelegate).tagController
        return controller.allTags.count
    }
}
