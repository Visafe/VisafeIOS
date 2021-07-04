//
//  AdministrationVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 6/22/21.
//

import UIKit
import SideMenuSwift

class AdministrationVC: BaseViewController {
    
    var pageViewController: UIPageViewController!
    let dashboardVC = DashboardVC()
    let groupVC = GroupVC()
    let configVC = ConfigVC()
    let hightSegment: CGFloat = 60
    
    @IBOutlet weak var headerSegmented: UISegmentedControl!

    override func viewDidLoad() {
        super.viewDidLoad()
        configBarButtonItem()
        configSideMenu()
        configSegmentControl()
        configPageView()
    }
    
    @objc private func onClickLeftButton() {
        sideMenuController?.revealMenu()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let heightPage = kScreenHeight - kNavigationHeight - kTabbarHeight - hightSegment
        pageViewController.view.frame = CGRect(x: 0, y: kNavigationHeight + hightSegment, width: kScreenWidth, height: heightPage)
    }
    
    func configSegmentControl() {
        headerSegmented.selectedSegmentIndex = 1
    }
    
    func configPageView() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([groupVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        self.view.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        self.pageViewController.didMove(toParent: self)
    }
    
    func configBarButtonItem() {
        // left
        let leftBarButton = UIBarButtonItem(image: UIImage(named: "threedot-icon"), style: .done, target: self, action: #selector(onClickLeftButton))
        navigationItem.leftBarButtonItem = leftBarButton
        // right
        let notifiBarButton = UIBarButtonItem(image: UIImage(named: "notifi_icon"), style: .done, target: self, action: #selector(onClickNotifiButton))
        navigationItem.rightBarButtonItem = notifiBarButton
    }
    
    func onChangeWorkspace(workspace: WorkspaceModel?) {
        title = workspace?.name ?? "Quản trị"
    }
    
    func configSideMenu() {
        sideMenuController?.delegate = self
    }
    
    @objc private func onClickNotifiButton() {
        
    }
    
    @IBAction func indexChanged(_ sender: UISegmentedControl) {
        if pageViewController.viewControllers?.first is DashboardVC {
            if sender.selectedSegmentIndex == 1 {
                pageViewController.setViewControllers([groupVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
            } else if sender.selectedSegmentIndex == 2 {
                pageViewController.setViewControllers([configVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
            }
        } else if pageViewController.viewControllers?.first is GroupVC {
            if sender.selectedSegmentIndex == 0 {
                pageViewController.setViewControllers([dashboardVC], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
            } else if sender.selectedSegmentIndex == 2 {
                pageViewController.setViewControllers([configVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
            }
        } else if pageViewController.viewControllers?.first is ConfigVC  {
            if sender.selectedSegmentIndex == 0 {
                pageViewController.setViewControllers([dashboardVC], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
            } else if sender.selectedSegmentIndex == 1 {
                pageViewController.setViewControllers([groupVC], direction: UIPageViewController.NavigationDirection.reverse, animated: true, completion: nil)
            }
        }
    }
}

extension AdministrationVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 2
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController is ConfigVC {
            return groupVC
        } else if viewController is GroupVC {
            return dashboardVC
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController is DashboardVC {
            return groupVC
        } else if viewController is GroupVC {
            return configVC
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
        if pageViewController.viewControllers?.first is DashboardVC {
            headerSegmented.selectedSegmentIndex = 0
        } else if pageViewController.viewControllers?.first is GroupVC {
            headerSegmented.selectedSegmentIndex = 1
        } else {
            headerSegmented.selectedSegmentIndex = 2
        }
    }
}

extension AdministrationVC: SideMenuControllerDelegate {
    func sideMenuController(_ sideMenuController: SideMenuController,
                            animationControllerFrom fromVC: UIViewController,
                            to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BasicTransitionAnimator(options: .transitionFlipFromLeft, duration: 0.6)
    }
}

