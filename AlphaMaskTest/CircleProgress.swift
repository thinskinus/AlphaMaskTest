//
//  CircleProgressView.swift
//  Lenta
//
//  Created by ElenaD on 8/1/19.
//  Copyright © 2019 Lenta. All rights reserved.
//

import UIKit

class CircleProgressView: UIView {
    
    static let radiansForPercent = { (percent: Double) in 2 * Double.pi * percent }
    
    @IBInspectable var lineColor: UIColor = UIColor.black
    @IBInspectable var lineWidth: CGFloat = 1
    
    @IBInspectable
    var percent: Double = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable
    var offset: CGPoint = .zero
    
    override func draw(_ rect: CGRect) {
        guard percent > 0 else {
               return
        }
        
        let center = CGPoint(x: bounds.midX + offset.x, y: bounds.midY + offset.y)
        let radius = max(center.x, center.y) + max(abs(offset.x), abs(offset.y)) // - lineWidth / 2
        drawInitialSector(center: center, radius: Double(radius), till: percent, color: lineColor)
        drawFinalSector(center: center, radius: Double(radius), from: percent, color: UIColor.white)
    }
    
    /// draw arc
    private func drawArcBesierPath(center: CGPoint, radius: Double, percent: Double, color: UIColor) {
        // create arc
        let startAngle = CircleProgressView.radiansForPercent(-0.25)
        let endAngle = startAngle + CircleProgressView.radiansForPercent(percent)

        // DRAW JUST ARC with defined line width
        let arcPath = UIBezierPath(arcCenter: center, radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        UIGraphicsGetCurrentContext()?.setShadow(offset: CGSize.init(width: 0, height: 0), blur: 0, color: nil)
        color.setStroke()
        arcPath.lineWidth = lineWidth
        arcPath.stroke()
    }
    
    /// draw filled piece of pie
    private func drawInitialSector(center: CGPoint, radius: Double, till percent: Double, color: UIColor) {
        let startAngle = CircleProgressView.radiansForPercent(-0.25)
        let endAngle = startAngle + CircleProgressView.radiansForPercent(percent)
        let sectorPath = UIBezierPath()
        
        sectorPath.move(to: center)
        sectorPath.addArc(withCenter: center, radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        sectorPath.close()
        
        color.setFill()
        sectorPath.fill()
    }

    private func drawFinalSector(center: CGPoint, radius: Double, from percent: Double, color: UIColor) {
        let endAngle = CircleProgressView.radiansForPercent(-0.25)
        let startAngle = endAngle + CircleProgressView.radiansForPercent(percent)

        let sectorPath = UIBezierPath()
        sectorPath.move(to: center)
        sectorPath.addArc(withCenter: center, radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        sectorPath.close()
        
        color.setFill()
        sectorPath.fill()
    }
}


