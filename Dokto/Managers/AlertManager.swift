//
//  AlertManager.swift
//  Dokto
//
//  Created by Rupak on 10/24/21.
//

import UIKit

struct CustomAlertAction {
    var index = 0
    var title = ""
    var style: UIAlertAction.Style = .default
    
    init(index: Int, title: String = "ok", style: UIAlertAction.Style = .default) {
        self.index = index
        self.title = title
        self.style = style
    }
}

class AlertManager {
    
    static func showAlert(title: String?, message: String? = nil, style: UIAlertController.Style = .alert, actions: [CustomAlertAction] = [], completion: ((_ action: CustomAlertAction) -> ())? = nil) {
        let controller = UIAlertController.init(title: title, message: message, preferredStyle: style)
        for action in actions {
            controller.addAction(UIAlertAction.init(title: action.title, style: .default, handler: { (alertAction) in
                completion?(action)
            }))
        }
        if actions.count == 0 {
            controller.addAction(UIAlertAction.init(title: "OK", style: .cancel, handler: nil))
        }
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
        }
    }
}

//MARK: Permission related
extension AlertManager {
    
    static func showLibraryPermissionAlert() {
        let actions: [CustomAlertAction] = [.init(index: 0, title: "Cancel", style: .cancel),
                                            .init(index: 1, title: "OK", style: .default)]
        
        showAlert(title: "Photo library permission not available, please enable and try again later", message: nil, style: .alert, actions: actions) { (alertAction) in
            if alertAction.index == 1, let url = URL(string: UIApplication.openSettingsURLString) {
                openUrl(url: url)
            }
        }
    }
    
    static func showCameraPermissionAlert() {
        let actions: [CustomAlertAction] = [.init(index: 0, title: "Cancel", style: .cancel),
                                            .init(index: 1, title: "OK", style: .default)]
        
        showAlert(title: "Camera permission not available, please enable and try again later", message: nil, style: .alert, actions: actions) { (alertAction) in
            if alertAction.index == 1, let url = URL(string: UIApplication.openSettingsURLString) {
                openUrl(url: url)
            }
        }
    }
    
    static func openUrl(url: URL) {
        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
