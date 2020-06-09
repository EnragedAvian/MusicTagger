//
//  APIController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/8/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import Foundation
import SwiftUI

class APIController {
    
        

    /*static func requestAlbumArt(albumID: String) -> UIImage? {
        var musicInterface = (UIApplication.shared.delegate as! AppDelegate).appleMusicInterface
        
        var components = URLComponents()
        components.scheme = "https"
        components.host   = "api.music.apple.com"
        components.path   = "/v1/me/library/albums\(albumID)"
                
        /*components.queryItems = [
            URLQueryItem(name: "term", value: searchTerm),
            URLQueryItem(name: "limit", value: "25"),
            URLQueryItem(name: "types", value: "playlists"),
        ]*/

        guard let url = components.url else {
            print ("URL could not be generated")
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setValue("Bearer \(musicInterface.FetchDeveloperToken())", forHTTPHeaderField: "Authorization")
        request.setValue(musicInterface.userToken, forHTTPHeaderField: "Music-User-Token")
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request) {data, response, error in
            
        }
        
    }*/
}
