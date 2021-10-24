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
    
    static func show(title: String?, message: String? = nil, style: UIAlertController.Style = .alert, actions: [CustomAlertAction] = [], completion: ((_ action: CustomAlertAction) -> ())? = nil) {
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
