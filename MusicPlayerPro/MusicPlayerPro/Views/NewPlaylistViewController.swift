//
//  NewPlaylistViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit

class NewPlaylistViewController: UIViewController, UITableViewDataSource {
    // link table view
    @IBOutlet weak var tagTable: UITableView!
    
    // Create variable holding all tags
    var allTags: [String] = (UIApplication.shared.delegate as! AppDelegate).tagController.allTags
    
    // Timer reponsible for refreshing view in the event new tags are added
    var refreshTimer = Timer()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTags.count
    }
    
    // Add a cell to the table for each tag stored in memory
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier:
            "prototypeGenerateTagsCell") as? PlaylistTagSelectorCell {
            
            //print("making tag cell")
            
            myCell.tagName.text = allTags[indexPath.row]
            
            
            guard let markedTags: [String] = UserDefaults.standard.stringArray(forKey: "markedTags") else {
                print("could not read tags")
                return myCell
            }
            
            // If the tag has already been marked, change the selection icon to reflect this
            var present = false
            for item in markedTags {
                if item == myCell.tagName.text {
                    present = true
                }
            }
            
            if present {
                myCell.chosen = true
                myCell.addButton.setImage(UIImage(systemName: "checkmark.circle.fill"), for: UIControl.State.normal)
            }
            
            return myCell
        }
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    @IBOutlet weak var generateButton: UIButton!
    @IBOutlet weak var selectionTable: UITableView!
    
    // Basic setup functionality
    override func viewDidLoad() {
        super.viewDidLoad()

        tagTable.dataSource = self
        
        refresh()
        
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            self.refresh()
        })
        // Do any additional setup after loading the view.
    }
    
    func refresh() {
        allTags = (UIApplication.shared.delegate as! AppDelegate).tagController.allTags
        tagTable.reloadData()
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
