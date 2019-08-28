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
    static let radiansForDegree = { (degree: Double) in Double.pi * degree / 180 }

    enum Angles {
        static let radiansToTop: Double = -Double.pi / 2
        static let degreesToTop: Double = -90
    }
    
    @IBInspectable var lineColor: UIColor = UIColor.black
    @IBInspectable var thinLineWidth: CGFloat = 1
    @IBInspectable var wideLineWidth: CGFloat = 100

    @IBInspectable
    var percent: Double = 0 {
        didSet {
            setNeedsDisplay()
        }
    }
    
    @IBInspectable var startDegree: Double = 0
    @IBInspectable var endDegree: Double = 0
    @IBInspectable var offset: CGPoint = .zero
    
    override func awakeFromNib() {
        if let star = UIImage(named: "star_yel_l") {
            let mask = UIImageView(image: star)
            self.mask = mask
        }
    }
    
    override func draw(_ rect: CGRect) {
//        drawPieChartForPercent()
        drawDividedSector()
    }
    
    // MARK: - "wide arcs" implementation
    func drawDividedSector() {
        let x = bounds.midX
        let y = bounds.midY
        let enclosingRadius = sqrt(x*x + y*y)
        let offsetDistance = sqrt(offset.x*offset.x + offset.y*offset.y)
        wideLineWidth = enclosingRadius * 2
        
        let center = CGPoint(x: x + offset.x, y: y + offset.y)
        
        let radius = max(enclosingRadius, offsetDistance)
            
        drawArcInSegment(from: startDegree, till: endDegree, center: center, radius: radius, filledFraction: percent, fillColor: lineColor, unfillColor: UIColor.white)
    }
    
    /// Draw sector between startAngle and endAngle (in degrees from the top) filling the francion defined by percent with the fillColor, remaining part of sector with bgColor
    ///
    /// - Parameters:
    ///   - startAngleDegree: start angle of drawing sector in degrees - supposing that zero angle is at the very top
    ///   - endAngleDegree: end angle of drawing sector in degrees - supposing that zero angle is at the very top
    ///   - center: center of arc
    ///   - radius: radius of arc
    ///   - filledFraction: fraction of sector that will be colored with fillColor
    ///   - fillColor: color of sector conforming to filledFraction
    ///   - unfillColor: color of the rest of arc - aside from filledFraction
    private func drawArcInSegmentFromTop(from startAngle: Double, till endAngle: Double, center: CGPoint, radius: CGFloat, filledFraction: Double, fillColor: UIColor, unfillColor: UIColor) {
        drawArcInSegment(from: startAngle + Angles.degreesToTop, till: endAngle + Angles.degreesToTop, center: center, radius: radius, filledFraction: filledFraction, fillColor: fillColor, unfillColor: unfillColor)
    }
    
    /// Draw sector between startAngle and endAngle (in degrees from zero) filling the francion defined by percent with the fillColor, remaining part of sector with bgColor
    ///
    /// - Parameters:
    ///   - startAngleDegree: start angle of drawing sector in degrees - from trigonometric zero angle
    ///   - endAngleDegree: end angle of drawing sector in degrees - from trigonometric zero angle
    ///   - center: center of arc
    ///   - radius: radius of arc
    ///   - filledFraction: fraction of sector that will be colored with fillColor
    ///   - fillColor: color of sector conforming to filledFraction
    ///   - unfillColor: color of the rest of arc - aside from filledFraction
    private func drawArcInSegment(from startAngle: Double, till endAngle: Double, center: CGPoint, radius: CGFloat, filledFraction: Double, fillColor: UIColor, unfillColor: UIColor) {
        let filledFromAngle = CircleProgressView.radiansForDegree(startAngle)
        let unfilledToAngle = CircleProgressView.radiansForDegree(endAngle)
        let gap = endAngle - startAngle
        let filledToAngle = CircleProgressView.radiansForDegree(startAngle + filledFraction * gap)
        
        drawArcBetweenAngles(center: center, radius: radius, startAngle: filledFromAngle, endAngle: filledToAngle, color: fillColor)
        drawArcBetweenAngles(center: center, radius: radius, startAngle: filledToAngle, endAngle: unfilledToAngle, color: unfillColor)
    }
    
    private func drawArcBetweenAngles(center: CGPoint, radius: CGFloat, startAngle: Double, endAngle: Double, color: UIColor) {
        // DRAW JUST ARC with defined line width
        let arcPath = UIBezierPath(arcCenter: center, radius: radius, startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        color.setStroke()
        arcPath.lineWidth = wideLineWidth
        arcPath.stroke()
    }

    // MARK: - "pie chart sectors" implementation
    func drawPieChartForPercent() {
        guard percent > 0 else {
            return
        }
        
        // lineWidth = enclosingRadius * 2
        let x = bounds.midX
        let y = bounds.midY
        let enclosingRadius = sqrt(x*x + y*y)
        let offsetDistance = sqrt(offset.x*offset.x + offset.y*offset.y)
        
        let center = CGPoint(x: x + offset.x, y: y + offset.y)
        
        let radius = enclosingRadius + offsetDistance // - lineWidth / 2
        drawInitialSector(center: center, radius: Double(radius), till: percent, color: lineColor)
        drawFinalSector(center: center, radius: Double(radius), from: percent, color: UIColor.white)
    }

    /// draw filled piece of pie
    private func drawInitialSector(center: CGPoint, radius: Double, till percent: Double, color: UIColor) {
        let startAngle = Angles.radiansToTop
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

    /// draw arc from (0,-1) point to angle (percent from full circle)
    private func drawArcForPercent(center: CGPoint, radius: Double, percent: Double, color: UIColor) {
        // create arc
        let startAngle = CircleProgressView.radiansForPercent(-0.25)
        let endAngle = startAngle + CircleProgressView.radiansForPercent(percent)
        
        // DRAW JUST ARC with defined line width
        let arcPath = UIBezierPath(arcCenter: center, radius: CGFloat(radius), startAngle: CGFloat(startAngle), endAngle: CGFloat(endAngle), clockwise: true)
        UIGraphicsGetCurrentContext()?.setShadow(offset: CGSize.init(width: 0, height: 0), blur: 0, color: nil)
        color.setStroke()
        arcPath.lineWidth = thinLineWidth
        arcPath.stroke()
    }
    
}


