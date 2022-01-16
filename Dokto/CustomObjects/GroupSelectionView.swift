//
//  GroupSelectionView.swift
//  Dokto
//
//  Created by Rupak on 11/30/21.
//

import UIKit

class CheckItemControl: UIControl {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkImageView: UIImageView!
}

class GroupSelectionView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkStackView: UIStackView!
    
    var selectedTag = -1
}

//MARK: Action methods
extension GroupSelectionView {
    
    @IBAction func clickAction(_ sender: CheckItemControl) {
        selectedTag = sender.tag
        self.updateViewWithTag()
    }
}

//MARK: Other methods
extension GroupSelectionView {
    
    func updateViewWithTag() {
        for view in checkStackView.subviews {
            if let item =  view as? CheckItemControl {
                item.checkImageView?.tintColor = .white.withAlphaComponent(0.5)
                if item.tag == self.selectedTag {
                    item.checkImageView.image = UIImage(named: "radio_filled")
                    item.checkImageView?.tintColor = .named(._A42BAD)
                } else {
                    item.checkImageView.image = UIImage(named: "radio_empty")
                }
            }
        }
    }
}
