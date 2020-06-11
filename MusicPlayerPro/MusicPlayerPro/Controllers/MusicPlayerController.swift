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
    
    func Append(item: MPMusicPlayerQueueDescriptor) {
        musicPlayer.append(item)
    }
    
    func Prepend(item: MPMusicPlayerQueueDescriptor) {
        musicPlayer.prepend(item)
    }
    
    func SetQueue(queue: MPMediaItemCollection) {
        musicPlayer.setQueue(with: queue)
    }
    
    func SetQueueQuery(query: MPMediaQuery) {
        musicPlayer.setQueue(with: query)
    }
    
    func currentlyPlaying() -> MPMediaItem? {
        return musicPlayer.nowPlayingItem
    }
    
    func skipForward() -> Void {
        musicPlayer.skipToNextItem()
    }
    
    func skipBackward() -> Void {
        if musicPlayer.currentPlaybackTime > 6 {
            musicPlayer.skipToBeginning()
        } else {
            musicPlayer.skipToPreviousItem()
        }
    }
    
    func isPlaying() -> Bool {
        return musicPlayer.playbackState == MPMusicPlaybackState.playing
    }
    
}
