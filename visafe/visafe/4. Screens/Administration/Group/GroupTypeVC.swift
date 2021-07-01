//
//  GroupTypeVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit
import TweeTextField

class GroupTypeVC: BaseViewController {
    
    @IBOutlet weak var bottomContraint: NSLayoutConstraint!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var nameTextfield: TweeAttributedTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var group: GroupModel
    var editMode: EditModeEnum
    
    var onContinue:(() -> Void)?
    
    init(group: GroupModel, editMode: EditModeEnum) {
        self.group = group
        self.editMode = editMode
        super.init(nibName: GroupTypeVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerTableView() {
        collectionView.registerCells(cells: [ChooseTypeGroupCell.className])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        updateView()
        configObserve()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func configObserve() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func updateView() {
        nameTextfield.text = group.name
        updateStateButtonContinue()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if validateInfo() {
            group.name = nameTextfield.text?.trim()
            onContinue?()
        }
    }
    
    @IBAction func edittingChanged(_ sender: TweeAttributedTextField) {
        group.name = sender.text
    }
    
    func validateInfo() -> Bool {
        var success = true
        let name = nameTextfield.text ?? ""
        if name.isEmpty {
            nameTextfield.showInfo("Tên nhóm không được để trống")
            success = false
        }
        return success
    }
    
    func updateStateButtonContinue() {
        if group.object_type.count == 0 {
            continueButton.backgroundColor = UIColor(hexString: "F8F8F8")
            continueButton.setTitleColor(UIColor(hexString: "111111"), for: .normal)
            continueButton.isUserInteractionEnabled = false
        } else {
            continueButton.backgroundColor = UIColor.mainColorOrange()
            continueButton.setTitleColor(UIColor.white, for: .normal)
            continueButton.isUserInteractionEnabled = true
        }
    }
    
    @objc func keyboardWillHide(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let _ = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                //key point 0,
                self.bottomContraint.constant =  8
                UIView.animate(withDuration: 0.25, animations: { () -> Void in self.view.layoutIfNeeded() })
            }
        }
    }
    
    @objc func keyboardWillShow(_ sender: Notification) {
        if let userInfo = (sender as NSNotification).userInfo {
            if let keyboardHeight = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue.size.height {
                self.bottomContraint.constant = keyboardHeight + 8
                
                UIView.animate(withDuration: 0.25, animations: { () -> Void in
                    self.view.layoutIfNeeded()
                })
            }
        }
    }
}


extension GroupTypeVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GroupTypeEnum.getAll().count
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseTypeGroupCell.className, for: indexPath as IndexPath) as? ChooseTypeGroupCell {
            cell.binding(group: group, type: GroupTypeEnum.getAll()[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = GroupTypeEnum.getAll()[indexPath.row]
        let index = group.object_type.firstIndex { (t) -> Bool in
            if t == type { return true } else { return false }
        } ?? -1
        if index >= 0 {
            group.object_type.remove(at: index)
        } else {
            group.object_type.append(type)
        }
        updateView()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth-60)/2, height: 40)
    }
}
