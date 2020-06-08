//
//  MusicPlayerController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/8/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import Foundation
import MediaPlayer

class MusicPlayerController: NSObject {
    
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    // TODO: Add more features to music player
    
    func Play() -> Void {
        musicPlayer.play()
    }
    
    func Pause() -> Void {
        musicPlayer.pause()
    }
    
    
}
