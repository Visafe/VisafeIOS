//
//  BaseViewController.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import NVActivityIndicatorView
import SwiftMessages

class BaseViewController: UIViewController {

    var indicatorView: NVActivityIndicatorView!
    var viewLoading: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        configLoading()
    }
    
    func configLoading() {
        indicatorView = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 60, height: 60), type: .ballClipRotatePulse, color: UIColor.mainColorOrange())
        viewLoading = UIView(frame: view.bounds)
        viewLoading.backgroundColor = UIColor.clear
        viewLoading.addSubview(indicatorView)
    }
    
    override func present(_ viewControllerToPresent: UIViewController,
                            animated flag: Bool,
                            completion: (() -> Void)? = nil) {
        viewControllerToPresent.modalPresentationStyle = .fullScreen
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    
    func showLoading() {
        guard let window = UIApplication.shared.windows.last else { return }
        viewLoading.frame = window.bounds
        window.addSubview(viewLoading)
        indicatorView.center = viewLoading.center
        indicatorView.stopAnimating()
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.viewLoading.backgroundColor = UIColor(hexString: "000000", transparency: 0.2)
        } completion: { [weak self] (success) in
            guard let weakSelf = self else { return }
            weakSelf.indicatorView.startAnimating()
        }
    }
    
    func hideLoading(completion: (() -> Void)? = nil) {
        indicatorView.stopAnimating()
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.viewLoading.backgroundColor = UIColor.clear
        } completion: { [weak self] (success) in
            guard let weakSelf = self else { return }
            weakSelf.viewLoading.removeFromSuperview()
            completion?()
        }
    }
    
    func showMemssage(title: String, content: String?, completion: (() -> Void)? = nil) {
        guard let info = BaseMessageView.loadFromNib() else { return }
        info.binding(title: title, content: content)
        info.buttonTapHandler = { sender in
            completion?()
            SwiftMessages.hide()
        }
        showPopup(view: info)
    }
    
    func showError(title: String, content: String?, completion: (() -> Void)? = nil) {
        guard let info = BaseMessageView.loadFromNib() else { return }
        info.binding(title: title, content: content)
        info.imageType.image = UIImage(named: "error_icon")
        info.buttonTapHandler = { sender in
            completion?()
            SwiftMessages.hide()
        }
        showPopup(view: info)
    }
    
    func showPopup(view: MessageView) {
        var infoConfig = SwiftMessages.defaultConfig
        infoConfig.presentationStyle = .bottom
        infoConfig.duration = .forever
        infoConfig.dimMode = .blur(style: .dark, alpha: 0.2, interactive: true)
        infoConfig.presentationContext = .window(windowLevel: UIWindow.Level.normal)
        SwiftMessages.show(config: infoConfig, view: view)
    }
    
    func showConfirmDelete(title: String, acceptCompletion: (() -> Void)? = nil) {
        guard let info = ConfirmDeleteView.loadFromNib() else { return }
        info.nameLabel?.text = title
        info.acceptAction = {
            acceptCompletion?()
            SwiftMessages.hide()
        }
        showPopup(view: info)
    }
}
