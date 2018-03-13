//
//  SecondViewController.swift
//  PXL-2001
//
//  Created by Joshua Fingert on 10/18/17.
//  Copyright © 2017 Joshua Fingert. All rights reserved.
//

import UIKit
import GPUImage

class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    let imagePicker: UIImagePickerController! = UIImagePickerController()
    let saveFileName = "/test.mp4"

    @IBOutlet weak var theImage: UIImageView!
    
    @IBAction func capture(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
            
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            print(imagePicker.sourceType)
            self.present(imagePicker, animated: true, completion: nil)
            
        }
    }
    
    @IBAction func save(_ sender: Any) {
        UIImageWriteToSavedPhotosAlbum(theImage.image!, self, #selector(saveImage(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            //            let toonFilter = SmoothToonFilter()
            let luminanceFilter = Luminance()
            let pixelate = Pixellate()
            
            let filteredImage = pickedImage.filterWithPipeline{input, output in
                input --> luminanceFilter --> pixelate --> output
            }
            
            theImage.contentMode = .scaleAspectFit
            
            theImage.image = filteredImage
            print("!@#$%$%$$^$$^%$^%$")
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    
    
    /////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

