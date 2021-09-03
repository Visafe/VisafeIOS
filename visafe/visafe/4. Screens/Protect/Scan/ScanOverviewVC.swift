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
    
    var pageViewController: UIPageViewController!
    var listScanVC: [ScanVC] = []
    var paymentSuccess:(() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scanButton.dropShadow(color: .lightGray, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 40, scale: true)
        configPageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func configPageView() {
        for item in ScanDescriptionEnum.getAll() {
            let vc = ScanVC(type: item)
            listScanVC.append(vc)
        }
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        pageViewController.view.backgroundColor = .clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        
        pageViewController.setViewControllers([listScanVC.first!], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        self.pageContentView.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        self.pageViewController.didMove(toParent: self)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func scanAction(_ sender: UIButton) {
        let button = UIButton(frame: sender.bounds)
        button.setBackgroundImage(UIImage(named: "scan_background"), for: .normal)

        let button2 = UIButton(frame: sender.bounds)
        button2.setBackgroundImage(UIImage(named: "scan_background_loading"), for: .normal)
        sender.addSubview(button)
        sender.addSubview(button2)

        let button3 = UIButton(frame: sender.bounds)
        button3.setBackgroundImage(UIImage(named: "scan_background_loading"), for: .normal)
        button3.transform = CGAffineTransform(rotationAngle: .pi/2)
        sender.addSubview(button3)

        let button4 = UIButton(frame: sender.bounds)
        button4.setBackgroundImage(UIImage(named: "scan_background_loading"), for: .normal)
        button4.transform = CGAffineTransform(rotationAngle: .pi)
        sender.addSubview(button4)

        let button5 = UIButton(frame: sender.bounds)
        button5.setBackgroundImage(UIImage(named: "scan_background_loading"), for: .normal)
        button5.transform = CGAffineTransform(rotationAngle: 3*(.pi)/2)
        sender.addSubview(button5)
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
