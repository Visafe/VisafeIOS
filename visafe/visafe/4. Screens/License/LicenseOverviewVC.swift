//
//  LicenseOverviewVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit

class LicenseOverviewVC: BaseViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    var packages: [PackageModel] = []
    var pageViewController: UIPageViewController!
    var listPackageVC: [LicenseVC] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    func prepareData() {
        showLoading()
        PaymentWorker.getPackages { [weak self] (result, error) in
            guard let weakSelf = self else { return }
            weakSelf.packages = result?.sorted(by: { (m1, m2) -> Bool in
                return m1.name!.getIndex() < m2.name!.getIndex()
            }) ?? []
            weakSelf.hideLoading()
            weakSelf.configPageView()
        }
    }
    
    func configPageView() {
        guard packages.count > 0 else { return }
        for item in packages {
            let vc = LicenseVC(package: item)
            listPackageVC.append(vc)
        }
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        let heightPage = view.frame.height - kNavigationHeight - 32
        pageViewController.view.frame = CGRect(x: 0, y: kNavigationHeight, width: view.frame.width, height: heightPage)
        pageViewController.view.backgroundColor = .clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([listPackageVC.first!], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        self.view.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        self.pageViewController.didMove(toParent: self)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension LicenseOverviewVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return listPackageVC.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        for index in 0..<listPackageVC.count {
            if viewController == listPackageVC[index] {
                if index == 0 {
                    return nil
                } else {
                    return listPackageVC[index-1]
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        for index in 0..<listPackageVC.count {
            if viewController == listPackageVC[index] {
                if index == (listPackageVC.count - 1) {
                    return nil
                } else {
                    return listPackageVC[index+1]
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished && completed {
            updateHeaderSegmentedState()
        }
    }
    
    func updateHeaderSegmentedState() {
        for index in 0..<listPackageVC.count {
            if pageViewController.viewControllers?.first == listPackageVC[index] {
                pageControl.currentPage = index
            }
        }
    }
}
