//
//  BaseViewController.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import NVActivityIndicatorView

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
    
    func showLoading() {
        viewLoading.frame = view.bounds
        indicatorView.center = viewLoading.center
        indicatorView.stopAnimating()
        view.addSubview(viewLoading)
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.viewLoading.backgroundColor = UIColor(hexString: "000000", transparency: 0.2)
        } completion: { [weak self] (success) in
            guard let weakSelf = self else { return }
            weakSelf.indicatorView.startAnimating()
        }
    }
    
    func hideLoading() {
        indicatorView.stopAnimating()
        UIView.animate(withDuration: 0.2) { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.viewLoading.backgroundColor = UIColor.clear
        } completion: { [weak self] (success) in
            guard let weakSelf = self else { return }
            weakSelf.indicatorView.removeFromSuperview()
        }
    }
}
