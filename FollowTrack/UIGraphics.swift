//
//  UIGraphics.swift
//  Farmer Messenger
//
//  Created by Luca Soldi on 01/02/17.
//  Copyright © 2017 Luca Soldi. All rights reserved.
//

import UIKit
import Foundation

@IBDesignable
public class RoundRectButton: UIButton {
    
    // MARK: Public interface
    /// Corner radius of the background rectangle
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        self.setBackgroundColor(color: UIColor(hex:"73D0F4"), forState: UIControlState.highlighted)
        
    }
    @IBInspectable public var roundRectCornerRadius: CGFloat = 5 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var roundRectBorderWidth: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var roundRectBorderColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Overrides
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    private func layoutRoundRectLayer() {
        self.layer.cornerRadius = roundRectCornerRadius
        self.layer.borderWidth = roundRectBorderWidth
        self.layer.borderColor = roundRectBorderColor.cgColor
    }
}


protocol RoundRectButtonMapDelegate: class {
    func positionButtonPressed()
}

@IBDesignable
public class RoundRectButtonMap: UIView, UIGestureRecognizerDelegate {
    
    // MARK: Public interface
    /// Corner radius of the background rectangle
    weak var delegate: RoundRectButtonMapDelegate?
    
    fileprivate var circleLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var plusLayer: CAShapeLayer = CAShapeLayer()
    fileprivate var tintLayer: CAShapeLayer = CAShapeLayer()
    @IBInspectable open var overlayColor: UIColor = UIColor.black.withAlphaComponent(0.3)
    fileprivate var overlayView : UIControl = UIControl()
    fileprivate var buttonImageView: UIImageView = UIImageView()
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        //self.setBackgroundColor(color: UIColor(hex:"73D0F4"), forState: UIControlState.highlighted)
        
    }
    @IBInspectable public var roundRectCornerRadius: CGFloat = 5 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var roundRectBorderWidth: CGFloat = 0 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    @IBInspectable public var roundRectBorderColor: UIColor = UIColor.black {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // MARK: Overrides
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    private func layoutRoundRectLayer() {
        setCircleLayer()
        setShadow()
        //setPlusLayer()
        setButtonImage()
        setupTapGesture()
    }
    
    fileprivate func setCircleLayer() {
        circleLayer.removeFromSuperlayer()
        circleLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        circleLayer.backgroundColor =  UIColor(hex:"73D0F4").cgColor
        circleLayer.cornerRadius = 50/2
        layer.addSublayer(circleLayer)
    }
    
    fileprivate func setShadow() {
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowRadius = 2
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.4
    }
    
    fileprivate func setPlusLayer() {
        plusLayer.removeFromSuperlayer()
        plusLayer.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        plusLayer.lineCap = kCALineCapRound
        plusLayer.strokeColor = UIColor.black.cgColor
        plusLayer.lineWidth = 2.0
        plusLayer.path = plusBezierPath().cgPath
        layer.addSublayer(plusLayer)
    }
    
    fileprivate func setTintLayer() {
        circleLayer.backgroundColor = UIColor(hex:"73D0F4").withAlphaComponent(0.9).cgColor
    }
    
    fileprivate func resetTintLayer() {
        circleLayer.backgroundColor = UIColor(hex:"73D0F4").cgColor
    }
    
    fileprivate func setupTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(RoundRectButtonMap.handleTap(_:)))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    func handleTap(_ sender: UITapGestureRecognizer) {
        delegate?.positionButtonPressed()
        resetTintLayer()
    }
    
    fileprivate func plusBezierPath() -> UIBezierPath {
        let path = UIBezierPath()
        path.move(to: CGPoint(x: 50/2, y: 50/3))
        path.addLine(to: CGPoint(x: 50/2, y: 50-50/3))
        path.move(to: CGPoint(x: 50/3, y: 50/2))
        path.addLine(to: CGPoint(x: 50-50/3, y: 50/2))
        return path
    }
    
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if isTouched(touches) {
            setTintLayer()
        }
    }
    
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        resetTintLayer()
    }
    
    fileprivate func isTouched(_ touches: Set<UITouch>) -> Bool {
        return touches.count == 1 && touches.first?.tapCount == 1 && touches.first?.location(in: self) != nil
    }
    
    fileprivate func setButtonImage() {
        buttonImageView.removeFromSuperview()
        buttonImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        buttonImageView.center = CGPoint(x: 50/2, y: 50/2)
        buttonImageView.contentMode = UIViewContentMode.scaleAspectFill
        buttonImageView.image = Graphics.imageOfPositionicon()
        buttonImageView.tintColor = UIColor.black
//        buttonImageView.frame = CGRect(
//            x: circleLayer.frame.origin.x + (50 / 2 - buttonImageView.frame.size.width / 2),
//            y: circleLayer.frame.origin.y + (50 / 2 - buttonImageView.frame.size.height / 2),
//            width: buttonImageView.frame.size.width,
//            height: buttonImageView.frame.size.height
//        )
        
        addSubview(buttonImageView)
    }
}

public class RoundRectView: UIView {
    
    @IBInspectable public var roundRectCornerRadius: CGFloat = 5 {
        didSet {
            self.setNeedsLayout()
        }
    }
    
    // Mark: Overrides
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    public func layoutRoundRectLayer() {
        self.layer.cornerRadius = roundRectCornerRadius
    }
    
}


public class ProfileImage: UIImageView {
    
    // Mark: Overrides
    override public func layoutSubviews() {
        super.layoutSubviews()
        layoutRoundRectLayer()
    }
    
    public func layoutRoundRectLayer() {
        self.layer.cornerRadius = self.frame.size.height/2
        self.layer.masksToBounds = true
        self.layer.borderWidth = 0
    }
}



class PassThroughView: UIStackView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        for subview in subviews {
            if !subview.isHidden && subview.alpha > 0 && subview.isUserInteractionEnabled && subview.point(inside: convert(point, to: subview), with: event) {
                return true
            }
        }
        return false
    }
}

extension UIImageView
{
    func addBlurEffect()
    {
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.regular)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight] // for supporting device rotation
        self.addSubview(blurEffectView)
    }
}



