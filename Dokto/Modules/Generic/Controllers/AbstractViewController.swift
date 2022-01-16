//
//  AbstractViewController.swift
//  Dokto
//
//  Created by Rupak on 11/21/21.
//

import UIKit

struct PickerSelectionConfig {
    var minDate: Date?
    var maxDate: Date?
    var selectedDate: Date?
    var mode: UIDatePicker.Mode = .date
    
    init(selectedDate: Date?, mode: UIDatePicker.Mode = .date) {
        self.selectedDate = selectedDate
        self.mode = mode
    }
    
    init(minDate: Date?, maxDate: Date?, selectedDate: Date?, mode: UIDatePicker.Mode = .date) {
        self.minDate = minDate
        self.maxDate = maxDate
        self.selectedDate = selectedDate
        self.mode = mode
    }
}

class BottomDelegate: NSObject, UITableViewDelegate, UITableViewDataSource{
    
    var idNames: [IDName] = [] {
        didSet {
            filteredList = idNames
        }
    }
    var filteredList = [IDName]()
    var itemSelected: ((_ result: Int)->())?
    
    override init() {
        super.init()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = filteredList[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        itemSelected?(indexPath.row)
    }
}

class BottomSearchDelegate: NSObject, UISearchBarDelegate {
    
    var searchText = ""
    var searchCompletion: ((_ text: String) -> Void)?
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        searchCompletion?(searchText)
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        self.searchText = ""
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        searchCompletion?(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.resignFirstResponder()
        if searchText.count > 0 {
            searchCompletion?(searchText)
        }
    }
}

class AbstractViewController: UIViewController {
    
    var keyboardHeight: CGFloat = 0
    var keyboardStateChangeCompletion: ((Bool, CGFloat) -> ())?
    
    var selectionPicker: UIPickerView!
    var selectionValues = [IDName]()
    var selectionValueIndex = 0
    var datePicker: UIDatePicker?
    var selectionCallback : ((IDName, Int) -> ())?
    var dateSelectionCompletion: ((Date?) -> Void)?
    var dateRangeSelectionCompletion: ((Date?, Date?) -> Void)?
    private var bottomDelegate = BottomDelegate()
    private let searchDelegate = BottomSearchDelegate()
    
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

//MARK: Selection related
extension AbstractViewController {
    
    func showPickerSelectionList(locationView: Any? = nil, title: String, objectList: [IDName], completion: @escaping(_ item: IDName,_ index: Int) -> Void) {
        
        selectionCallback = completion
        selectionValues = objectList
        selectionValueIndex = 0
        
        let message = "\n\n\n\n\n\n"
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alertController.isModalInPopover = true
        
        let pickerView = UIPickerView(frame: CGRect(x: 5, y: 20, width: self.view.frame.width - 20, height: 160))
        pickerView.delegate = self
        
        if AppUtility.isiPad() {
            let popoverContent = UIViewController.init()
            popoverContent.view = pickerView
            popoverContent.modalPresentationStyle = UIModalPresentationStyle.popover
            popoverContent.popoverPresentationController?.sourceView = (locationView as? UIView) ?? self.view
            popoverContent.popoverPresentationController?.permittedArrowDirections = .up
            popoverContent.popoverPresentationController?.sourceRect = (locationView as? UIView)?.bounds ?? CGRect.zero
            popoverContent.preferredContentSize = CGSize(width: self.view.frame.size.width/3.0, height: 160)
            if AppUtility.isiPad(), self.selectionValueIndex < self.selectionValues.count {
                selectionCallback?(self.selectionValues[self.selectionValueIndex],self.selectionValueIndex)
            }
            self.present(popoverContent, animated: true, completion: nil)
        } else {
            alertController.view.addSubview(pickerView)
            let doneAction = UIAlertAction.init(title: "Done", style: .default) { (alertAction) in
                if self.selectionValueIndex < self.selectionValues.count {
                    completion(self.selectionValues[self.selectionValueIndex],self.selectionValueIndex)
                }
            }
            alertController.addAction(doneAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }
}

//MARK: UIPickerViewDelegate, UIPickerViewDataSource related
extension AbstractViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return selectionValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selectionValues[row].name
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        selectionValueIndex = row
        if AppUtility.isiPad() {
            selectionCallback?(self.selectionValues[self.selectionValueIndex],self.selectionValueIndex)
        }
        self.view.endEditing(true)
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 44
    }
}

//MARK: Custom methods
extension AbstractViewController {
    
    //Bottom sheet
    func showSelectionList(title: String, objectList: [IDName], completion: @escaping(_ item: IDName,_ index: Int) -> Void) {
        let controller = BottomSheet.Controller()
        bottomDelegate.idNames = objectList
        bottomDelegate.itemSelected = { result in
            controller.dismiss()
            controller.dismiss(animated: true, completion: {
                completion(self.bottomDelegate.filteredList[result], result)
            })
        }
        
        controller.addNavigationbar { navigationBar in
            let item = UINavigationItem(title: title)
            let rightButton = UIBarButtonItem(title: "Dismiss", style: .plain, target: controller, action: #selector(BottomSheetController.dismiss(_:)))
            item.rightBarButtonItem = rightButton
            navigationBar.items = [item]
        }
        
        var listTableView: UITableView?
        controller.addTableView { [weak self] tableView in
            tableView.delegate = self?.bottomDelegate
            tableView.dataSource = self?.bottomDelegate
            tableView.rowHeight = UITableView.automaticDimension
            tableView.estimatedRowHeight = 60
            tableView.contentInset.top = 44
            tableView.scrollIndicatorInsets.top = 44
            listTableView = tableView
        }
        
        controller.addSearchBar { [weak self] (searchBar) in
            searchBar.placeholder = "Search here"
            searchBar.delegate = self?.searchDelegate
        }
        searchDelegate.searchCompletion = { [weak self] searchText in
            if searchText == "" {
                self?.bottomDelegate.filteredList = self?.bottomDelegate.idNames ?? []
            } else {
                self?.bottomDelegate.filteredList = objectList.filter({$0.name?.lowercased().contains(searchText.lowercased()) == true})
            }
            listTableView?.reloadData()
        }
        
        // customize
        controller.containerView.backgroundColor = .black
        controller.overlayBackgroundColor = UIColor.black.withAlphaComponent(0.6)
        controller.viewActionType = .tappedDismiss // .swipe
        controller.initializeHeight = UIScreen.main.bounds.height / 2
        DispatchQueue.main.async {
            UIApplication.topViewController()?.present(controller, animated: true, completion: nil)
        }
    }
}
