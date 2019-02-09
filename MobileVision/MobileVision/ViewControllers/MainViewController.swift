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
    
    @IBOutlet weak var previewAreaView: UIView!
    
    private var session: AVCaptureSession = AVCaptureSession()
    
    private lazy var captureDevice: AVCaptureDevice? = {
        return AVCaptureDevice.default(for: .video)
    }()
    
    private lazy var photoCaptureOutput: AVCapturePhotoOutput = {
        return AVCapturePhotoOutput()
    }()
    
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = .resizeAspectFill
        videoPreviewLayer.connection?.videoOrientation = .portrait
        return videoPreviewLayer
    }()
    
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
        
        if session.canAddOutput(photoCaptureOutput) {
            session.addOutput(photoCaptureOutput)
        }
    }
}

extension MainViewController: DetectionControllerDelegate {
    func detectFaces(with detector: CIDetector) {
        print(detector)
    }
    
    func detectText(with detector: CIDetector) {
        print(detector)
    }
    
    func detectQrCode(with detector: CIDetector) {
        print(detector)
    }
    
    func detectRecatangle(with detector: CIDetector) {
        print(detector)
    }
    
    
}
