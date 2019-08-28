//
//  ViewController.swift
//  AlphaMaskTest
//
//  Created by Elena Demidova on 20/08/2019.
//  Copyright © 2019 Elena Demidova. All rights reserved.
//

import UIKit
import CoreGraphics


class ViewController: UIViewController {
    @IBOutlet var topImageView: UIImageView!
    @IBOutlet var bottomImageView: UIImageView!

    @IBOutlet var progressView: CircleProgressView!

    private let gradientLayer = CAGradientLayer()
    private var completeness: Double = 0
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addGradientBackground()

        progressView.percent = 0

        timer = Timer.scheduledTimer(withTimeInterval: 0.3, repeats: true) { [weak self] _ in
            guard let self = self else { return }

            self.completeness += 0.05
            let percent = self.completeness.truncatingRemainder(dividingBy: 1)

            self.progressView.percent = self.processPercentValue(percent)
        }
    }
    
    private func processPercentValue(_ percent: Double) -> Double {
        var newValue = percent
        if percent > 0, percent < 0.3 {
            newValue = 0.15 + percent / 2
        } else if percent > 0.7, percent < 1 {
            newValue = 0.35 + percent / 2
        }
        
        return newValue
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    private func addGradientBackground() {
        gradientLayer.frame = view.frame
//        gradientLayer.type = .radial
        gradientLayer.locations = [NSNumber(value: 0.24), NSNumber(value: 0.4), NSNumber(value: 0.47), NSNumber(value: 0.52), NSNumber(value: 0.6), NSNumber(value: 0.8)]
        gradientLayer.startPoint = CGPoint(x: 0.2, y: 1)
        gradientLayer.endPoint = CGPoint(x: 0.8, y: 0)
        gradientLayer.colors = [UIColor.magenta.cgColor, UIColor.purple.cgColor, UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor, UIColor.darkGray.cgColor]
        view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    private func addCircleProgressView(into view: UIView) {
        let progress = CircleProgressView()
        progress.percent = 0.2
        let targetFrame = view.frame
        progress.frame = targetFrame// CGRect(x: -targetFrame.width, y: targetFrame.height, width: targetFrame.width * 2, height: targetFrame.height * 2)
        view.addSubview(progress)
    }
}

// useless
/*
 extension UIImage {
    
    func createMask() -> CGImage? {
        guard let maskImageRef = self.cgImage,
            let provider = maskImageRef.dataProvider else {
                return nil
        }
        return CGImage(maskWidth: maskImageRef.width, height: maskImageRef.height, bitsPerComponent: maskImageRef.bitsPerComponent, bitsPerPixel: maskImageRef.bitsPerPixel, bytesPerRow: maskImageRef.bytesPerRow, provider: provider, decode: nil, shouldInterpolate: true)
    }


    func imageMasked(with imageForMask: UIImage) -> UIImage? {
        var maskedImage: CGImage?

        if let mask = imageForMask.createMask() {
            let sourceImage = self.cgImage
            let alpha = sourceImage?.alphaInfo
            if alpha == CGImageAlphaInfo.premultipliedLast {
                maskedImage = sourceImage?.masking(mask)
            }
        }

        if let maskedImage = maskedImage {
            return UIImage(cgImage: maskedImage)
        } else {
            return nil
        }
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
*/
