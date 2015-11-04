//
//  ViewController.swift
//  iOSImageDetectionExample
//
//  Created by Christopher Williams on 11/3/15.
//  Copyright © 2015 Christopher Williams. All rights reserved.
//

import UIKit

// http://stackoverflow.com/questions/25146557/how-do-i-get-the-color-of-a-pixel-in-a-uiimage-with-swift
extension UIImage {
    func getPixelColor(pos: CGPoint) -> UIColor {
        // Read unscaled image's pixel data
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        // Which pixel index is the parameter wanting us to look at?
        let pixelInfo: Int = ((Int(self.size.width) * Int(pos.y)) + Int(pos.x)) * 4
        
        let r = CGFloat(data[pixelInfo]) / CGFloat(255.0)
        let g = CGFloat(data[pixelInfo+1]) / CGFloat(255.0)
        let b = CGFloat(data[pixelInfo+2]) / CGFloat(255.0)
        let a = CGFloat(data[pixelInfo+3]) / CGFloat(255.0)
        
        return UIColor(red: r, green: g, blue: b, alpha: a)
    }
}

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var switchView: UISwitch!
   
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        imagePicker.delegate = self
        
        // Tap image to load an image
        let tappedImageRecognizer = UITapGestureRecognizer(target: self, action: "loadImage:")
        imageView.addGestureRecognizer(tappedImageRecognizer)
        
        // Load initial image
        let image = UIImage(named: "not-white-1")!
        imageView.image = image
        
        // Update switch
        checkIfWhiteBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Takes in a UIImage and returns if it has a white background or not
    func isWhiteBackground(image: UIImage?) -> Bool {
        // TODO
        return true
    }
    
    func checkIfWhiteBackground() {
        let isWhite = isWhiteBackground(imageView.image)
        
        switchView.setOn(isWhite, animated: true)
    }
    
    // Image view was tapped, let user choose image from their photo library
    func loadImage(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            imagePicker.allowsEditing = false
            imagePicker.sourceType = .PhotoLibrary
            
            presentViewController(imagePicker, animated: true, completion: nil)
        }
    }
    
    // Load new image and update switch
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        imageView.image = image
        
        checkIfWhiteBackground()
        
        dismissViewControllerAnimated(true, completion: nil)
    }
}