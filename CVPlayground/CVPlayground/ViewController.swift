//
//  ViewController.swift
//  CVPlayground
//
//  Created by Daniel Haight on 05/02/2017.
//  Copyright © 2017 Daniel Haight. All rights reserved.
//

import UIKit
import AVFoundation
import OpenCVWrapper

class ViewController: UIViewController {
    
    let outputQueue = DispatchQueue(label: "com.cvplayground.imageprocessing")
    let imageView = UIImageView()
    let session = AVCaptureSession()

    override func viewDidLoad() {
        super.viewDidLoad()
        let a = OpenCVWrap().yolo()
        imageView.frame = self.view.bounds
        imageView.contentMode = .center
        self.view.addSubview(imageView)
        session.sessionPreset = AVCaptureSessionPreset352x288
        let device = AVCaptureDevice.defaultDevice(withMediaType:AVMediaTypeVideo)
        let input = try! AVCaptureDeviceInput(device:device)
        session.addInput(input)
        
        let output = AVCaptureVideoDataOutput()
        session.addOutput(output)
        output .setSampleBufferDelegate(self, queue: outputQueue)
        
        let connection = output.connection(withMediaType: AVMediaTypeVideo)
        connection?.videoOrientation = AVCaptureVideoOrientation.portrait
        
        session.startRunning()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        
        var imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!
        
        CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        
//        unsigned char *pixel = (unsigned char *)CVPixelBufferGetBaseAddress(pixelBuffer);
//        cv::Mat image = cv::Mat(bufferHeight,bufferWidth,CV_8UC4,pixel); //put buffer in open cv, no memory copied
//        //Processing here
//        [self processImage:image];
//        
//        //End processing
        CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
        
        let image = UIImage(ciImage: CIImage(cvImageBuffer: imageBuffer))
        
        DispatchQueue.main.async {
            self.imageView.image = image
        }

    }
    
}
