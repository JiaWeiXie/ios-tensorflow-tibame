//
//  ViewController.swift
//  HelloHandWritting
//
//  Created by 謝佳瑋 on 2018/11/10.
//  Copyright © 2018 ml. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var drawBaseView: UIView!
    @IBOutlet weak var buttonStack: UIStackView!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var predictButton: UIButton!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageView: UIImageView!
    
    
    var drawableView: DrawableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        clearButton.addTarget(self, action: #selector(self.clearTap), for: .touchUpInside)
        predictButton.addTarget(self, action: #selector(self.predictTap), for: .touchUpInside)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        createDrawableView()
    }

    
    @objc func clearTap() {
        createDrawableView()
        textView.text = ""
        imageView.image = nil
    }
    
    @objc func predictTap() {
        let orgImage = drawableView.toImage()
        let size = CGSize(width: 28, height: 28)
        guard let resizeImage = orgImage.resize(to: size)  else {
            assertionFailure("Fail to resize image.")
            return
        }
        
        imageView.image = resizeImage
        
        let model = MNIST()
        
        guard let result = try? model.prediction(image: resizeImage.pixelBuffer()!) else {
            assertionFailure("Fail to predict image.")
            return
        }
        
        
        let info = result.prediction
            .reduce("\(result.classLabel) ==> \n")
            {
                "\($0)\($1.key): \($1.value)\n"
            }
        // var info = "\(result.classLabel) ==> \n"
        // info += result.prediction.map {
        //              "\($0.key): \($0.value)"
        //          }.joined(separator: "\n")
        
        textView.text = info + textView.text
        createDrawableView()
    }
    
    
    func createDrawableView() {
        
        if drawableView != nil {
            drawableView.removeFromSuperview()
        }
        
        drawableView = DrawableView(frame: drawBaseView.bounds)
        drawableView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        drawableView.backgroundColor = UIColor(netHex: 0x1A1A1A)
        drawableView.isUserInteractionEnabled = true
        drawBaseView.addSubview(drawableView)
    }
    
}


extension UIView {
    
    
    func toImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        let image = renderer.image { (context) in
            self.drawHierarchy(in: self.bounds, afterScreenUpdates: true)
        }
        return image
    }
    
}
