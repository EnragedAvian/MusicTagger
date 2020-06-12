//
//  MusicPlayerController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/8/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

//  Class that controls the system music player

import Foundation
import MediaPlayer

class MusicPlayerController: NSObject {
    
    // Creating musicPlayer instance which controls the playback of music using the device's native playback controller
    let musicPlayer = MPMusicPlayerController.systemMusicPlayer
    
    // TODO: Add more features to music player
    
    // public functions that allow access to the system music player with simpler controls
    
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
    
    // skipBackward function which either skips to the beginning of the song if the song has been playing more than six seconds or skips to previous item if the song has just started playing, emulating native skip backward functions
    func skipBackward() -> Void {
        if musicPlayer.currentPlaybackTime > 6 {
            musicPlayer.skipToBeginning()
        } else {
            musicPlayer.skipToPreviousItem()
        }
    }
    
    // function that returns playing state of media player
    func isPlaying() -> Bool {
        return musicPlayer.playbackState == MPMusicPlaybackState.playing
    }
    
}
