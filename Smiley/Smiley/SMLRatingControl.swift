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
    fileprivate var deltaY: CGFloat = 0.0
    
    fileprivate var ovalLine: CAShapeLayer!
    fileprivate var smileyLine: CAShapeLayer!
    
    fileprivate var contentView: UIView!
    
    fileprivate let ratingPointLabel = UILabel()
    fileprivate let ratingPointDetail = UILabel()
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
//        contentView.backgroundColor = UIColor.darkGray
        contentView.center = self.center
        self.addSubview(contentView)
        
        ovalLine = CAShapeLayer()
        ovalLine.path = drawOValLinePath()
        ovalLine.lineWidth = 6.0
        ovalLine.strokeColor = UIColor(red:0.15, green:0.55, blue:0.87, alpha:1.0).cgColor
        ovalLine.fillColor = nil
        contentView.layer.addSublayer(ovalLine)
        
        smileyLine = CAShapeLayer()
        smileyLine.path = drawSmileyPath()
        smileyLine.fillColor = nil
        smileyLine.lineWidth = 6.0
        smileyLine.lineCap = kCALineCapRound
        smileyLine.strokeColor = UIColor(red:0.89, green:0.36, blue:0.38, alpha:1.0).cgColor
        contentView.layer.addSublayer(smileyLine)
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(panOnView(_:)))
        self.addGestureRecognizer(panGesture)
    }
    
    @objc fileprivate func panOnView(_ regonizer: UIPanGestureRecognizer) {
        switch regonizer.state {
        case .began:
            startingPoint = regonizer.translation(in: self)
            print("began : \(startingPoint)")
        case .changed:
            currentPoint = regonizer.translation(in: self)
            deltaY = currentPoint.y - startingPoint.y
            print("deltaY : \(deltaY)")
        case .cancelled:
            print("cancelled")
        case .ended:
            print("ended")
        default:
            return
        }
    }

}

extension SMLRatingControl {
    fileprivate func drawOValLinePath() -> CGPath {
        print("center : \(self.center)")
//        let path = UIBezierPath(ovalIn: CGRect(origin: self.center, size: CGSize(width: self.frame.width - 40, height: self.frame.width - 40)))
        let width = self.frame.width - 40
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: width, height: width))
        return path.cgPath
    }
    
    fileprivate func drawSmileyPath() -> CGPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: contentView.frame.width*0.25, y: contentView.frame.height*0.75))
        path.addLine(to: CGPoint(x: contentView.frame.width*0.75, y: contentView.frame.height*0.75))
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
        
    }
}
