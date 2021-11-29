//
//  SignUpViewController.swift
//  Dokto
//
//  Created by Rupak on 11/11/21.
//

import UIKit
import SwiftUI

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var userTypeTableView: UITableView!
    
    var viewModel = SignUpViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.updateUIContents()
    }
}

//MARK: Action methods
extension SignUpViewController {
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: UITableViewDataSource, UITableViewDelegate methods
extension SignUpViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.typeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RegisterUserTypeTableViewCell") as? RegisterUserTypeTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        
        cell.updateWith(object: viewModel.typeList[indexPath.row])
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? RegisterUserTypeTableViewCell {
            cell.contentsView.animateWith(type: .zoomIn)
        }
        DispatchQueue.main.async {
            self.navigateWith(object: self.viewModel.typeList[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.frame.width * (30/108)
    }
}

//MARK: Other methods
extension SignUpViewController {
    
    func updateUIContents() {
        viewModel.loadUserTypes()
        userTypeTableView.reloadData()
    }
    
    func navigateWith(object: RegisterUserTypeDetails) {
        if object.type == .patient {
            if let controller = UIStoryboard.controller(with: .auth, type: PatientRegistrationViewController.self) {
                self.navigationController?.pushViewController(controller, animated: true)
            }
        }
        else if object.type == .clinic {
            if let contoller = UIStoryboard.controller(with: .clinicAuth, type: ClinicRegistrationViewController.self){
                self.navigationController?.pushViewController(contoller, animated: true)
            }
        }
    }
}
