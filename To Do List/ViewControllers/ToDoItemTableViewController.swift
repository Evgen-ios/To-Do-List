//
//  ToDoItemTableViewController.swift
//  To Do List
//
//  Created by Evgeniy Goncharov on 30.09.2021.
//

import UIKit

class ToDoItemTableViewController: UITableViewController {
    
    // MARK: - Properties
    var isCheckInDatePikerCellShown: Bool = true
    var todo = ToDo()

    
    // MARK: - UIViewController Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

// MARK: - UITableViewDataSource
extension ToDoItemTableViewController /*: UITableViewDataSource */ {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let value = todo.values[indexPath.section]
        
        if let cell = tableView.cellForRow(at: indexPath) {
            return cell.isHidden ? 0 : UITableView.automaticDimension
        } else {
            return value is Date && indexPath.row == 1 && isCheckInDatePikerCellShown ? 0 :  UITableView.automaticDimension
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return todo.keys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let value = todo.values[section]
        
        // Check Row and return coutn section
        return value is Date ? 2 : 1
    }
    
    // Retern Conten Section
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let section = indexPath.section
        let value = todo.values[section]
        let cell = getCellFor(IndexPath: indexPath, with: value)
        return cell
    }
    
    // Retern Title for section tableView
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let key = todo.capitilisedKeys[section]
        return key
    }
}

// MARK: - UITableViewDelegate
extension ToDoItemTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let value = todo.values[indexPath.section]
        
        if value is Date {
            // TODO: Impliment show/hide date piker
            guard let _ = tableView.dequeueReusableCell(withIdentifier: "DateCell") as? DateCell else { return }
            isCheckInDatePikerCellShown.toggle()
            
            // Update Selected and add animations for tableView
            UIView.transition(with: tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {tableView.reloadData()}, completion: nil)
            
        } else if value is UIImage {
            
            let alert = UIAlertController(title: "Choose Source", message: nil, preferredStyle: .actionSheet)
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            alert.addAction(cancel)
            let imagePiker = SectionImagePikerController()
            imagePiker.delegate = self
            imagePiker.section = indexPath.section
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                let cameraAction = UIAlertAction(title: "Camera", style: .default) { action in
                    imagePiker.sourceType = .camera
                    self.present(imagePiker, animated: true)
                }
                alert.addAction(cameraAction)
            }
            
            if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
                let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default) { action in
                    imagePiker.sourceType = .photoLibrary
                    self.present(imagePiker, animated: true)
                }
                alert.addAction(photoLibraryAction)
            }
            present(alert, animated: true)
        }
    }
}


// MARK: - Cell Configurator



extension ToDoItemTableViewController {
    func getCellFor(IndexPath: IndexPath, with value: Any?) -> UITableViewCell {
        
        if let strinValue = value as? String {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
            cell.textField.section = IndexPath.section
            cell.textField.text = strinValue
            return cell
            
        } else if let dateValue = value as? Date {
            
            switch IndexPath.row {
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DateCell") as! DateCell
                cell.setDate(dateValue)
                return cell
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: "DatePikerCell") as! DatePikerCell
                cell.datePiker.addTarget(self, action: #selector(datePikerValueChanger(_:)), for: .valueChanged)
                cell.datePiker.date = dateValue
                cell.datePiker.section = IndexPath.section
                
                // Add minimun Date for DatePiker
                cell.datePiker.minimumDate = cell.datePiker.date.addingTimeInterval(60 * 60 * 24)
                cell.isHidden = isCheckInDatePikerCellShown
                return cell
                
            default:
                fatalError("Please add more prototype cell for Date section")
            }
            
        } else if let imageValue = value as? UIImage {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImageCell") as! ImageCell
            cell.largeImageView.image = imageValue
            return cell
            
        } else if let boolValue = value as? Bool {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SwitchCell") as! SwitchCell
            cell.switchView.addTarget(self, action: #selector(switchValueChanged(_:)), for: .valueChanged)
            cell.switchView.isOn = boolValue
            cell.switchView.section = IndexPath.section
            return cell
            
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell") as! TextFieldCell
            cell.textField.addTarget(self, action: #selector(textFieldValueChange(_:)), for: .editingChanged)
            cell.textField.section = IndexPath.section
            cell.textField.text = ""
            return cell
        }
    }
}


extension ToDoItemTableViewController {
    @objc func datePikerValueChanger(_ sender: SectionDatePiker) {
        let section = sender.section
        let key = todo.keys[section!]
        let date = sender.date
        todo.setValue(date, forKey: key)
        let labelIndexPatch = IndexPath(row: 0, section: section!)
        tableView.reloadRows(at: [labelIndexPatch], with: .automatic)
    }
    
    
    @objc func switchValueChanged(_ sender: SectionSwitch) {
        let key = todo.keys[sender.section!]
        let value = sender.isOn
        todo.setValue(value, forKey: key)
    }
    
    
    @objc func textFieldValueChange(_ sender: SectionTextField) {
        let key = todo.keys[sender.section!]
        let text = sender.text ?? ""
        todo.setValue(text, forKey: key)
    }

}

// MARK: - UIImagePickerControllerDelegate
extension ToDoItemTableViewController: UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        dismiss(animated: true)
        guard let image = info[.originalImage] as? UIImage else { return }
        guard let sectionPicker = picker as? SectionImagePikerController else { return }
        guard let section = sectionPicker.section else { return }
        let key = todo.keys[section]
        todo.setValue(image, forKey: key)
        let indexPath = IndexPath(row: 0, section: section)
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}


// MARK: - UINavigationControllerDelegate
extension ToDoItemTableViewController: UINavigationControllerDelegate {}
