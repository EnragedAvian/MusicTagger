//
//  ManageTagsViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit

// View controller which handles the "manage tags" view
class ManageTagsViewController: UIViewController, UITableViewDataSource {
    var allTags: [String] = (UIApplication.shared.delegate as! AppDelegate).tagController.allTags
    
    // Link the table
    @IBOutlet weak var tagTable: UITableView!
    
    // Define timer repsonsible for the refreshing of tags in the event they are created/deleted
    var refreshTimer = Timer()
    
    // Make a tag cell with the tag name as the content (not interactible
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier:
            "prototypeManageTagsCell") as? ManageTagsCell {
            
            print("making tag cell")
            
            myCell.tagName.text = allTags[indexPath.row]
            
            return myCell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTags.count
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    

    // basic setup for the table
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
        // refresh the tags and reload the data every time the this function is called
        allTags = (UIApplication.shared.delegate as! AppDelegate).tagController.allTags
        tagTable.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // refresh every time the view is called
        refresh()
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
