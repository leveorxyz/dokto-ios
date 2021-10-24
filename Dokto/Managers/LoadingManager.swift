//
//  LoadingManager.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

class LoadingManager {

    static let shared = LoadingManager()
    
    var loadingView: LoadingAnimationView?
    
    static func showProgress(title: String? = nil) {
        DispatchQueue.main.async {
            guard let window = UIApplication.shared.delegate?.window else {return}
            if LoadingManager.shared.loadingView == nil {
                if let view = Bundle.main.loadNibNamed("LoadingAnimationView", owner: nil, options: nil)?.first as? LoadingAnimationView {
                    view.translatesAutoresizingMaskIntoConstraints = true
                    view.frame = window?.frame ?? CGRect.zero
                    LoadingManager.shared.loadingView?.tag = 101
                    LoadingManager.shared.loadingView = view
                }
            }
            if let view = LoadingManager.shared.loadingView, window?.viewWithTag(101) == nil {
                view.startAnimation()
                view.loadingTitle.isHidden = title == nil
                view.loadingTitle.text = title
                window?.addSubview(view)
            }
        }
    }
    
    static func hideProgress() {
        DispatchQueue.main.async {
            LoadingManager.shared.loadingView?.removeFromSuperview()
        }
    }
}
