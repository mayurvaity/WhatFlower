//
//  ViewController.swift
//  WhatFlower
//
//  Created by Mayur Vaity on 19/05/24.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    //creating image picker obj
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //assigning delegate of image picker with self
        imagePicker.delegate = self
        //.camera to get image from camera
        imagePicker.sourceType = .camera
        //.camera to get image from photoLibrary
        //imagePicker.sourceType = .photoLibrary
        imagePicker.allowsEditing = false
    }
    
    //it is a delegate method, get called once image picker UIVC finishes getting a pic
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //one of the parameters info keeps data (including image taken), by specifying key we can get image
        // parameter info is a dictionary
        //using if-let to optional check image
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            //assigning this image to ImageVw
            imageView.image = userPickedImage
            
            
        }
        
        //need to dismiss this image picker UIVC and go back to original VC
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: Any) {
        //to call imagePicker uiviewcontroller
        present(imagePicker, animated: true, completion: nil)
        
    }
}

