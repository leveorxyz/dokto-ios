//
//  UIView.swift
//  Dokto
//
//  Created by Rupak on 10/23/21.
//

import UIKit

enum AnimationType {
    case zoomOut, zoomIn
}

extension UIView {
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var borderColor: UIColor {
        get {
            return UIColor(cgColor: layer.borderColor ?? UIColor.white.cgColor)
        }
        set {
            layer.borderColor = newValue.cgColor
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var makeCircular: Bool {
        get {
            return false
        }
        set {
            if newValue {
                layer.cornerRadius = self.frame.size.width/2.0
                setNeedsLayout()
            }
        }
    }
    
    @IBInspectable var makeAutoRound: Bool {
        get {
            return false
        }
        set {
            layer.cornerRadius = min(bounds.width, bounds.height)/2
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
            setNeedsLayout()
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
            setNeedsLayout()
        }
    }
    
    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
}

//MARK: Other methods
extension UIView {
    
    func addBlurView(with style: UIBlurEffect.Style, bgColor: UIColor = .clear) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.backgroundColor = bgColor
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if self.subviews.first?.isKind(of: UIVisualEffectView.classForCoder()) == true {
            self.subviews.first?.removeFromSuperview()
            self.insertSubview(blurEffectView, at: 0)
        } else {
            self.insertSubview(blurEffectView, at: 0)
        }
    }
    
    func animateWith(type: AnimationType) {
        if type == .zoomOut {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
            } completion: { (success) in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                } completion: { (success) in}
            }
        } else if type == .zoomIn {
            UIView.animate(withDuration: 0.2) {
                self.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            } completion: { (success) in
                UIView.animate(withDuration: 0.1) {
                    self.transform = .identity
                } completion: { (success) in}
            }
        }
    }
}
