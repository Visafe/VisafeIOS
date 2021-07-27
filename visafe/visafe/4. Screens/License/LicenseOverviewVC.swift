//
//  LicenseOverviewVC.swift
//  visafe
//
//  Created by Cuong Nguyen on 7/27/21.
//

import UIKit

public enum LicenseTypeEnum: Int {
    
    case premium = 0
    case family = 1
    case business = 2
    
    func getLogo() -> UIImage? {
        switch self {
        case .premium:
            return UIImage(named: "ic_license_premium")
        case .family:
            return UIImage(named: "ic_license_family")
        case .business:
            return UIImage(named: "ic_license_business")
        }
    }
    
    func getDesciption() -> String? {
        switch self {
        case .premium:
            return "Nâng cấp lên phiên bản Premium cho phép bạn truy cập không giới hạn tính năng của ứng dụng"
        case .family:
            return "Nâng cấp lên phiên bản Family cho phép bạn bảo vệ mọi thiết bị của thành viên trong gia đình"
        case .business:
            return "Nâng cấp lên phiên bản Business cho phép bạn quản lý và bảo vệ mọi thiết bị của thành viên trong công ty"
        }
    }
    
    func getListSource() -> [String] {
        switch self {
        case .premium:
            return ["Bảo vệ thiết bị", "Bảo vệ Wi-Fi", "Chặn theo dõi, quảng cáo không giới hạn", "Phân tích & Báo cáo", "Tối đa 3 thiết bị", "Quản lý tối đa 1 nhóm", "Hỗ trợ qua Chat/Call"]
        case .family:
            return ["Bảo vệ thiết bị", "Bảo vệ Wi-Fi", "Chặn theo dõi, quảng cáo không giới hạn", "Phân tích & Báo cáo", "Tối đa 9 thiết bị", "Quản lý tối đa 1 nhóm", "Hỗ trợ qua Chat/Call"]
        case .business:
            return ["Bảo vệ thiết bị", "Bảo vệ Wi-Fi", "Chặn theo dõi, quảng cáo không giới hạn", "Phân tích & Báo cáo", "Không giới hạn thiết bị", "Không giới hạn nhóm", "Hỗ trợ qua Hotline 24/7"]
        }
    }
    
    func getPriceYear() -> String {
        switch self {
        case .premium:
            return "49.000₫ / Năm"
        case .family:
            return "249.000₫ / Năm"
        case .business:
            return "Liên hệ"
        }
    }
    
    func getPriceMonth() -> String {
        switch self {
        case .premium:
            return "10.000₫ / Tháng"
        case .family:
            return "50.000₫ / Tháng"
        case .business:
            return "Liên hệ"
        }
    }
}

class LicenseOverviewVC: BaseViewController {

    @IBOutlet weak var pageControl: UIPageControl!
    
    var pageViewController: UIPageViewController!
    let premiumVC = LicenseVC(type: .premium)
    let familyVC = LicenseVC(type: .family)
    let businessVC = LicenseVC(type: .business)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configPageView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let window = UIApplication.shared.windows.last else { return }
        pageViewController.view.frame = CGRect(x: 0, y: window.safeAreaInsets.top + 44, width: kScreenWidth, height: kScreenHeight - window.safeAreaInsets.top - 44 - window.safeAreaInsets.bottom - 30)
    }
    
    func configPageView() {
        pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.view.backgroundColor = .clear
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.setViewControllers([premiumVC], direction: UIPageViewController.NavigationDirection.forward, animated: true, completion: nil)
        self.view.addSubview(pageViewController.view)
        self.addChild(pageViewController)
        self.pageViewController.didMove(toParent: self)
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func pageChanged(_ sender: UIPageControl) {
        switch sender.currentPage {
        case 0:
            pageViewController.setViewControllers([premiumVC], direction: UIPageViewController.NavigationDirection.forward, animated: true) { [weak self] (success) in
                guard let weakSelf = self else { return }
                if success {
                    weakSelf.updateHeaderSegmentedState()
                }
            }
        case 2:
            pageViewController.setViewControllers([businessVC], direction: UIPageViewController.NavigationDirection.reverse, animated: true) { [weak self] (success) in
                guard let weakSelf = self else { return }
                if success {
                    weakSelf.updateHeaderSegmentedState()
                }
            }
        case 1:
            if pageViewController.viewControllers?.first == premiumVC {
                pageViewController.setViewControllers([familyVC], direction: UIPageViewController.NavigationDirection.forward, animated: true) { [weak self] (success) in
                    guard let weakSelf = self else { return }
                    if success {
                        weakSelf.updateHeaderSegmentedState()
                    }
                }
            } else {
                pageViewController.setViewControllers([familyVC], direction: UIPageViewController.NavigationDirection.reverse, animated: true) { [weak self] (success) in
                    guard let weakSelf = self else { return }
                    if success {
                        weakSelf.updateHeaderSegmentedState()
                    }
                }
            }
        default:
            break
        }
    }
}

extension LicenseOverviewVC: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return 3
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if viewController == businessVC {
            return familyVC
        } else if viewController == familyVC {
            return premiumVC
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if viewController == premiumVC {
            return familyVC
        } else if viewController == familyVC {
            return businessVC
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
        if pageViewController.viewControllers?.first == premiumVC {
            pageControl.currentPage = 0
        } else if pageViewController.viewControllers?.first == familyVC {
            pageControl.currentPage = 1
        } else {
            pageControl.currentPage = 2
        }
    }
}
