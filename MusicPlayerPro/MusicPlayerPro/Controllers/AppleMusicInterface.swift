//
//  AppleMusicInterface.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/8/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//
//
//  Code referenced from apple's "Adding Content to Apple Music" sample app

// Importing StoreKit and MediaPlayer as part of MusicKit overall framework

import Foundation
import StoreKit
import MediaPlayer

class AppleMusicInterface: NSObject {
    
    // Defining variables related to cloud activity, such as reading the user's device code and their country ID
    var cloudServiceCapabilities = SKCloudServiceCapability()
    var userToken = ""
    var cloudServiceCountryCode = ""
    let cloudServiceController = SKCloudServiceController()
    
    // Defining static variables used for accessing UserDefaults values throughout the entire application
    static let userTokenUserDefaultsKey = "UserToken"
    static let allTagsDefaultsKey = "allTags"
    static let developerTokenDefaultsKey = "devToken"
    
    static let allSongTagsDefaultsKey = "allSongTags"
    static let allAlbumTagsDefaultsKey = "allAlbumTags"
    static let allPlaylistTagsDefaultsKey = "allPlaylistTags"
    
    static let allSongsDefaultsKey = "allSongs"
    static let allAlbumsDefaultsKey = "allAlbums"
    static let allPlaylistsDefaultsKey = "allPlaylists"
    
    // Initialization function
    override init() {
        super.init()
        
        // Check whether or not user has granted Apple Music access permissions and if they haven't request said permissions
        if SKCloudServiceController.authorizationStatus() == .authorized {
            requestCloudCapabilities()
        }
        
        // If the user token can be read from the
        if let token = UserDefaults.standard.string(forKey: AppleMusicInterface.userTokenUserDefaultsKey) {
            userToken = token
        } else {
            requestUserToken()
        }
        // Write the developer token to UserDefaults
        UserDefaults.standard.set(self.FetchDeveloperToken(), forKey: AppleMusicInterface.developerTokenDefaultsKey)
        
    }
    
    // Function that fetches developer token for use in Apple Music API calls
    func FetchDeveloperToken() -> String? {
        // Should not be hard-coded for future implementation, but storing token as string suffices for minimum viable product. Future implementations would request from web or other source so token can be updated without modifying code of the app.
        let myToken = "eyJhbGciOiJFUzI1NiIsInR5cCI6IkpXVCIsImtpZCI6IjZaUTdGUUdENkQifQ.eyJpc3MiOiJBUjU3NFhXVjYzIiwiaWF0IjoxNTkxNjQyMDQ0LCJleHAiOjE2MDc0MTM2NDR9.fKaL7J0s_-CiAgiNxH23fT3La60_NIddQLxv4LtA5lt9OviYTsfsj2yjNyBRpFlLTzsZaptGrRElzKLF6JD_HA"
        return myToken
    }
    
    // Function that checks local permissions for access to library
    func checkLocalPerms() -> Void {
        // read local permissions using MusicPlayer framework and request authorization if they are not granted
        guard MPMediaLibrary.authorizationStatus() == .notDetermined else { return }
        MPMediaLibrary.requestAuthorization { (_) in
            print ("Local perms checked")
        }
            

    }
    
    // Function that checks cloud permissions for access to Apple Music API
    func checkCloudPerms() -> Void {
        // read cloud permissions and and request authorization if not granted
        guard SKCloudServiceController.authorizationStatus() == .notDetermined else { return }
        SKCloudServiceController.requestAuthorization { [weak self] (authorizationStatus) in
            switch authorizationStatus{
            case .authorized:
                // If authorized, request capabilites and user token from API
                self?.requestCloudCapabilities()
                self?.requestUserToken()
            default:
                break
            }
        }
    }
    
    // Function that requests what capabilites have been greanted to the user for access to the Apple Music API service
    func requestCloudCapabilities() -> Void {
        // request capabilities using StoreKit framework
        cloudServiceController.requestCapabilities(completionHandler: { [weak self] (cloudServiceCapability, error) in
            guard error == nil else {
                fatalError("An error occurred while requesting cloud capabilities: " + error!.localizedDescription)
            }
            // Write capabilities to cloudServiceCapabilities variable
            self?.cloudServiceCapabilities = cloudServiceCapability
            
        })
    }
    
    // Function that requests user token from clou dservice
    func requestUserToken() -> Void {
        // attempt to fetch developer token from other predefined function
        guard let developerToken = self.FetchDeveloperToken() else {
            return
        }
        
        // If user has authorized access, attempt to request their token using the StoreKit API
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
                
                // Write read token to userToken variable
                self?.userToken = token
                
                let userDefaults = UserDefaults.standard
                
                // write token to userDefaults as well
                userDefaults.set(token, forKey: AppleMusicInterface.userTokenUserDefaultsKey)
                userDefaults.synchronize()
                
                // If country code has not been read, read country code as well
                if self?.cloudServiceCountryCode == "" {
                    self?.requestCountryCode()
                }
                
            }
            
            // If available, request token using requestUserToken function (only available in newer implementations of iOS
            if #available(iOS 11.0, *) {
                cloudServiceController.requestUserToken(forDeveloperToken: developerToken, completionHandler: completionHandler)
            } else {
                // deprecated method for devices running older operating systems
                cloudServiceController.requestPersonalizationToken(forClientToken: developerToken, withCompletionHandler: completionHandler)
            }
        }
    }
    
    // Function that requests country code for use in Storekit and Apple Music API calls
    func requestCountryCode() -> Void {
        // Define completionHandler portion of API call
        let completionHandler: (String?, Error?) -> Void = { [weak self] (countryCode, error) in
            guard error == nil else {
                print("An error occurred when retreiving country code: " + error!.localizedDescription)
                return
            }
            
            guard let countryCode = countryCode else {
                print ("Invalid value type recieved for country code.")
                return
            }
            
            // write country code to variable dfined above
            self?.cloudServiceCountryCode = countryCode
        }
        
        // Attempt to read country code if authorized, using proper framework
        if SKCloudServiceController.authorizationStatus() == .authorized {
            if #available(iOS 11.0, *) {
                cloudServiceController.requestStorefrontCountryCode(completionHandler: completionHandler)
            } else {
                // deprecated method, to be filled in future versions
            }
        }
    }
}

