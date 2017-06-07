//
//  LandmarksViewController.swift
//  Vision Test
//
//  Created by Stephen Radford on 07/06/2017.
//  Copyright © 2017 Cocoon Development Ltd. All rights reserved.
//

import UIKit
import Vision

class LandmarksViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performVisionRequest()
    }
    
    func performVisionRequest() {
        let request = VNImageRequestHandler(cgImage: imageView.image!.cgImage!, options: [:])
        
        let landmarksRequest = VNDetectFaceLandmarksRequest { (request, error) in
            guard let observations = request.results as? [VNFaceObservation] else { return }
            self.process(observations: observations)
        }
        
        do {
            try request.perform([landmarksRequest])
        } catch {
            print(error)
        }
    }
    
    func process(observations: [VNFaceObservation]) {
        addShapes(forObservations: observations)
    }
    
    func addShapes(forObservations observations: [VNFaceObservation]) {
        
        var layers = [CAShapeLayer]()
        
        for observation in observations {
            
            let boundingBox = scaledRect(fromRect: observation.boundingBox)
            
            let boundingLayer = CAShapeLayer()
            boundingLayer.frame = boundingBox
            boundingLayer.borderColor = UIColor.red.cgColor
            boundingLayer.borderWidth = 2
            boundingLayer.cornerRadius = 3
            
            
            let pointer = observation.landmarks?.allPoints?.points
            
            for i in 0..<999 {
                guard let pointer = pointer?.advanced(by: i) else { break }
                let vector = pointer.pointee
                
                let layer = CAShapeLayer()
                
                let x = CGFloat(vector.x) * boundingBox.size.width
                let y = abs(((CGFloat(vector.y) * (boundingBox.size.height)) - boundingBox.size.height))
                
                layer.frame = CGRect(x: x, y: y, width: 2, height: 2)
                layer.backgroundColor = UIColor.green.cgColor
                layer.cornerRadius = 1
                boundingLayer.addSublayer(layer)
            }
            
            layers.append(boundingLayer)
        }
        
        for layer in layers {
            imageView.layer.addSublayer(layer)
        }
    }
    
    func scaledRect(fromRect rect: CGRect) -> CGRect {
        let w = rect.size.width * imageView.bounds.width
        let h = rect.size.height * imageView.bounds.height
        let x = rect.origin.x * imageView.bounds.width
        let y = abs(((rect.origin.y * (imageView.bounds.height)) - imageView.bounds.height)) - h
        
        return CGRect(x: x , y: y, width: w, height: h)
    }

}
