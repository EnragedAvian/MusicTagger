//
//  LaunchViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/8/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import StoreKit
import MediaPlayer

class LaunchViewController: UIViewController {

    var myStatus = SKCloudServiceAuthorizationStatus.notDetermined
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let controller = (UIApplication.shared.delegate as! AppDelegate).musicPlayerController
        
        //let myCollection = MPMediaItemCollection()
        
        let songFilter = MPMediaPropertyPredicate(value: "4370690314555102979", forProperty: MPMediaItemPropertyPersistentID, comparisonType: .equalTo)
        
        let filterSet = Set([songFilter])
        
        let query = MPMediaQuery(filterPredicates: filterSet)
        
        
        
        controller.musicPlayer.setQueue(with: query)
        
        controller.musicPlayer.play()
        
        print(controller.musicPlayer.nowPlayingItem?.persistentID)
        
        //controller.musicPlayer.play()
        
        /*checkPerms()
        
        //SKCloudServiceController.requestUserToken(SKCloudServiceController)
        
        print(SKCloudServiceController.authorizationStatus().rawValue)
        
        let musicPlayer = MPMusicPlayerController.applicationQueuePlayer
        
        //musicPlayer.prepareToPlay()
        
        musicPlayer.setQueue(with: .songs())
        
        //musicPlayer.play()
        
        switch myStatus {
        case .denied:
            print ("denied")
            break
        case .authorized:
            print ("authorized")
            break
        default:
            print ("error")
            break
        }*/
        
        // Do any additional setup after loading the view.
    }
    
    
    // Function that prompts the user to grant permission to access their music library on first load.
    /*func checkPerms() -> Void {
        guard SKCloudServiceController.authorizationStatus() == .notDetermined else { return }
        
        print (SKCloudServiceController.authorizationStatus().rawValue)
        print (SKCloudServiceAuthorizationStatus.notDetermined.rawValue)
        
        SKCloudServiceController.requestAuthorization {(status: SKCloudServiceAuthorizationStatus) in
            switch status {
            case .denied, .restricted:  self.myStatus = .denied
            case .authorized: self.myStatus = .authorized
            default:
                print ("default")
                break
            }
        }
    }*/
    
    /*func requestPerms() {
        SKCloudServiceController.requestAuthorization(<#T##handler: (SKCloudServiceAuthorizationStatus) -> Void##(SKCloudServiceAuthorizationStatus) -> Void#>)
    }*/
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
