//
//  OnboardingVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/6/21.
//

import UIKit

public enum OnboardingEnum: Int {
    case step1 = 1
    case step2 = 2
    case step3 = 3
    
    func getIconImage() -> UIImage? {
        switch self {
        case .step1:
            return UIImage(named: "onboarding_icon1")
        case .step2:
            return UIImage(named: "onboarding_icon2")
        case .step3:
            return UIImage(named: "onboarding_icon2")
        }
    }
    
    func getTitle() -> String? {
        switch self {
        case .step1:
            return "Chống lừa đảo, mã độc, tấn công mạng"
        case .step2:
            return "Chặn theo dõi, quảng cáo"
        case .step3:
            return "Quản lý truy cập, nội dung"
        }
    }
    
    func getContent() -> String? {
        switch self {
        case .step1:
            return "Phòng tránh nguy cơ, thiệt hại từ các cuộc tấn công mạng, lừa đảo trực tuyến"
        case .step2:
            return "Bảo đảm quyền riêng tư trên mạng & chặn các độc hại, khó chịu"
        case .step3:
            return "Tự quản lý, bảo đảm một không gian mạng xanh, sạch cho gia đình, tổ chức"
        }
    }
}

class OnboardingVC: BaseViewController {

    var pageViewController: UIPageViewController!
    
    @IBOutlet weak var mainView: UIView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var continueButton: UIButton!
    
    var step1: OnboardingChildVC!
    var step2: OnboardingChildVC!
    var step3: OnboardingChildVC!
    var currentPage: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configPageView()
    }
    
    @objc private func onClickLeftButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let heightPage: CGFloat = 430
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: mainView.width, height: heightPage)
    }
    
    func configPageView() {
        step1 = OnboardingChildVC(type: .step1)
        step2 = OnboardingChildVC(type: .step2)
        step3 = OnboardingChildVC(type: .step3)
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([step1], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        self.mainView.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        self.pageViewController.didMove(toParent: self)
    }
    
    @IBAction func continueAction(_ sender: UIButton) {
        switch currentPage {
        case 0:
            pageViewController.setViewControllers([step2], direction: UIPageViewController.NavigationDirection.forward, animated: true) { [weak self] (success) in
                guard let weakSelf = self else { return }
                if success {
                    weakSelf.updateSegmentedState()
                }
            }
        case 1:
            pageViewController.setViewControllers([step3], direction: UIPageViewController.NavigationDirection.forward, animated: true) { [weak self] (success) in
                guard let weakSelf = self else { return }
                if success {
                    weakSelf.updateSegmentedState()
                }
            }
        case 2:
            actionContinue()
        default:
            break
        }
    }
    
    func actionContinue() {
        CacheManager.shared.setIsShowOnboarding(value: true)
        AppDelegate.appDelegate()?.setRootVCToTabVC()
    }
}

extension OnboardingVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == step3 {
            return step2
        } else if viewController == step2 {
            return step1
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == step1 {
            return step2
        } else if viewController == step2 {
            return step3
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished && completed {
            updateSegmentedState()
        }
    }
    
    func updateSegmentedState() {
        if pageViewController.viewControllers?.first == step1 {
            currentPage = 0
            continueButton.setTitle("Tiếp tục", for: .normal)
        } else if pageViewController.viewControllers?.first == step2 {
            currentPage = 1
            continueButton.setTitle("Tiếp tục", for: .normal)
        } else {
            currentPage = 2
            continueButton.setTitle("Bắt đầu", for: .normal)
        }
        pageControl.currentPage = currentPage
    }
}
