//
//  ScanOverviewVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit
import ObjectMapper

class ScanOverviewVC: BaseViewController {

    @IBOutlet weak var scanButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var pageContentView: UIView!
    @IBOutlet weak var boundView: UIView!
    @IBOutlet weak var shadowView: UIView!
    
    var pageViewController: UIPageViewController!
    var listScanVC: [ScanVC] = []
    var paymentSuccess:(() -> Void)?
    var currentIndex = 0 {
        didSet {
            let text = (currentIndex == 0 || currentIndex == listScanVC.count - 1) ? "Quét": "Dừng"
            scanButton.setTitle(text, for: .normal)
            if currentIndex == listScanVC.count - 1 {
                CacheManager.shared.setLastScan()
            }
        }
    }
    var isStop = false
    override func viewDidLoad() {
        super.viewDidLoad()
        configPageView()
        let gradient = CAGradientLayer()
        gradient.frame = boundView.bounds
        gradient.colors = [UIColor.color_2C3163.cgColor, UIColor.color_030E37.cgColor]
        boundView.layer.insertSublayer(gradient, at: 0)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func configPageView() {
        for item in ScanDescriptionEnum.getAll() {
            let vc = ScanVC(type: item)
            vc.scanSuccess = scanSuccess(_:)
            listScanVC.append(vc)
        }
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        pageViewController.view.backgroundColor = .clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.isPagingEnabled = false
        pageViewController.setViewControllers([listScanVC.first!], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        self.pageContentView.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        self.pageViewController.didMove(toParent: self)
    }


    func scanSuccess(_ success: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.nextStep()
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanAction(_ sender: UIButton) {
        if (currentIndex == 0 || currentIndex == listScanVC.count - 1) {
            currentIndex = 0
            nextStep()
        } else {
            stopScan()
        }
    }

    func nextStep() {
        if currentIndex == listScanVC.count - 1 || isStop {
            return
        }
        currentIndex += 1
        gotoStep()
    }

    func stopScan() {
        isStop = true
        currentIndex = 0
        gotoStep(.reverse)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.isStop = false
        }
    }

    func gotoStep(_ direction: UIPageViewController.NavigationDirection = .forward) {
        guard let vc = listScanVC[safe: currentIndex] else {
            return
        }
        pageViewController.setViewControllers([vc], direction: direction, animated: true, completion: nil)
    }
}

extension ScanOverviewVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return listScanVC.count
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        for index in 0..<listScanVC.count {
            if viewController == listScanVC[index] {
                if index == 0 {
                    return nil
                } else {
                    return listScanVC[index-1]
                }
            }
        }
        return nil
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        for index in 0..<listScanVC.count {
            if viewController == listScanVC[index] {
                if index == (listScanVC.count - 1) {
                    return nil
                } else {
                    return listScanVC[index+1]
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
        for index in 0..<listScanVC.count {
            if pageViewController.viewControllers?.first == listScanVC[index] {
                if index == 0 {
                    pageControl.isHidden = true
                } else {
                    pageControl.isHidden = false
                    pageControl.currentPage = (index - 1)
                }
            }
        }
    }
}

extension UIView {
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        clipsToBounds = true
        if #available(iOS 11.0, *) {
            layer.cornerRadius = radius
            layer.maskedCorners = CACornerMask(rawValue: corners.rawValue)
        } else {
            //not avalable in ios 11 <
            self.layer.masksToBounds = true
            self.layer.cornerRadius = radius
        }
    }
}
