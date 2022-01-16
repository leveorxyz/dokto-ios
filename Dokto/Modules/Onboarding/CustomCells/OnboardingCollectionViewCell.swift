//
//  OnboardingCollectionViewCell.swift
//  Dokto
//
//  Created by Rupak on 11/19/21.
//

import UIKit

class OnboardingCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        self.imageView.contentMode = .scaleAspectFill
    }
    
    var model: OnboardingItemModel! {
        didSet {
            imageView.image = UIImage(named: model.imageName)
        }
    }
    
    override func prepareForReuse() {
        imageView.image = nil
    }
}
