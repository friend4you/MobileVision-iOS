//
//  MainViewController.swift
//  MobileVision
//
//  Created by Vlad Arsenyuk on 2/9/19.
//  Copyright © 2019 Arseniuk. All rights reserved.
//

import UIKit
import AVFoundation

class MainViewController: UIViewController {

    // MARK: - Public Var
    
    var currentFeatureDetector: CIDetector?
    
    // MARK: - Private Vars
    
    private let queue = DispatchQueue(label: "output.queue")
    private var session: AVCaptureSession = AVCaptureSession()
    
    private lazy var captureDevice: AVCaptureDevice? = {
        return AVCaptureDevice.default(for: .video)
    }()
    
    private lazy var videoCaptureOutput: AVCaptureVideoDataOutput = {
        let output = AVCaptureVideoDataOutput()
        output.videoSettings = [kCVPixelBufferPixelFormatTypeKey as String : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)]
        output.alwaysDiscardsLateVideoFrames = true
        return output
    }()
    
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        return videoPreviewLayer
    }()
    
    // MARK: -  Outlets
    
    @IBOutlet weak var previewAreaView: UIView!
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureDependencies()
        configureUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        videoPreviewLayer.frame = previewAreaView.bounds
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    // MARK: - Private
    
    private func configureDependencies() {
        setupSession()
        DetectionController.shared.delegate = self
    }
    
    private func configureUI() {
        configureCaptureUI()
    }
    
    private func configureCaptureUI() {
        previewAreaView.layer.addSublayer(videoPreviewLayer)
        session.startRunning()
    }
    
    private func setupSession() {
        session.sessionPreset = .high
        guard let captureDevice = captureDevice,
            let input = try? AVCaptureDeviceInput(device: captureDevice),
            session.canAddInput(input) else {
                return
        }
        
        session.addInput(input)
        
        if session.canAddOutput(videoCaptureOutput) {
            session.addOutput(videoCaptureOutput)
        }
        
        session.commitConfiguration()
        videoCaptureOutput.setSampleBufferDelegate(self, queue: queue)

    }
}

extension MainViewController: DetectionControllerDelegate {

    
    func detectFaces(with detector: CIDetector) {
        currentFeatureDetector = detector
        print(detector)
    }
    
    func detectText(with detector: CIDetector) {
        currentFeatureDetector = detector
        print(detector)
    }
    
    func detectQrCode(with detector: CIDetector) {
        currentFeatureDetector = detector
        print(detector)
    }
    
    func detectRecatangle(with detector: CIDetector) {
        currentFeatureDetector = detector
        print(detector)
    }
}


extension MainViewController: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer)
        let attachments = CMCopyDictionaryOfAttachments(allocator: kCFAllocatorDefault, target: sampleBuffer, attachmentMode: kCMAttachmentMode_ShouldPropagate)
        let ciImage = CIImage(cvImageBuffer: pixelBuffer!, options: attachments as! [CIImageOption : Any]?)
        let options: [String : Any] = [CIDetectorImageOrientation: exifOrientation(orientation: UIDevice.current.orientation),
                                       CIDetectorSmile: true,
                                       CIDetectorEyeBlink: true]
        let allFeatures = currentFeatureDetector?.features(in: ciImage, options: options)
        guard let features = allFeatures else { return }
        
        for feature in features {
            print("Rect --- \(feature.bounds)")
        }
    }
    
    func exifOrientation(orientation: UIDeviceOrientation) -> Int {
        switch orientation {
        case .portraitUpsideDown:
            return 8
        case .landscapeLeft:
            return 3
        case .landscapeRight:
            return 1
        default:
            return 6
        }
    }
}
