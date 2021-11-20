//
//  AbstractViewController.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

class AbstractViewController: UIViewController {

    var keyboardHeight: CGFloat = 0
    var keyboardStateChangeCompletion: ((Bool, CGFloat) -> ())?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

//MARK: Keyboard state methods
extension AbstractViewController {
    
    func addKeyboardObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func removeKeyboardObserver() {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            self.keyboardStateChangeCompletion?(true, self.keyboardHeight)
        }
    }
    @objc func keyboardWillHide(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardSize.height
            self.keyboardStateChangeCompletion?(false, 0)
        }
    }
}
