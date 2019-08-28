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

/*
     
// THIS DOESN'T WORK
     
        let components: [CGFloat] = [0, 255]

        let starCGImage = UIImage(named: "star2")?.cgImage//.copy(colorSpace: CGColorSpaceCreateDeviceGray())
        if let starCGMask = starCGImage?.copy(maskingColorComponents: components) {
            let starMask = UIImage(cgImage: starCGMask)
            centerImageView.mask = UIImageView(image: starMask)
        }

        let boomCGImage = UIImage(named: "boom")?.cgImage
        if let boomMask = boomCGImage?.copy(maskingColorComponents: components) {
            centerImageView.image = UIImage(cgImage: boomMask)
        }
     
        let bgImage = UIImage(named: "bg")?.cgImage
        if let result = bgImage?.masking(starCGImage!) {
            centerImageView.image = UIImage(cgImage: result)
        }
*/

    
// THIS WORKS
    
//        if let star = UIImage(named: "star") {
//            topImageView.image = UIImage(named: "bg")
//            let mask = UIImageView(image: star)
//            mask.frame = topImageView.frame
//            topImageView.mask = mask
//        }
//
//        if let result = UIImage(named: "bg")?.imageMasked(with: UIImage(named: "starrr")!) {
//            bottomImageView.image = result
//        }
    
    private func addGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = view.frame
//        gradientLayer.type = .radial
        gradientLayer.locations = [NSNumber(value: 0.4), NSNumber(value: 0.5), NSNumber(value: 0.6), NSNumber(value: 0.7), NSNumber(value: 0.96)]
        gradientLayer.colors = [UIColor.purple.cgColor, UIColor.yellow.cgColor, UIColor.red.cgColor, UIColor.green.cgColor, UIColor.blue.cgColor]
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

