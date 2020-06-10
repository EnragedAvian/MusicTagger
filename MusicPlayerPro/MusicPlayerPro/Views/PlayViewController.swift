//
//  PlayViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit

class PlayViewController: UIViewController {

    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    
    
    override func viewDidLoad() {
        albumArt.layer.cornerRadius = 10
        
        super.viewDidLoad()

        refreshView()
        
        // Do any additional setup after loading the view.
    }
    

    func refreshView() -> Void {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        
        let readAlbumArt = controller.currentlyPlaying()?.artwork
        
        guard let unwrappedAlbumArt: UIImage = readAlbumArt?.image(at: CGSize(width: 1200, height: 1200)) else {
            print("could not display artwork")
            return
        }
        
        albumArt.image = unwrappedAlbumArt
        
        songTitle.text = controller.currentlyPlaying()?.title
        artistName.text = controller.currentlyPlaying()?.artist
        
        if controller.isPlaying() {
            playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
        } else {
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        }
        
    }
    
    @IBAction func pressPlay(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        if controller.isPlaying() {
            controller.Pause()
            refreshView()
        } else {
            controller.Play()
            refreshView()
        }
    }
    
    @IBAction func skipForward(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        controller.skipForward()
        refreshView()
    }
    
    @IBAction func skipBackward(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        controller.skipBackward()
        refreshView()
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
