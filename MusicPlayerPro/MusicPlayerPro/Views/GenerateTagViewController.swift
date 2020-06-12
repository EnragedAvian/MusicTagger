//
//  GenerateTagViewController.swift
//  MusicPlayerPro
//
//  Created by Cameron Bossalini on 6/10/20.
//  Copyright © 2020 Cameron Bossalini. All rights reserved.
//

import UIKit

// View controller which generates new tags
class GenerateTagViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var tagNameInput: UITextField!
    @IBOutlet weak var submitButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set cornerRadius for submit button
        submitButton.layer.cornerRadius = 10
        
        // set the delegate for the tag name input as this view controller
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

    // Submit function
    @IBAction func pressSubmit(_ sender: Any) {
        let controller = (UIApplication.shared.delegate as! AppDelegate).tagController
        // If there is no text input, don't do anything
        if tagNameInput.text != "" {
            // unwrap the text present in the input and store generate a new tag using the input
            guard let unwrappedText: String = tagNameInput.text else {
                print("Couldn't read tag name")
                return
            }
            print(controller.createTag(tagName: unwrappedText))
        }
        // dismiss the view controller, returning to the root view controller
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
