//
//  ViewController.swift
//  HelloVision
//
//  Created by 謝佳瑋 on 2018/11/11.
//  Copyright © 2018 ml. All rights reserved.
//

import UIKit
import AVFoundation
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var resultsLabel: UILabel!
    @IBOutlet weak var previewView: UIView!
    
    let session = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer!
    let captureQueue = DispatchQueue(label: "BackgroundCapture")
    var requests = [VNRequest]()
    let minConfidence: VNConfidence = 0.4
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.layoutIfNeeded()
        setupCamera()
        setupML()
        
        session.startRunning()
    }

    
    private func setupCamera() {
        /// prepare to capture video from camera.
        guard let captureDevice = AVCaptureDevice.default(for: .video),
            let inputDevice = try? AVCaptureDeviceInput(device: captureDevice)
            else {
                assertionFailure("Fail to have video capture device.")
                return
        }
        session.addInput(inputDevice)
        
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.frame = previewView.bounds
        previewView.layer.addSublayer(previewLayer)
        
        let videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: captureQueue)
        videoOutput.alwaysDiscardsLateVideoFrames = true
        videoOutput.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA]
        videoOutput.connection(with: .video)?.videoOrientation = .portrait
        session.addOutput(videoOutput)
    }
    
    private func setupML() {
        //let model = Inceptionv3().model
        let model = PetsClassifier().model
        guard let visionModel = try? VNCoreMLModel(for: model) else {
            assertionFailure("Fail to create VNCoreMLModel.")
            return
        }
        let classificationRequest = VNCoreMLRequest(
            model: visionModel,
            completionHandler: classificationRequestHandler)
        classificationRequest.imageCropAndScaleOption = .centerCrop
        requests = [classificationRequest]
    }
    
    private func classificationRequestHandler(request: VNRequest, error: Error?){
        if let error = error {
            print("Error: ", error)
            return
        }
        
        guard let observations = request.results as? [VNClassificationObservation]
        else {
            print("No result.")
            return
        }
        
        let results = observations
            .filter {
                $0.confidence > minConfidence
            }
            .map {
                "\($0.identifier) " + String(format: "%.2f\n", $0.confidence)
            }.joined()
        
        DispatchQueue.main.async {
            if !results.isEmpty {
                self.resultsLabel.text = results
            }
        }
        
    }
}

extension ViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        guard let pixedBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        connection.videoOrientation = .portrait
        
        var optins = [VNImageOption: Any]()
        
        if let intrinsicData = CMGetAttachment(sampleBuffer,
                                               key: kCMSampleBufferAttachmentKey_CameraIntrinsicMatrix,
                                               attachmentModeOut: nil) {
            optins = [.cameraIntrinsics: intrinsicData]
        }
        let handler = VNImageRequestHandler(
            cvPixelBuffer: pixedBuffer,
            orientation: .upMirrored,
            options: optins)
        try? handler.perform(requests)
        
    }
}
