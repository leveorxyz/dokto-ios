//
//  DoctorRegistrationVC.swift
//  Dokto
//
//  Created by Rupak on 11/26/21.
//

import UIKit

class DoctorRegistrationVC: AbstractViewController {

    @IBOutlet weak var titleView: UIView!
    @IBOutlet weak var stepsCollectionView: UICollectionView!
    
    var currentItemIndex = 0
    var itemList = [String]()
    var completedItemList: Set<Int> = []
    var tabController: UITabBarController?
    var doctorSignUpViewModel = DoctorSignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadStepsData()
        self.initialSetup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.addKeyboardObserver()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.removeKeyboardObserver()
    }
}

//MARK: UICollectionViewDelegate, UICollectionViewDataSource methods
extension DoctorRegistrationVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PatientStepsCollectionViewCell", for: indexPath) as? PatientStepsCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let isCompleted = completedItemList.contains(indexPath.row) || indexPath.row == currentItemIndex
        cell.updateWith(item: itemList[indexPath.row], index: indexPath.row, isCompleted: isCompleted)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if currentItemIndex < tabController?.viewControllers?.count ?? 0 {
            if indexPath.row < currentItemIndex, completedItemList.contains(indexPath.row) {
                currentItemIndex = indexPath.row
                tabController?.selectedViewController = tabController?.viewControllers?[indexPath.row]
            } else if currentItemIndex != indexPath.row {
                if let controller = tabController?.viewControllers?[currentItemIndex] as? DoctorPersonalDetailsVC {
                    if controller.isValidInformation() {
                        controller.updatePatientSignUpRequestDetails()
                        completedItemList.insert(currentItemIndex)
                        currentItemIndex = indexPath.row
                        collectionView.reloadData()
                        tabController?.selectedViewController = tabController?.viewControllers?[indexPath.row]
                    }
                } else if let controller = tabController?.viewControllers?[currentItemIndex] as? DoctorIdentificationVC {
                    if controller.isValidInformation() {
                        controller.updatePatientSignUpRequestDetails()
                        completedItemList.insert(currentItemIndex)
                        currentItemIndex = indexPath.row
                        collectionView.reloadData()
                        tabController?.selectedViewController = tabController?.viewControllers?[indexPath.row]
                    }
                }
            }
        }
        collectionView.scrollToItem(at: IndexPath(row: currentItemIndex, section: 0), at: .centeredHorizontally, animated: true)
    }
}

//MARK: UICollectionViewDelegateFlowLayout methods
extension DoctorRegistrationVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.frame.width - 40) * 0.8
        return CGSize.init(width: width, height: collectionView.frame.height)
    }
}

//MARK: Other methods
extension DoctorRegistrationVC {
    
    func initialSetup() {
        if let controller = self.children.first as? UITabBarController {
            tabController = controller
            self.tabController?.tabBar.isHidden = true
        }
        
        //hide title section based on keyboard presence
        self.keyboardStateChangeCompletion = { [weak self] (isShowed, height) in
            DispatchQueue.main.async {
                self?.titleView.isHidden = isShowed
                UIView.animate(withDuration: 0.2) {
                    self?.view.layoutIfNeeded()
                }
            }
        }
        
        //controllers action listener
        for item in tabController?.viewControllers ?? [] {
            if let controller = item as? DoctorPersonalDetailsVC {
                controller.nextActionCompletion = { [weak self] success in
                    controller.updatePatientSignUpRequestDetails()
                    self?.completedItemList.insert(0)
                    self?.currentItemIndex = 1
                    self?.stepsCollectionView.reloadData()
                    self?.stepsCollectionView.scrollToItem(at: IndexPath(row: 1, section: 0), at: .centeredHorizontally, animated: true)
                    self?.selectTabController(with: 1)
                }
            } else if let controller = item as? DoctorIdentificationVC {
                controller.nextActionCompletion = { [weak self] success in
                    controller.updatePatientSignUpRequestDetails()
                    self?.completedItemList.insert(1)
                    self?.currentItemIndex = 2
                    self?.stepsCollectionView.reloadData()
                    self?.stepsCollectionView.scrollToItem(at: IndexPath(row: 2, section: 0), at: .centeredHorizontally, animated: true)
                    self?.selectTabController(with: 2)
                }
            } else if let controller = item as? DoctorEducationVC {
                controller.nextActionCompletion = { [weak self] success in
                    controller.updateDoctorSignUpRequestDetails()
                    self?.completedItemList.insert(2)
                    
                    //request for registration
                    let headers = ["X-CSRFToken" : Constants.Keys.Api.csrfToken]
                    LoadingManager.showProgress()
                    self?.doctorSignUpViewModel.signUp(with: headers) { object, error in
                        LoadingManager.hideProgress()
                        if object?.result != nil {
                            DispatchQueue.main.async {
                                self?.navigationController?.popToRootViewController(animated: true)
                            }
                        } else if let message = object?.message ?? error?.message {
                            AlertManager.showAlert(title: message)
                        }
                    }
                }
            }
        }
    }
    
    func loadStepsData() {
        itemList = ["Personal Details",
                    "Identification Verification",
                    "Ediucation Profile",
                    "Profession Profile"]
        stepsCollectionView.reloadData()
    }
    
    func selectTabController(with index: Int) {
        if index < tabController?.viewControllers?.count ?? 0 {
            tabController?.selectedIndex = index
        }
    }
}
