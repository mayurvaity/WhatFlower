//
//  ViewController.swift
//  WhatFlower
//
//  Created by Mayur Vaity on 19/05/24.
//

import UIKit
import CoreML
import Vision
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var pageIDLabel: UILabel!
    
    //creating image picker obj
    let imagePicker = UIImagePickerController()
    
    //creating obj of model
    var wikiManager = WikiManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //assigning delegate of image picker with self
        imagePicker.delegate = self
        //.camera to get image from camera
        imagePicker.sourceType = .camera
        //.camera to get image from photoLibrary
        //imagePicker.sourceType = .photoLibrary
        
        //to allow editing of the captured photo, cropping in this case
        imagePicker.allowsEditing = true
        
        wikiManager.delegate = self
    }
    
    //it is a delegate method, get called once image picker UIVC finishes getting a pic
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //one of the parameters info keeps data (including image taken), by specifying key we can get image
        // parameter info is a dictionary
        //using if-let to optional check image
//        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        // to use edited image
        if let userPickedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            //assigning this image to ImageVw
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Failed while converting to CIImage.")
            }
            
            detect(flowerImage: ciimage)
            
        }
        
        //need to dismiss this image picker UIVC and go back to original VC
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func detect(flowerImage: CIImage) {
        //creating an obj of our CoreML model
        guard let model = try? VNCoreMLModel(for: FlowerClassifier().model) else {
            fatalError("Loading ML model failed.")
        }
        //creating a request to process that image
        let request = VNCoreMLRequest(model: model) { request, error in
            //getting result from request
            guard let result = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process image.")
            }
            
//            print(result)
            
            if let firstResult = result.first {
                
                let flowerName = firstResult.identifier.capitalized
                self.navigationItem.title = flowerName
                
                //calling getURL method
                self.wikiManager.getFinalURL(flowerName: flowerName)
            }
            
        }
        
        //to perform this request, it will need a handler, below is that handler
        let handler = VNImageRequestHandler(ciImage: flowerImage)
        
        //to perform this request
        do {
            try handler.perform([request])
        } catch {
            print("Error while performing request, \(error)")
        }
    }
    
    
    @IBAction func cameraButtonTapped(_ sender: UIBarButtonItem) {
        //to call imagePicker uiviewcontroller
        present(imagePicker, animated: true, completion: nil)
        
    }
}

extension ViewController: WikiManagerDelegate {
    func didUpdateWiki(_ wikiManager: WikiManager, wiki: WikiModel) {
        print("wiki.pageid: \(wiki.pageid)")
        DispatchQueue.main.async {
            self.navigationItem.title = wiki.pageid
        }
    }
    
    func didFailWithError(error: any Error) {
        print(error)
    }
}
