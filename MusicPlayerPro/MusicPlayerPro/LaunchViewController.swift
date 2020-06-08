//
//  LaunchViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/8/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit
import StoreKit

class LaunchViewController: UIViewController {

    var myStatus = SKCloudServiceAuthorizationStatus.notDetermined
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        determinePerms()
        
        
        print(myStatus.rawValue)
        
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
        }
        
        // Do any additional setup after loading the view.
    }
    
    func determinePerms() -> Void {
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
