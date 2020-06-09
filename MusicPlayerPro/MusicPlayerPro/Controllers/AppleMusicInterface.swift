//
//  AppleMusicInterface.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/8/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import Foundation
import StoreKit
import MediaPlayer

class AppleMusicInterface: NSObject {
    
    var cloudServiceCapabilities = SKCloudServiceCapability()
    var userToken = ""
    var cloudServiceCountryCode = ""
    let cloudServiceController = SKCloudServiceController()
    
    static let userTokenUserDefaultsKey = "UserToken"
    static let allTagsDefaultsKey = "allTags"
    
    static let allSongTagsDefaultsKey = "allSongTags"
    static let allAlbumTagsDefaultsKey = "allAlbumTags"
    static let allPlaylistTagsDefaultsKey = "allPlaylistTags"
    
    static let allSongsDefaultsKey = "allSongs"
    static let allAlbumsDefaultsKey = "allAlbums"
    static let allPlaylistsDefaultsKey = "allPlaylists"
    
    
    override init() {
        super.init()
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            requestCloudCapabilities()
        }
        
        if let token = UserDefaults.standard.string(forKey: AppleMusicInterface.userTokenUserDefaultsKey) {
            userToken = token
        } else {
            requestUserToken()
        }
    }
    
    func FetchDeveloperToken() -> String? {
        // Should not be hard-coded for future implementation, but storing token as string suffices for minimum viable product. Future implementations would request from web or other source so token can be updated without modifying code of the app.
        let myToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjZaUTdGUUdENkQifQ.eyJpc3MiOiJBUjU3NFhXVjYzIiwiaWF0IjoxNTkxNjQyMDQ0LCJleHAiOjE2MDc0MTM2NDR9.fKaL7J0s_-CiAgiNxH23fT3La60_NIddQLxv4LtA5lt9OviYTsfsj2yjNyBRpFlLTzsZaptGrRElzKLF6JD_HA"
        return myToken
    }
    
    func checkLocalPerms() -> Void {
        guard MPMediaLibrary.authorizationStatus() == .notDetermined else { return }
        MPMediaLibrary.requestAuthorization { (_) in
            print ("Local perms checked")
        }
            

    }
    
    func checkCloudPerms() -> Void {
        guard SKCloudServiceController.authorizationStatus() == .notDetermined else { return }
        SKCloudServiceController.requestAuthorization { [weak self] (authorizationStatus) in
            switch authorizationStatus{
            case .authorized:
                self?.requestCloudCapabilities()
                self?.requestUserToken()
            default:
                break
            }
        }
    }
    
    func requestCloudCapabilities() -> Void {
        
    }
    
    func requestUserToken() -> Void {
        guard let developerToken = self.FetchDeveloperToken() else {
            return
        }
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            let completionHandler: (String?, Error?) -> Void = { [weak self] (token, error) in
                guard error == nil else {
                    print("Error while requesting user token: " + error!.localizedDescription)
                    return
                }
                
                guard let token = token else {
                    print("Invalid value type received for user token.")
                    return
                }
                
                self?.userToken = token
                
                let userDefaults = UserDefaults.standard
                
                userDefaults.set(token, forKey: AppleMusicInterface.userTokenUserDefaultsKey)
                userDefaults.synchronize()
                
                if self?.cloudServiceCountryCode == "" {
                    self?.requestCountryCode()
                }
                
            }
            
            if #available(iOS 11.0, *) {
                cloudServiceController.requestUserToken(forDeveloperToken: developerToken, completionHandler: completionHandler)
            } else {
                // deprecated method for devices running older operating systems
                cloudServiceController.requestPersonalizationToken(forClientToken: developerToken, withCompletionHandler: completionHandler)
            }
        }
    }
    
    func requestCountryCode() -> Void {
        let completionHandler: (String?, Error?) -> Void = { [weak self] (countryCode, error) in
            guard error == nil else {
                print("An error occurred when retreiving country code: " + error!.localizedDescription)
                return
            }
            
            guard let countryCode = countryCode else {
                print ("Invalid value type recieved for country code.")
                return
            }
            
            self?.cloudServiceCountryCode = countryCode
        }
        
        if SKCloudServiceController.authorizationStatus() == .authorized {
            if #available(iOS 11.0, *) {
                cloudServiceController.requestStorefrontCountryCode(completionHandler: completionHandler)
            } else {
                // deprecated method, to be filled in future versions
            }
        }
    }
}

