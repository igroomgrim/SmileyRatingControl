//
//  SMLRatingControl.swift
//  Smiley
//
//  Created by Anak Mirasing on 11/19/2559 BE.
//  Copyright © 2559 iGROOMGRiM. All rights reserved.
//

import UIKit

class SMLRatingControl: UIControl {
    
    fileprivate var startingPoint = CGPoint(x: 0, y: 0)
    fileprivate var currentPoint = CGPoint(x: 0, y: 0)
    fileprivate var lastPoint = CGPoint(x: 0, y: 0)
    fileprivate var deltaY: CGFloat = 0.0
    fileprivate var lastDeltaY: CGFloat = 0.0
    fileprivate var factor: CGFloat = 0.0
    
    fileprivate var ovalLine: CAShapeLayer!
    fileprivate var smileyLine: CAShapeLayer!
    
    fileprivate var contentView: UIView!
    
    fileprivate let ratingPointLabel = UILabel()
    fileprivate let ratingPointDetailLabel = UILabel()
    fileprivate let howToLabel = UILabel()
    
    var rating: Float = 0.0
    
    init() {
        let frame = UIScreen.main.bounds
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        self.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.backgroundColor = UIColor.white
        
        contentView = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.width - 40, height: self.frame.width - 40))
        self.addSubview(contentView)
    
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 40).isActive = true
        contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -40).isActive = true
        contentView.heightAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        
        
        ovalLine = CAShapeLayer()
        ovalLine.path = drawOValLinePath()
        ovalLine.lineWidth = 6.0
        ovalLine.strokeColor = UIColor(red:0.15, green:0.55, blue:0.87, alpha:1.0).cgColor
        ovalLine.fillColor = nil
        contentView.layer.addSublayer(ovalLine)
        
        
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panOnView(_:)))
        self.addGestureRecognizer(panGesture)
        
        // Label
        ratingPointLabel.text = "0.0"
        
        self.addSubview(howToLabel)
        howToLabel.text = "Drag up and down to rate"
        howToLabel.sizeToFit()
        howToLabel.translatesAutoresizingMaskIntoConstraints = false
        howToLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        howToLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -44).isActive = true
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        smileyLine = CAShapeLayer()
        smileyLine.path = drawSmileyPath()
        smileyLine.fillColor = nil
        smileyLine.lineWidth = 6.0
        smileyLine.lineCap = kCALineCapRound
        smileyLine.strokeColor = UIColor(red:0.89, green:0.36, blue:0.38, alpha:1.0).cgColor
        contentView.layer.addSublayer(smileyLine)
    }
    
    @objc fileprivate func panOnView(_ regonizer: UIPanGestureRecognizer) {
        switch regonizer.state {
        case .began:
            startingPoint = regonizer.translation(in: self)
            print("began : \(startingPoint) \(currentPoint) \(lastDeltaY)")
        case .changed:
            currentPoint = regonizer.translation(in: self)
            deltaY = currentPoint.y - startingPoint.y
//            print("deltaY : \(deltaY)")
            

            smileyLine.path = drawSmileyPath(from: deltaY)
            
            
            
        case .cancelled, .ended:
            lastPoint = regonizer.translation(in: self)
            
//            let delta = currentPoint.y - startingPoint.y
            lastDeltaY = max(-45, min(45, deltaY))
            
            print("cancelled \(lastDeltaY)")
            hide()
        default:
            return
        }
    }

}

extension SMLRatingControl {
    fileprivate func drawOValLinePath() -> CGPath {
        print("center : \(self.center)")
//        let path = UIBezierPath(ovalIn: CGRect(origin: self.center, size: CGSize(width: self.frame.width - 40, height: self.frame.width - 40)))
        let width = self.frame.width - 80
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: width, height: width))
        return path.cgPath
    }
    
    fileprivate func drawSmileyPath(from delta: CGFloat) -> CGPath {
        
        // min = -45 : max = 45
        factor = max(-45, min(45, delta + lastDeltaY))
        
        
        let startingPoint = CGPoint(x: contentView.frame.width*0.20, y: contentView.frame.height*0.75)
        let endPoint = CGPoint(x: contentView.frame.width*0.80, y: contentView.frame.height*0.75)
        
        let xx = lastDeltaY/300
        let mdYFactor = 0.75+(factor/300)
        
        /*
        let minYPoint = contentView.frame.height*0.60
        let maxYPoint = contentView.frame.height*0.90
        let middleYPoint = contentView.frame.height*0.75
        */
//        print("factor : \(factor) \(mdYFactor)")
        
        print("\(delta) \(factor) \(lastDeltaY) \(xx)")
        
        let middlePoint = CGPoint(x: contentView.frame.width/2, y: contentView.frame.height*mdYFactor)

        
        let midPathControlPoint = CGPoint(x: contentView.frame.width*0.30, y: contentView.frame.width*mdYFactor)
        
        
        let endPathControlPoint = CGPoint(x: contentView.frame.width*0.70, y: contentView.frame.width*mdYFactor)
        
        // Draw Path
        let path = UIBezierPath()
        path.move(to: startingPoint)
        
        path.addCurve(to: middlePoint, controlPoint1: startingPoint, controlPoint2: midPathControlPoint)
//
        path.addCurve(to: endPoint, controlPoint1: endPathControlPoint, controlPoint2: endPoint)
        
//        path.addQuadCurve(to: endPoint, controlPoint: middlePoint)
        
        return path.cgPath
    }
    
    fileprivate func drawSmileyPath() -> CGPath {
        let startingPoint = CGPoint(x: contentView.frame.width*0.20, y: contentView.frame.height*0.75)
        let endPoint = CGPoint(x: contentView.frame.width*0.80, y: contentView.frame.height*0.75)
        
        let middlePoint = CGPoint(x: contentView.frame.width/2, y: contentView.frame.height*0.75)
        
        let mdPathControlPoint = CGPoint(x: contentView.frame.width*0.30, y: contentView.frame.width*0.75)
        
        
        let endPathControlPoint = CGPoint(x: contentView.frame.width*0.70, y: contentView.frame.width*0.75)
        
        // Draw Path
        let path = UIBezierPath()
        path.move(to: startingPoint)
        
        path.addCurve(to: middlePoint, controlPoint1: startingPoint, controlPoint2: mdPathControlPoint)
        
        path.addCurve(to: endPoint, controlPoint1: endPathControlPoint, controlPoint2: endPoint)
        
        return path.cgPath
    }
}

extension SMLRatingControl {
    func show() {
        self.alpha = 0
        
        let window = UIApplication.shared.keyWindow! as UIWindow
        window.addSubview(self)
        
        UIView.animate(withDuration: 0.2, animations: {
            self.alpha = 1
        }, completion: { finished in
            
        })
    }
    
    fileprivate func hide() {
//        print("hide \(lastPoint)")
    }
}
