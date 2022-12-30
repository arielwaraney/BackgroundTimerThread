//
//  CircularProgressBarView.swift
//  BackgroundTimerThread
//
//  Created by Ariel Waraney on 30/12/22.
//

import UIKit

class CircularProgressBarView: UIView {
    
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)
    let STROKE_END = "strokeEnd"
    let PROGRESS_ANIMATION = "progressAnimation"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createCircularPath()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        createCircularPath()
    }
    
    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 150, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        //ui edits
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 10.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.systemGray3.cgColor
        layer.addSublayer(circleLayer)
        
        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10.0
        progressLayer.strokeEnd = 0.0
        progressLayer.strokeColor = UIColor.systemOrange.cgColor
        layer.addSublayer(progressLayer)
    }
    
    func progressAnimation(duration: TimeInterval, value: Float) {
        let circularProgressAnimation = CABasicAnimation(keyPath: STROKE_END)
        circularProgressAnimation.duration = duration
        circularProgressAnimation.toValue = value
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.strokeEnd = CGFloat(value)
        progressLayer.add(circularProgressAnimation, forKey: PROGRESS_ANIMATION)
    }
}
