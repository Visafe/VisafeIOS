//
//  ReportWebsiteVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/28/21.
//

import UIKit

class ReportWebsiteVC: BaseViewController {
    
    @IBOutlet weak var reportButton: UIButton!
    @IBOutlet weak var nameTextfield: BaseTextField!
    @IBOutlet weak var nameInfoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateView()
    }
    
    
    func updateView() {
        updateStateButtonContinue()
        
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .done, target: self, action: #selector(onClickLeftButton))

        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    @objc private func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func reportAction(_ sender: Any) {
        if validateInfo() {
            showLoading()
            CommonWorker.reportWebsite(url: nameTextfield.text!) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResult(result: result, error: error, code: responseCode)
            }
        }
    }

    func handleResult(result: BaseResult?, error: Error?, code: Int?) {
        if code == 200 {
            showMessage(title: "Gửi báo cáo thành công", content: "Thông tin báo cáo của bạn đã được Visafe tiếp nhận.") { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.dismiss(animated: true, completion: nil)
            }
        } else {
            showError(title: "Gửi báo cáo thất bại", content: result?.local_msg ?? "")
        }
    }
    
    func validateInfo() -> Bool {
        var success = true
        let name = nameTextfield.text ?? ""
        if name.isEmpty {
            nameInfoLabel.text = "Link website không được để trống"
            success = false
        } else if !name.isValidUrl {
            nameInfoLabel.text = "Link website không đúng định dạng"
            success = false
        }
        return success
    }
    
    func updateStateButtonContinue() {
        if (nameTextfield.text?.count ?? 0) == 0 {
            reportButton.backgroundColor = UIColor(hexString: "F8F8F8")
            reportButton.setTitleColor(UIColor(hexString: "111111"), for: .normal)
            reportButton.isUserInteractionEnabled = false
        } else {
            reportButton.backgroundColor = UIColor.mainColorOrange()
            reportButton.setTitleColor(UIColor.white, for: .normal)
            reportButton.isUserInteractionEnabled = true
        }
    }
    
    @IBAction func valueChanged(_ sender: BaseTextField) {
        updateStateButtonContinue()
    }
}


extension ReportWebsiteVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let field = textField as? BaseTextField else { return }
        if field.type != .error {
            field.setState(type: .active)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        guard let field = textField as? BaseTextField else { return }
        if field.type != .error {
            field.setState(type: .normal)
        }
    }
}
