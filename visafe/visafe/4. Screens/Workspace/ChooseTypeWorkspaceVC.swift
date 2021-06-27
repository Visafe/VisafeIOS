//
//  ChooseTypeWorkspaceVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit
import TweeTextField

class ChooseTypeWorkspaceVC: BaseViewController {

    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var typeImageView: UIImageView!
    @IBOutlet weak var nameTextfield: TweeAttributedTextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var workspace: WorkspaceModel
    var editMode: EditModeEnum
    
    var onContinue:(() -> Void)?
    
    init(workspace: WorkspaceModel, editMode: EditModeEnum) {
        self.workspace = workspace
        self.editMode = editMode
        super.init(nibName: ChooseTypeWorkspaceVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func registerTableView() {
        collectionView.registerCells(cells: [ChooseTypeWorkspaceCell.className])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerTableView()
        updateView()
    }
    
    func updateView() {
        let type = workspace.type ?? .family
        typeImageView.image = type.getIcon()
        updateStateButtonContinue()
    }
    
    @IBAction func continueAction(_ sender: Any) {
        if validateInfo() {
            workspace.name = nameTextfield.text?.trim()
            onContinue?()
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let name = nameTextfield.text ?? ""
        if name.isEmpty {
            nameTextfield.showInfo("Tên cấu hình không được để trống")
            success = false
        }
        return success
    }
    
    func updateStateButtonContinue() {
        if workspace.type == nil {
            continueButton.backgroundColor = UIColor(hexString: "F8F8F8")
            continueButton.setTitleColor(UIColor(hexString: "111111"), for: .normal)
            continueButton.isUserInteractionEnabled = false
        } else {
            continueButton.backgroundColor = UIColor.mainColorOrange()
            continueButton.setTitleColor(UIColor.white, for: .normal)
            continueButton.isUserInteractionEnabled = true
        }
    }
}


extension ChooseTypeWorkspaceVC: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // tell the collection view how many cells to make
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return WorkspaceTypeEnum.getAll().count
    }
    // make a cell for each cell index path
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // get a reference to our storyboard cell
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ChooseTypeWorkspaceCell.className, for: indexPath as IndexPath) as? ChooseTypeWorkspaceCell {
            cell.binding(workspace: workspace, type: WorkspaceTypeEnum.getAll()[indexPath.row])
            return cell
        }
        return UICollectionViewCell()
    }
    
    // MARK: - UICollectionViewDelegate protocol
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let type = WorkspaceTypeEnum.getAll()[indexPath.row]
        workspace.type = type
        updateView()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (kScreenWidth-60)/2, height: 40)
    }
}
