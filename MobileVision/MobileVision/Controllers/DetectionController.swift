//
//  DetectionController.swift
//  MobileVision
//
//  Created by Vlad Arsenyuk on 2/9/19.
//  Copyright © 2019 Arseniuk. All rights reserved.
//

import Foundation
import CoreImage

protocol DetectionControllerDelegate: class {
    func detectFaces(with detector: CIDetector)
    func detectText(with detector: CIDetector)
    func detectQrCode(with detector: CIDetector)
    func detectRecatangle(with detector: CIDetector)
}

class DetectionController {
    static let shared = DetectionController()
    
    weak var delegate: DetectionControllerDelegate?
    
    // MARK: - Public
    
    func changeDetection(with type: DetectionType) {
        switch type {
        case .face:
            shouldDetectFaces()
        case .text:
            shouldDetectTexts()
        case .qrCode:
            shouldDetectQrCodes()
        case .rectangle:
            shouldDetectRectangles()
        }
    }
    
    // MARK: - Private
    
    private func configDetector(for type: String) -> CIDetector? {
        let detector = CIDetector(ofType: type, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyHigh])
        return detector
    }
    
    private func shouldDetectFaces() {
        guard let detector = configDetector(for: CIDetectorTypeFace) else {
            return
        }
        
        delegate?.detectFaces(with: detector)
    }
    
    private func shouldDetectTexts() {
        guard let detector = configDetector(for: CIDetectorTypeText) else {
            return
        }
        
        delegate?.detectText(with: detector)
    }
    
    private func shouldDetectQrCodes() {
        guard let detector = configDetector(for: CIDetectorTypeQRCode) else {
            return
        }
        
        delegate?.detectQrCode(with: detector)
    }
    
    private func shouldDetectRectangles() {
        guard let detector = configDetector(for: CIDetectorTypeRectangle) else {
            return
        }
        
        delegate?.detectRecatangle(with: detector)
    }
}
