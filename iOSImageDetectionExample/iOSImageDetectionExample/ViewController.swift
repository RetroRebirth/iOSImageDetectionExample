//
//  ViewController.swift
//  iOSImageDetectionExample
//
//  Created by Christopher Williams on 11/3/15.
//  Copyright © 2015 Christopher Williams. All rights reserved.
//

import UIKit

extension UIImage {
    // Does this UIImage have a white background?
    func hasWhiteBackground() -> Bool {
        // Measurement constants
        let minConfidence = 0.9 // Minimum % confidence threshold
        let cornerSize = 40 // Size of corners as squares to check (in pixel units)
        
        // Measurement variables
        var confidence = 0.0 // What percentage of what we checked is white?
        var numPixels = 0 // Number of pixels we checked
        
        // Obtain width and height
        let width = Int(self.size.width)
        let height = Int(self.size.height)
        
        // Obtain pixel's color data to analyze
        let pixelData = CGDataProviderCopyData(CGImageGetDataProvider(self.CGImage))
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        // Check the borders
        for x in 0...width-1 {
            // Along the left and right, check the whole row
            if x == 0 || x == width-1 {
                for y in 0...height-1 {
                    if checkPixel(CGPoint(x: x, y: y), data: data) {
                        confidence++
                    }
                    numPixels++
                }
            // Otherwise, just check the top and bottom
            } else {
                if checkPixel(CGPoint(x: x, y: 0), data: data) {
                    confidence++
                }
                if checkPixel(CGPoint(x: x, y: height-1), data: data) {
                    confidence++
                }
                numPixels += 2
            }
        }
        
        // Check the corners
        for x in 1...cornerSize {
            for y in 1...cornerSize {
                if checkPixel(CGPoint(x: x, y: y), data: data) { // top-left
                    confidence++
                }
                if checkPixel(CGPoint(x: width-x-1, y: y), data: data) { // top-right
                    confidence++
                }
                if checkPixel(CGPoint(x: x, y: height-y-1), data: data) { // bottom-left
                    confidence++
                }
                if checkPixel(CGPoint(x: width-x-1, y: height-y-1), data: data) { // bottom-right
                    confidence++
                }
                numPixels += 4
            }
        }
        
        // Normalize confidence so it is 0-1 probability
        confidence /= (Double)(numPixels)
//        print("\(confidence*100)% confidence. Minimum is \(minConfidence*100)%.")
        
        return confidence >= minConfidence
    }
    
    // Checks the pixel at the specific position to see if it is white enough or not
    func checkPixel(pos: CGPoint, data: UnsafePointer<UInt8>) -> Bool {
        // Minimum amount of white for a pixel to be considered white
        let minWhite: CGFloat = 0.9
        
        // Read the pixel's color in terms of grayscale
        let curPixelColor = self.getPixelColor(pos, data: data)
        var white:CGFloat = 0
        curPixelColor.getWhite(&white, alpha: nil)
        
        // Is the pixel white enough?
        return white >= minWhite
    }
    
    // http://stackoverflow.com/questions/25146557/how-do-i-get-the-color-of-a-pixel-in-a-uiimage-with-swift
    // Obtain the UIColor of a pixel in the image
    func getPixelColor(pos: CGPoint, data: UnsafePointer<UInt8>) -> UIColor {
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
        imageView.image = UIImage(named: "white-3")!
        
        // Update switch
        checkIfWhiteBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfWhiteBackground() {
        let isWhite = imageView.image!.hasWhiteBackground()
        
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
        
        dismissViewControllerAnimated(true, completion: {
            () -> Void in
            self.checkIfWhiteBackground()
        })
    }
}