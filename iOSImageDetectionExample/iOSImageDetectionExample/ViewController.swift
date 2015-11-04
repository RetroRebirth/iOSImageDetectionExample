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

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var switchView: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // TODO Tap image to load an image
        let image = UIImage(named: "not-white-1")!
        imageView.image = image
        
        let width = image.size.width - 1
        let height = image.size.height - 1
        
        print("0, 0: \(image.getPixelColor(CGPoint(x: 0, y: 0)))")
        print("\(width), \(height): \(image.getPixelColor(CGPoint(x: width, y: height)))")
        print("\(width/2), \(height/2): \(image.getPixelColor(CGPoint(x: width/2, y: height/2)))")
        
        // TODO Turn switch on/off to show if image has a white background
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}