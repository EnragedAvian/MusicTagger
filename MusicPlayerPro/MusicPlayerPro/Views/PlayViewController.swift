//
//  PlayViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit

// View controller for the playback screen
class PlayViewController: UIViewController {

    // links to album art, song title, artist name, and play buttons, all of which are dynamically changed
    @IBOutlet weak var albumArt: UIImageView!
    @IBOutlet weak var songTitle: UILabel!
    @IBOutlet weak var artistName: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    // refresh Timer function that updates the view so that new album art is displayed when the song is changed
    var refreshTimer = Timer()
    
    override func viewDidLoad() {
        // round the corners of the album art
        albumArt.layer.cornerRadius = 10
        
        super.viewDidLoad()

        refreshView()
        
        // Do any additional setup after loading the view.
        // Schedule a timer to refresh the view every second
        refreshTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (Timer) in
            self.refreshView()
        })
    }
    

    func refreshView() -> Void {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        
        // display the album art of the currently playing song
        let readAlbumArt = controller.currentlyPlaying()?.artwork
        
        guard let unwrappedAlbumArt: UIImage = readAlbumArt?.image(at: CGSize(width: 1200, height: 1200)) else {
            print("could not display artwork")
            return
        }
        
        albumArt.image = unwrappedAlbumArt
        
        // update the songTitle and artist name fields
        songTitle.text = controller.currentlyPlaying()?.title
        artistName.text = controller.currentlyPlaying()?.artist
        
        // contextually change the icon of the play button depending on whether or not media is playing
        if controller.isPlaying() {
            playButton.setBackgroundImage(UIImage(systemName: "pause.fill"), for: UIControl.State.normal)
        } else {
            playButton.setBackgroundImage(UIImage(systemName: "play.fill"), for: UIControl.State.normal)
        }
        
    }
    
    // Pause/resume the music when pressing the play button
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
    
    // Skip forward a track
    @IBAction func skipForward(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        controller.skipForward()
        refreshView()
    }
    
    // Skip back a track
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
