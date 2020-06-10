//
//  NewPlaylistViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit

class NewPlaylistViewController: UIViewController, UITableViewDataSource {
    @IBOutlet weak var tagTable: UITableView!
    
    
    var allTags: [String] = (UIApplication.shared.delegate as! AppDelegate).tagController.allTags
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allTags.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let myCell = tableView.dequeueReusableCell(withIdentifier:
            "prototypeManageTagsCell") as? ManageTagsCell {
            
            print("making tag cell")
            
            myCell.tagName.text = allTags[indexPath.row]
            
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tagTable.dataSource = self
        
        refresh()
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
