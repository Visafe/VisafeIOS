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
    @IBOutlet weak var borderView: CircularProgressView!
    
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
            if currentIndex == 0 {
                borderView.removeAnimation()
            }
            if currentIndex == listScanVC.count - 1 {
                return
            }
            self.borderView.setProgressWithAnimation(duration: 0.5,
                                                     toValue: Float(currentIndex)/4,
                                                     fromValue: Float((currentIndex - 1))/4)
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
        shadowView.dropShadow(color: .lightGray, opacity: 0.3, offSet: CGSize(width: -1, height: 1), radius: 40, scale: true)
        borderView.trackClr = UIColor.color_010D41
        borderView.progressClr = UIColor.color_FFB31F
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        pageViewController.view.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
    }
    
    func configPageView() {
        for item in ScanDescriptionEnum.getAll() {
            let vc = ScanVC(type: item)
            vc.scanSuccess = scanSuccess(_:_:)
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


    func scanSuccess(_ success: Bool, _ type: ScanDescriptionEnum) {
        if !success {
            let vc = listScanVC[safe: listScanVC.count - 1]
            switch type {
            case .protect:
                vc?.scanResult.append("Chế độ chống lừa đảo, mã độc, tấn công mạng chưa được kích hoạt!")
            case .wifi:
                vc?.scanResult.append("Wifi đang sử dụng là wifi không an toàn, vui lòng ngắt kết nối tới wifi này!")
            case .protocoll:
                vc?.scanResult.append("Phương thức bảo vệ không có!")
            case .system:
                vc?.scanResult.append("Hệ điều hành của bạn đang ở phiên bản quá cũ, bạn cần nâng cấp hệ điều hành cho thiết bị!")
            default:
                break
            }
        }
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
            listScanVC[safe: listScanVC.count - 1]?.scanResult.removeAll()
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

class CircularProgressView: UIView {
    var progressLyr = CAShapeLayer()
    var trackLyr = CAShapeLayer()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        makeCircularPath()
    }
    var progressClr = UIColor.white {
        didSet {
            progressLyr.strokeColor = progressClr.cgColor
        }
    }
    var trackClr = UIColor.white {
        didSet {
            trackLyr.strokeColor = trackClr.cgColor
        }
    }
    func makeCircularPath() {
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = 36
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width/2, y: frame.size.height/2), radius: (frame.size.width)/2, startAngle: CGFloat(-0.5 * .pi), endAngle: CGFloat(1.5 * .pi), clockwise: true)
        trackLyr.path = circlePath.cgPath
        trackLyr.fillColor = UIColor.clear.cgColor
        trackLyr.strokeColor = trackClr.cgColor
        trackLyr.lineWidth = 4
        trackLyr.strokeEnd = 1.0
        layer.addSublayer(trackLyr)
        progressLyr.path = circlePath.cgPath
        progressLyr.fillColor = UIColor.clear.cgColor
        progressLyr.strokeColor = progressClr.cgColor
        progressLyr.lineWidth = 4
        progressLyr.strokeEnd = 0.0
        layer.addSublayer(progressLyr)
    }
    func setProgressWithAnimation(duration: TimeInterval, toValue: Float, fromValue: Float) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = fromValue
        animation.toValue = toValue
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        progressLyr.strokeEnd = CGFloat(toValue)
        progressLyr.add(animation, forKey: "animateprogress")
    }

    func removeAnimation() {
        progressLyr.removeAnimation(forKey: "animateprogress")
    }
}
