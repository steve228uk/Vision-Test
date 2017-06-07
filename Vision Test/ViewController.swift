//
//  ViewController.swift
//  Vision Test
//
//  Created by Stephen Radford on 07/06/2017.
//  Copyright © 2017 Cocoon Development Ltd. All rights reserved.
//

import UIKit
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performVisionRequest()
    }
    
    func performVisionRequest() {
        let request = VNImageRequestHandler(cgImage: #imageLiteral(resourceName: "People 2").cgImage!, options: [:])
        let rectRequest = VNDetectFaceRectanglesRequest { (request, error) in
            guard let observations = request.results as? [VNFaceObservation] else { return }
            self.process(observations: observations)
        }
        
        do {
            try request.perform([rectRequest])
        } catch {
            print(error)
        }
    }
    
    func process(observations: [VNFaceObservation]) {
        addShapes(forObservations: observations)
    }
    
    func addShapes(forObservations observations: [VNFaceObservation]) {
        let layers: [CAShapeLayer] = observations.map { observation in
            
            let w = observation.boundingBox.size.width * imageView.bounds.width
            let h = observation.boundingBox.size.height * imageView.bounds.height
            let x = observation.boundingBox.origin.x * imageView.bounds.width
            let y = abs(((observation.boundingBox.origin.y * (imageView.bounds.height)) - imageView.bounds.height)) - h
            
            print("----")
            print("W: ", w)
            print("H: ", h)
            print("X: ", x)
            print("Y: ", y)
            
            let layer = CAShapeLayer()
            layer.frame = CGRect(x: x , y: y, width: w, height: h)
            layer.borderColor = UIColor.red.cgColor
            layer.borderWidth = 2
            layer.cornerRadius = 3
            return layer
        }
        
        
        for layer in layers {
            imageView.layer.addSublayer(layer)
        }
    }
    
}

