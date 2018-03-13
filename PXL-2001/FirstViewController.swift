//
//  FirstViewController.swift
//  PXL-2001
//
//  Created by Joshua Fingert on 10/18/17.
//  Copyright © 2017 Joshua Fingert. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MobileCoreServices
import GPUImage

class FirstViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVPlayerViewControllerDelegate {
    var isRecording = false
    
    @IBOutlet weak var renderView: RenderView!
    
    struct GlobalVariables {
        static var isVideo = Bool()
        static var videoUrl = String()
        static var pickedVideo = Data()
        static var videoPath = String()
        static var outputVideoPath = URL(string:"filteredOutput.mp4")
//        static var movie = MovieInput()
    }
    
    @IBAction func capture(_ sender: Any) {
        if UIImagePickerController.availableCaptureModes(for: .rear) != nil {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.delegate = self
            
            self.present(imagePicker, animated: true, completion: nil)
        } else {
            let ac = UIAlertController(title: "Rear camera doesn't exist", message: "Application cannot access the camera.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedVideo:URL = (info[UIImagePickerControllerMediaURL] as? URL) {
            print("!!!")
            
            
            if let videoUrlString = info[UIImagePickerControllerMediaURL] {
                
                
                let videoData = try? Data(contentsOf: pickedVideo)
                //                print(String(describing: videoData))
                //                print(pickedVideo)
                GlobalVariables.pickedVideo = videoData!
                GlobalVariables.isVideo = true
                GlobalVariables.videoPath = pickedVideo.relativePath
                GlobalVariables.videoUrl = (videoUrlString as AnyObject).absoluteString as String!
                
                let bundleURL = Bundle.main.resourceURL!
                print("bunde")
                print(bundleURL)
                let movieURL = URL(string:GlobalVariables.videoUrl)!
                print("movieUrl")
                print(movieURL)
                if let movie = try? MovieInput(url:movieURL, playAtActualSpeed:true) {
                    print("movie!")
                    print(movie)
                    
                    let luminanceFilter = Luminance()
                    let pixelate = Pixellate()

                    movie --> luminanceFilter --> pixelate --> renderView
//                                    GlobalVariables.movie = movie
                    movie.start()
                    
                } else {
                    print("ELSE!!!!!!!!!!!")
                }
                
                
                
                
                
//                let player = AVPlayer(url: videoUrlString as! URL)
//                let playerLayer = AVPlayerLayer(player: player)
//                playerLayer.frame = self.view.bounds
//                self.view.layer.addSublayer(playerLayer)
//                player.play()
                
            }
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func save(_ sender: Any) {
        var paths: [AnyObject] = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true) as [AnyObject]
        print("paths")
        print(paths)
//        let filePath = paths[0].appending("/image.mov")
        let selectorToCall = #selector(saveImage(_:didFinishSavingWithError:contextInfo:))
        UISaveVideoAtPathToSavedPhotosAlbum(paths[0] as! String, self, selectorToCall, nil)
//        let movieURL = URL(string:GlobalVariables.videoUrl)!
//        if let movie = try? MovieInput(url:movieURL, playAtActualSpeed:true) {
//            print("renderView!")
//            //                                    print(renderView)
//            let luminanceFilter = Luminance()
//            let pixelate = Pixellate()
//
//            movie --> luminanceFilter --> pixelate --> GlobalVariables.outputVideoPath
//            //                                    GlobalVariables.movie = movie
////            movie.start()
//
//        }
        
    }
    
    @objc func saveImage(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered video has been saved to your library.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    
    
    
    
    
    
    //////////////////////
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }


}

