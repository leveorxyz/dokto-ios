//
//  LoadingAnimationView.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit
import Lottie

class LoadingAnimationView: UIView {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var animationView: AnimationView!
    @IBOutlet weak var loadingTitle: UILabel!
    
    func startAnimation() {
        animationView.alpha = 0.4
        animationView.contentMode = .scaleAspectFill
        animationView.loopMode = .loop
        animationView.animationSpeed = 1
        UIView.animate(withDuration: 0.3) {
            self.animationView.alpha = 1
        } completion: { (success) in
            self.animationView.play()
        }
    }
    
    func stopAnimation() {
        animationView.stop()
    }
}
