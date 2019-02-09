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
    
    private lazy var session: AVCaptureSession = {
        let session = AVCaptureSession()
        session.sessionPreset = .high
        guard let captureDevice = captureDevice,
            let input = try? AVCaptureDeviceInput(device: captureDevice),
            session.canAddInput(input) else {
            return session
        }
        
        session.addInput(input)
        
        if session.canAddOutput(photoCaptureOutput) {
            session.addOutput(photoCaptureOutput)
        }
        return session
    }()
    
    private lazy var captureDevice: AVCaptureDevice? = {
        return AVCaptureDevice.default(for: .video)
    }()
    
    private lazy var photoCaptureOutput: AVCapturePhotoOutput = {
        return AVCapturePhotoOutput()
    }()
    
    private lazy var videoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: session)
        videoPreviewLayer.videoGravity = .resizeAspect
        videoPreviewLayer.connection?.videoOrientation = .portrait
        return videoPreviewLayer
    }()
    
    // MARK: - Overrides
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
    
    private func configureUI() {
        configureCaptureUI()
    }
    
    private func configureCaptureUI() {
        previewAreaView.layer.addSublayer(videoPreviewLayer)
        session.startRunning()
    }
}

