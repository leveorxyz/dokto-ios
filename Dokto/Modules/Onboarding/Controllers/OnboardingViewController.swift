//
//  OnboardingViewController.swift
//  Dokto
//
//  Created by Rupak on 11/19/21.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var onboardingCollectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var skipButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!
    
    var arrModels = [OnboardingItemModel]()
    let cellIdentifier = "OnboardingCollectionViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        self.onboardingCollectionView.delegate = self
        self.onboardingCollectionView.dataSource = self
        self.pageControl.hidesForSinglePage = true
        self.onboardingCollectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        loadModels()
        updatePageNumber()
    }
}

//MARK: Action methods
extension OnboardingViewController {
    
    @IBAction func skipAction(_ sender: Any) {
        navigateToLoginScreen()
    }
    
    @IBAction func getStartedAction(_ sender:UIButton) {
        navigateToLoginScreen()
    }
}

//MARK: UICollectionViewDataSource methods
extension OnboardingViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return arrModels.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as? OnboardingCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        cell.model = arrModels[indexPath.row]
        
        return cell
    }
}

//MARK: UICollectionViewDelegateFlowLayout methods
extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = self.view.frame.size
        return size
    }
}

//MARK: Other methods
extension OnboardingViewController {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        updatePageNumber()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        updatePageNumber()
    }
    
    func updatePageNumber() {
        pageControl.currentPage = Int(onboardingCollectionView.contentOffset.x) / Int(onboardingCollectionView.frame.width)
        getStartedButton.isHidden = pageControl.currentPage < pageControl.numberOfPages - 1
    }
    
    func loadModels() {
        for index in 1...3 {
            let name = "onboarding_\(index)"
            arrModels.append(OnboardingItemModel(imageName: name))
        }
        self.pageControl.numberOfPages = self.arrModels.count
        self.onboardingCollectionView.reloadData()
    }
    
    func navigateToLoginScreen() {
        UserDefaults.standard.set(true, forKey: Constants.Keys.UserDefaults.onboardingIsDisplayed)
        (UIApplication.shared.delegate as? AppDelegate)?.initiateRootViewController()
    }
}
