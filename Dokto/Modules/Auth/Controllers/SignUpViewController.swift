//
//  SignUpViewController.swift
//  Dokto
//
//  Created by Rupak on 11/11/21.
//

import UIKit

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userTypeCollectionView: UICollectionView!
    
    var viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUIContents()
    }
}

//MARK: Action methods
extension SignUpViewController {
    
    @IBAction func loginAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UICollectionViewDataSource, UICollectionViewDelegate methods
extension SignUpViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.typeList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RegisterUserTypeCollectionViewCell", for: indexPath) as? RegisterUserTypeCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.updateWith(object: viewModel.typeList[indexPath.row])
        cell.typeButton.backgroundColor = viewModel.selectedIndex == indexPath.row ? .named(._2F97D3) : .named(._2F97D3)?.withAlphaComponent(0.2)
        
        //operation with selection
        cell.actionCompletion = { [weak self] object in
            if let index = self?.viewModel.typeList.firstIndex(where: {$0.type == object.type}) {
                self?.viewModel.selectedIndex = index
                collectionView.reloadData()
            }
        }
        
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout methods
extension SignUpViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let height = collectionView.frame.height
        return CGSize(width: height, height: height)
    }
}

//MARK: Other methods
extension SignUpViewController {
    
    func updateUIContents() {
        viewModel.loadUserTypes()
        userTypeCollectionView.reloadData()
    }
}
