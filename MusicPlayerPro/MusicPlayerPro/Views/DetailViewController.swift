//
//  DetailViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import MediaPlayer

class DetailViewController: UIViewController, UITableViewDataSource {
    var masterCollection = MPMediaItemCollection()
    var masterCollectionID = MPMediaEntityPersistentID()
    
    @IBOutlet weak var mediaTitle: UILabel!
    @IBOutlet weak var mediaArtist: UILabel!
    @IBOutlet weak var mediaImage: UIImageView!
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return masterCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preLoadType = UserDefaults.standard.object(forKey: "detailType")
        let preLoadID = UserDefaults.standard.object(forKey: "collectionID")
    
        guard let collectionType = preLoadType as? mediaType else {
            print("Can't determine type of album/playlist")
            return
        }
        
        guard let unwrappedPreLoadID = preLoadID as? MPMediaEntityPersistentID else {
            print("Can't read id of preload ID")
            return
        }
        
        masterCollectionID = unwrappedPreLoadID
        
        switch (collectionType) {
        case .song:
            print ("Can't show detail for song")
            return
        case .album:
            let albumFilter = MPMediaPropertyPredicate(value: masterCollectionID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
            
            let filterSet = Set([albumFilter])
            
            let query = MPMediaQuery(filterPredicates: filterSet)
            
            guard let unwrappedQuery: [MPMediaItemCollection] = query.collections else {
                print ("Couldn't unwrap query collection")
                return
            }
            
            masterCollection = unwrappedQuery[0]
            
            var albumCover: MPMediaItemArtwork?
            
            if masterCollection.items.count > 0 {
                mediaTitle.text = masterCollection.items[0].albumTitle
                mediaArtist.text = masterCollection.items[0].albumArtist
                albumCover = masterCollection.items[0].artwork
            }
            
            if albumCover != nil {
                mediaImage.image = albumCover?.image(at: CGSize(width:500, height:500))
            } else {
                mediaImage.image = UIImage(systemName: "music.note.list")?.withTintColor(UIColor.lightText)
            }
            
            
            return
        case .playlist:
            return
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
