//
//  CoreMLViewController.swift
//  Vision Test
//
//  Created by Stephen Radford on 08/06/2017.
//  Copyright © 2017 Cocoon Development Ltd. All rights reserved.
//

import UIKit
import Vision

class CoreMLViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        performVisionRequest()
    }
    
    let model = Resnet50()
    
    func performVisionRequest() {
        let request = VNImageRequestHandler(cgImage: imageView.image!.cgImage!, options: [:])
        
        do {
            let m = try VNCoreMLModel(for: model.model)
            let coreMLRequest = VNCoreMLRequest(model: m) { (request, error) in
                guard let observation = request.results?.first as? VNClassificationObservation else { return }
                self.label.text = "\(observation.identifier) (\(observation.confidence * 100)%)"
            }
            try request.perform([coreMLRequest])
        } catch {
            print(error)
        }
        
    }
    
    

}
