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
    var masterCollection = MPMediaItemCollection.init(items: [])
    var masterCollectionID = MPMediaEntityPersistentID()
    var masterMediaType = mediaType.song
    
    @IBOutlet weak var mediaTitle: UILabel!
    @IBOutlet weak var mediaArtist: UILabel!
    @IBOutlet weak var mediaImage: UIImageView!
    
    @IBOutlet weak var contentTable: UITableView!
    @IBOutlet weak var showTags: UIButton!
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print (masterCollection.count)
        return masterCollection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier: "prototypeDetailCell") as? DetailViewCell {
            
            print("making cell")
            
            let content = masterCollection.items[indexPath.row].title
            
            myCell.contentName.text = content
            myCell.contentID = masterCollection.items[indexPath.row].persistentID
            
            return myCell
            
        }
        
        
        return UITableViewCell()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let preLoadType = UserDefaults.standard.string(forKey: "detailType")
        let preLoadID = UserDefaults.standard.object(forKey: "collectionID")
    
        guard let collectionTypeString: String = preLoadType else {
            print("Can't determine type of album/playlist")
            return
        }
        
        var collectionType = mediaType.song
        
        switch (collectionTypeString) {
        case "album":
            collectionType = mediaType.album
        case "playlist":
            collectionType = mediaType.playlist
        default:
            collectionType = mediaType.song
        }
        
        masterMediaType = collectionType
        
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
            
            guard let unwrappedQuery: [MPMediaItem] = query.items else {
                print ("Couldn't unwrap query collection")
                return
            }
            
            masterCollection = MPMediaItemCollection(items: unwrappedQuery)
            
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
            
            contentTable.dataSource = self
            
            return
        case .playlist:
            print("MasterCollection ID: " + String(masterCollectionID))
            
            
            let masterPlaylistQuery = MPMediaQuery.playlists()
            
            guard let masterPlaylistCollection: [MPMediaItemCollection] = masterPlaylistQuery.collections else {
                print("Could not read playlists from library")
                return
            }
            
            var identifiedPlaylist = MPMediaItemCollection(items: [])
            
            for myCollection in masterPlaylistCollection {
                if myCollection.value(forProperty: MPMediaPlaylistPropertyPersistentID) as? MPMediaEntityPersistentID == masterCollectionID {
                    identifiedPlaylist = myCollection
                }
            }
            
            print("Identified Playlist: " + String(identifiedPlaylist.count))
            print(identifiedPlaylist)
            
            masterCollection = identifiedPlaylist
            
            var albumCover: MPMediaItemArtwork?
            
            if masterCollection.items.count > 0 {
                guard let unwrappedTitle = identifiedPlaylist.value(forProperty: MPMediaPlaylistPropertyName) as? String else {
                    print("could not read playlist name")
                    return
                }
                
                mediaTitle.text = unwrappedTitle
                mediaArtist.text = ""
                
                albumCover = masterCollection.items[0].artwork
            }
            
            if albumCover != nil {
                mediaImage.image = albumCover?.image(at: CGSize(width:500, height:500))
            } else {
                mediaImage.image = UIImage(systemName: "music.note.list")?.withTintColor(UIColor.lightText)
            }
            
            contentTable.dataSource = self
            
            return
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func pressShowTags(_ sender: Any) {
        UserDefaults.standard.set(masterCollectionID, forKey: "tagViewID")
        switch (masterMediaType) {
        case .song:
            UserDefaults.standard.set("song", forKey: "tagViewType")
        case .album:
            UserDefaults.standard.set("album", forKey: "tagViewType")
        case .playlist:
            UserDefaults.standard.set("playlist", forKey: "tagViewType")
        }
    }
    
    @IBAction func pressPlay(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        
        var myFilter = MPMediaPropertyPredicate()
        switch (masterMediaType) {
        case .song:
            myFilter = MPMediaPropertyPredicate(value: masterCollectionID, forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        case .playlist:
            myFilter = MPMediaPropertyPredicate(value: masterCollectionID, forProperty: MPMediaPlaylistPropertyPersistentID, comparisonType: .equalTo)
        case .album:
            myFilter = MPMediaPropertyPredicate(value: masterCollectionID, forProperty: MPMediaItemPropertyAlbumPersistentID, comparisonType: .equalTo)
        }
        
        let filterSet = Set([myFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        //print(query.collections)
        
        controller.SetQueueQuery(query: query)
        
        controller.Play()
        
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
