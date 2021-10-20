//
//  AddGroupVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/23/21.
//

import UIKit

class PostGroupVC: BaseViewController {

    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var leadingSegment: NSLayoutConstraint!
    var editMode: EditModeEnum = .add
    var group: GroupModel
    var workspaceId: String?
    
    var pageViewController: UIPageViewController!
    let typeVC: GroupNameVC!
    let settingVC: GroupSettingParentVC!
    let timeVC: GroupTimeVC!
    let hightSegment: CGFloat = 2
    
    var onDone:(() -> Void)?

    init(group: GroupModel? = nil) {
        if let g = group {
            self.group = g
            editMode = .update
            typeVC = GroupNameVC(group: self.group, editMode: self.editMode)
            settingVC = GroupSettingParentVC(group: self.group, editMode: self.editMode)
            timeVC = GroupTimeVC(group: self.group, editMode: self.editMode)
        } else {
            self.group = GroupModel.getDefaultModel()
            self.group.workspace_id = CacheManager.shared.getCurrentWorkspace()?.id
            editMode = .add
            typeVC = GroupNameVC(group: self.group, editMode: self.editMode)
            settingVC = GroupSettingParentVC(group: self.group, editMode: self.editMode)
            timeVC = GroupTimeVC(group: self.group, editMode: self.editMode)
        }
        super.init(nibName: PostGroupVC.className, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configBarButtonItem()
        configPageView()
    }
    
    @objc private func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let heightPage = kScreenHeight - kNavigationHeight - hightSegment
        pageViewController.view.frame = CGRect(x: 0, y: kNavigationHeight + hightSegment, width: kScreenWidth, height: heightPage)
    }
    
    func configPageView() {
        typeVC.onContinue = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.pageViewController.setViewControllers([weakSelf.settingVC], direction: UIPageViewController.NavigationDirection.forward, animated: true) { (success) in
                weakSelf.updateHeaderSegmentedState()
            }
        }
        
        settingVC.onContinue = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.doneAction()
        }
        
        self.leadingSegment.constant = kScreenWidth/2
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([typeVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        pageViewController.isPagingEnabled = false
        self.view.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        self.pageViewController.didMove(toParent: self)
    }
    
    func configBarButtonItem() {
        if editMode == .add {
            title = "Thêm nhóm mới"
        } else {
            title = "Chỉnh sửa nhóm"
        }
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
    }
    
    func doneAction() {
        if editMode == .add {
            showLoading()
            GroupWorker.add(group: group) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                weakSelf.hideLoading()
                weakSelf.handleResponse(group: result, error: error, code: responseCode)
            }
        } else {
            let param = RenameGroupParam()
            param.group_id = group.groupid
            param.group_name = group.name
            showLoading()
            GroupWorker.rename(param: param) { [weak self] (result, error, responseCode) in
                guard let weakSelf = self else { return }
                GroupWorker.update(group: weakSelf.group) { [weak self] (result, error, responseCode) in
                    guard let weakSelf = self else { return }
                    weakSelf.hideLoading()
                    weakSelf.handleResponseUpdate(group: result, error: error, code: responseCode)
                }
            }
        }
    }
    
    func handleResponse(group: GroupModel?, error: Error?, code: Int?) {
        if code == 200 {
            showMessage(title: "Tạo nhóm thành công", content: "Nhóm của bạn đã được áp dụng các thiết lập mà bạn khởi tạo.") { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.dismiss(animated: true, completion: nil)
                weakSelf.onDone?()
            }
        } else {
            showError(title: "Tạo nhóm không thành công", content: group?.local_msg ?? "")
        }
    }
    
    func handleResponseUpdate(group: GroupModel?, error: Error?, code: Int?) {
        if code == 200 {
            showMessage(title: "Sửa nhóm thành công", content: "Nhóm của bạn đã được áp dụng các thiết lập mà bạn cập nhật.") { [weak self] in
                guard let weakSelf = self else { return }
                weakSelf.dismiss(animated: true, completion: nil)
                weakSelf.onDone?()
            }
        } else {
            showError(title: "Sửa nhóm không thành công", content: group?.local_msg ?? "")
        }
    }
}

extension PostGroupVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is GroupTimeVC {
            return settingVC
        } else if viewController is GroupSettingParentVC {
            return typeVC
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is GroupNameVC {
            return settingVC
        } else if viewController is GroupSettingVC {
            return timeVC
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished && completed {
            updateHeaderSegmentedState()
        }
    }
    
    func updateHeaderSegmentedState() {
        var leading: CGFloat = 0
        if pageViewController.viewControllers?.first is GroupNameVC {
            leading = kScreenWidth/2
        } else {
            leading = 0
        }
        UIView.animate(withDuration: 0.2) {
            self.leadingSegment.constant = leading
        } completion: { (success) in
            
        }
    }
}
