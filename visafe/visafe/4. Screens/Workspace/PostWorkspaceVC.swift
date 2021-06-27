//
//  PostWorkspaceVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/27/21.
//

import UIKit

public enum EditModeEnum: Int {
    case add = 1
    case update = 2
    case delete = 3
}

class PostWorkspaceVC: BaseViewController {
    
    @IBOutlet weak var segmentView: UIView!
    @IBOutlet weak var leadingSegment: NSLayoutConstraint!
    var editMode: EditModeEnum = .add
    var workspace: WorkspaceModel
    
    var pageViewController: UIPageViewController!
    let chooseTypeVC: ChooseTypeWorkspaceVC!
    let setupSecurityVC: SetupSecurityWorkspaceVC!
    let hightSegment: CGFloat = 2

    init(workspace: WorkspaceModel? = nil) {
        if let wsp = workspace {
            self.workspace = wsp
            editMode = .update
            chooseTypeVC = ChooseTypeWorkspaceVC(workspace: self.workspace, editMode: self.editMode)
            setupSecurityVC = SetupSecurityWorkspaceVC(workspace: self.workspace, editMode: self.editMode)
        } else {
            self.workspace = WorkspaceModel()
            editMode = .add
            chooseTypeVC = ChooseTypeWorkspaceVC(workspace: self.workspace, editMode: self.editMode)
            setupSecurityVC = SetupSecurityWorkspaceVC(workspace: self.workspace, editMode: self.editMode)
        }
        super.init(nibName: PostWorkspaceVC.className, bundle: nil)
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
        let heightPage = kScreenHeight - kNavigationHeight - kTabbarHeight - hightSegment
        pageViewController.view.frame = CGRect(x: 0, y: kNavigationHeight + hightSegment, width: kScreenWidth, height: heightPage)
    }
    
    func configPageView() {
        chooseTypeVC.onContinue = { [weak self] in
            guard let weakSelf = self else { return }
            weakSelf.pageViewController.setViewControllers([weakSelf.setupSecurityVC], direction: UIPageViewController.NavigationDirection.forward, animated: true) { (success) in
                weakSelf.updateHeaderSegmentedState()
            }
        }
        
        self.leadingSegment.constant = kScreenWidth/2
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([chooseTypeVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        pageViewController.isPagingEnabled = false
        self.view.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        self.pageViewController.didMove(toParent: self)
    }
    
    func configBarButtonItem() {
        // title
        title = "Tạo cấu hình mới"
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "cancel_icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
    }
}

extension PostWorkspaceVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is SetupSecurityWorkspaceVC {
            return chooseTypeVC
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is ChooseTypeWorkspaceVC {
            return setupSecurityVC
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
        if pageViewController.viewControllers?.first is ChooseTypeWorkspaceVC {
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
