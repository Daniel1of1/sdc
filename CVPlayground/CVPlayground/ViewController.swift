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

let outputQueue = DispatchQueue(label: "com.cvplayground.imageprocessing", qos: DispatchQoS.userInitiated, attributes: [], autoreleaseFrequency: DispatchQueue.AutoreleaseFrequency.inherit, target: nil)


class ViewController: UIViewController {
    
    let imageView = UIImageView()
    let session = AVCaptureSession()
    let cv2 = OpenCVWrap()
    override func viewDidLoad() {
        super.viewDidLoad()
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

    func convertCIImageToCGImage(inputImage: CIImage) -> CGImage! {
            let context = CIContext(options: nil)
            if context != nil {
                    return context.createCGImage(inputImage, from: inputImage.extent)
                }
            return nil
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {

        outputQueue.async {
            var imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)!

            CVPixelBufferLockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)
            let cg = self.convertCIImageToCGImage(inputImage:CIImage(cvImageBuffer: imageBuffer))
            let image = UIImage(cgImage:cg!)
            let processed = [image].map(self.cv2.gray).map(self.cv2.gauss).map(self.cv2.canny).map(self.cv2.hough).first!
            CVPixelBufferUnlockBaseAddress(imageBuffer, CVPixelBufferLockFlags.readOnly)


            DispatchQueue.main.async {
                self.imageView.image = processed
            }

        }
    }

    
}
