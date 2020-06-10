//
//  GenerateTagViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit

class GenerateTagViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tagNameInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 10
        
        self.tagNameInput.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    // overriding touchesEnded function to minimize the keyboard whenever a touch event ends within the view
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
        super.touchesEnded(touches, with: event)
    }
    
    // defining function which hides the keyboard after pressing the return key
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }

    @IBAction func pressSubmit(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).tagController
        if tagNameInput.text != "" {
            guard let unwrappedText: String = tagNameInput.text else {
                print("Couldn't read tag name")
                return
            }
            print(controller.createTag(tagName: unwrappedText))
        }
        self.dismiss(animated: true, completion: {})
        self.navigationController?.popViewController(animated: true)
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
